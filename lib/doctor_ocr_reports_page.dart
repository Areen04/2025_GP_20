import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorOcrReportsPage extends StatefulWidget {
  final String childId;

  const DoctorOcrReportsPage({
    super.key,
    required this.childId,
  });

  @override
  State<DoctorOcrReportsPage> createState() => _DoctorOcrReportsPageState();
}

class _DoctorOcrReportsPageState extends State<DoctorOcrReportsPage> {
  bool _uploading = false;

  CollectionReference<Map<String, dynamic>> get _reportsCol =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .collection('medical_reports');

  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream() {
    return _reportsCol.orderBy("uploadedAt", descending: true).snapshots();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _toast("Invalid file URL.");
      return;
    }

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!ok) _toast("Couldn't open the file.");
  }

  /// OCR for images only (jpg/png)
  Future<String> _runOcrOnImage(String filePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(filePath);
      final result = await recognizer.processImage(input);
      return result.text.trim();
    } finally {
      await recognizer.close();
    }
  }

  /// Extract conditions from OCR text.
  /// Practical approach:
  /// - match from a keyword list
  /// - also capture lines under headings like diagnosis/assessment/impression
  List<String> _extractConditions(String text) {
    final lower = text.toLowerCase();

    // 1) keyword-based (you can extend this list later)
    const keywords = <String>[
      "asthma",
      "eczema",
      "allergy",
      "allergies",
      "diabetes",
      "anemia",
      "epilepsy",
      "seizure",
      "migraine",
      "bronchitis",
      "pneumonia",
      "otitis",
      "tonsillitis",
      "dermatitis",
      "urticaria",
      "rhinitis",
      "sinusitis",
      "constipation",
      "diarrhea",
      "influenza",
      "covid",
      "covid-19",
      "chickenpox",
      "varicella",
      "measles",
      "mumps",
      "thyroid",
      "adhd",
      "autism",
    ];

    final set = <String>{};

    for (final k in keywords) {
      if (lower.contains(k)) {
        // normalize display
        final nice = k
            .replaceAll("-", " ")
            .replaceAll("_", " ")
            .trim()
            .split(" ")
            .map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1)))
            .join(" ");
        set.add(nice);
      }
    }

    // 2) “diagnosis/assessment/impression” lines (very common in reports)
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    bool inDiagnosisBlock = false;

    for (final line in lines) {
      final l = line.toLowerCase();

      // Start of block
      if (l.startsWith("diagnosis") ||
          l.startsWith("diagnoses") ||
          l.startsWith("assessment") ||
          l.startsWith("impression") ||
          l.startsWith("problem list") ||
          l.startsWith("past medical history") ||
          l.startsWith("pmh")) {
        inDiagnosisBlock = true;
        continue;
      }

      // End block when we hit a new section
      if (inDiagnosisBlock &&
          (l.startsWith("plan") ||
              l.startsWith("treatment") ||
              l.startsWith("medications") ||
              l.startsWith("rx") ||
              l.startsWith("recommendation") ||
              l.startsWith("notes"))) {
        inDiagnosisBlock = false;
      }

      if (inDiagnosisBlock) {
        // If the line is short and looks like a condition line, add it
        // Examples: "- Asthma", "Eczema", "Allergic rhinitis"
        final cleaned = line
            .replaceAll(RegExp(r'^[\-\•\*\u2022]+\s*'), '')
            .replaceAll(RegExp(r'^\d+[\)\.\-]\s*'), '')
            .trim();

        // avoid super long noisy lines
        if (cleaned.length >= 3 && cleaned.length <= 40) {
          // avoid dates and pure numbers
          if (!RegExp(r'^\d+$').hasMatch(cleaned) &&
              !RegExp(r'^\d{1,2}[/\-]\d{1,2}[/\-]\d{2,4}$')
                  .hasMatch(cleaned)) {
            // Capitalize nicely
            final nice = cleaned
                .split(" ")
                .map((w) => w.isEmpty ? w : (w[0].toUpperCase() + w.substring(1)))
                .join(" ");
            set.add(nice);
          }
        }
      }
    }

    final list = set.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  Future<void> _pickAndUpload() async {
    if (_uploading) return;

    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: false,
    );

    if (res == null || res.files.isEmpty) return;

    final picked = res.files.first;
    final path = picked.path;
    if (path == null) return;

    final ext = (picked.extension ?? '').toLowerCase();
    final isImage = ['png', 'jpg', 'jpeg'].contains(ext);
    final isPdf = ext == 'pdf';

    if (!isImage && !isPdf) {
      _toast("Unsupported file type.");
      return;
    }

    setState(() => _uploading = true);

    DocumentReference<Map<String, dynamic>>? reportRef;

    try {
      final now = DateTime.now();

      // OCR (images only) BEFORE upload (we already have local file)
      String? extractedText;
      List<String> extractedConditions = [];

      if (isImage) {
        extractedText = await _runOcrOnImage(path);
        extractedConditions =
        extractedText.isEmpty ? [] : _extractConditions(extractedText);
      }

      // 1) Create Firestore doc
      reportRef = await _reportsCol.add({
        "fileName": picked.name,
        "fileType": isPdf ? "pdf" : "image",
        "status": isImage ? "done" : "pending_pdf_ocr", // honest status
        "uploadedAt": Timestamp.fromDate(now),
        "uploadedBy": FirebaseAuth.instance.currentUser?.uid,
        "fileUrl": null,

        // OCR fields
        "extractedText": isImage ? extractedText : null,
        "conditions": isImage ? extractedConditions : <String>[],
      });

      final reportId = reportRef.id;

      // 2) Upload to Storage
      final storagePath =
          "children/${widget.childId}/medical_reports/$reportId.$ext";
      final storageRef = FirebaseStorage.instance.ref(storagePath);

      await storageRef.putFile(
        File(path),
        SettableMetadata(
          contentType: isPdf ? "application/pdf" : "image/$ext",
        ),
      );

      final url = await storageRef.getDownloadURL();

      // 3) Update doc with URL
      await reportRef.update({"fileUrl": url});

      if (isPdf) {
        _toast("Uploaded ✅ (PDF OCR will be processed later)");
      } else {
        _toast("Uploaded ✅ OCR done");
      }
    } catch (e) {
      // cleanup: delete doc if created but failed
      try {
        await reportRef?.delete();
      } catch (_) {}
      _toast("Upload failed. Check permissions.");
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  List<String> _uniqueConditions(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) {
    final set = <String>{};

    for (final d in docs) {
      final data = d.data();
      final conditions = data["conditions"];
      if (conditions is List) {
        for (final c in conditions) {
          final s = (c ?? "").toString().trim();
          if (s.isNotEmpty) set.add(s);
        }
      }
    }

    final list = set.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topIconSize = screenWidth * 0.095;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Medical Conditions",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF9D5C7D),
            size: 23,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reportsStream(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];
          final conditions = _uniqueConditions(docs);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Upload Card
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'lib/icons/stethoscope.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF9D5C7D),
                          BlendMode.srcIn,
                        ),
                        width: topIconSize,
                        height: topIconSize,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Digitize Medical Reports",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Upload PDF or images and convert them using OCR.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          height: 1.4,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _uploading ? null : _pickAndUpload,
                          icon: _uploading
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(Icons.cloud_upload_outlined),
                          label:
                          Text(_uploading ? "Uploading..." : "Upload Report"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D5C7D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Medical Conditions
                const Text(
                  "Medical Conditions",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),

                if (conditions.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Text(
                      "No medical conditions recorded yet.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  )
                else
                  Column(
                    children: conditions
                        .map((c) => _ConditionTile(title: c))
                        .toList(),
                  ),

                const SizedBox(height: 26),

                // Old Reports
                const Text(
                  "Old Reports",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                if (docs.isEmpty)
                  const Text(
                    "No reports uploaded yet.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFF6F6F6F),
                    ),
                  )
                else
                  Column(
                    children: docs.map((d) {
                      final data = d.data();

                      final fileName =
                      (data["fileName"] ?? "Report").toString();
                      final type = (data["fileType"] ?? "").toString();
                      final url = (data["fileUrl"] ?? "").toString();
                      final status = (data["status"] ?? "").toString();

                      DateTime? dt;
                      final ts = data["uploadedAt"];
                      if (ts is Timestamp) dt = ts.toDate();

                      final dateText = dt != null
                          ? DateFormat("yyyy-MM-dd • HH:mm").format(dt)
                          : "";

                      final sub = [
                        type,
                        dateText,
                        if (status.isNotEmpty) "• $status",
                      ].join(" ");

                      return _ReportTile(
                        title: fileName,
                        subtitle: sub,
                        onTap: url.isEmpty ? null : () => _openUrl(url),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final String title;

  const _ConditionTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.description_outlined, color: Color(0xFF9D5C7D)),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ReportTile({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFF9D5C7D)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new_rounded, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
