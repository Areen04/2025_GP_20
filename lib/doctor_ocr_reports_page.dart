import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as im;
import 'package:intl/intl.dart';
import 'package:pdf_render_maintained/pdf_render.dart' as pr;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;
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
  static const _pink = Color(0xFF9D5C7D);

  bool _uploading = false;

  // expand state
  final Set<String> _expandedConditions = <String>{};

  // ✅ Allowed conditions only (Core + 30 skin + 10 general)
  static const List<String> allowedConditions = [
    // ===== Your core skin diseases =====
    "Atopic Dermatitis (Eczema)",
    "Eczema",
    "Hand-Foot-And-Mouth Disease",
    "Bacterial Skin Infection",
    "Warts and Viral Infections",

    // ===== 30 Common Skin Diseases =====
    "Contact Dermatitis",
    "Seborrheic Dermatitis",
    "Psoriasis",
    "Rosacea",
    "Acne Vulgaris",
    "Impetigo",
    "Cellulitis",
    "Fungal Infection",
    "Tinea Corporis",
    "Tinea Capitis",
    "Tinea Pedis",
    "Candidiasis",
    "Urticaria",
    "Scabies",
    "Molluscum Contagiosum",
    "Vitiligo",
    "Alopecia Areata",
    "Herpes Simplex",
    "Herpes Zoster",
    "Chickenpox",
    "Measles",
    "Ringworm",
    "Erythema Multiforme",
    "Lichen Planus",
    "Perioral Dermatitis",
    "Heat Rash",
    "Sunburn",
    "Keratosis Pilaris",
    "Diaper Rash",
    "Hives",

    // ===== 10 Common General Diseases =====
    "Asthma",
    "Diabetes",
    "Iron Deficiency Anemia",
    "Epilepsy",
    "ADHD",
    "Autism Spectrum Disorder",
    "Migraine",
    "Hypothyroidism",
    "Influenza",
    "Gastroenteritis",
  ];

  CollectionReference<Map<String, dynamic>> get _reportsCol =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .collection('medical_reports');

  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream() {
    return _reportsCol.orderBy("uploadedAt", descending: true).snapshots();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _toast("Invalid file URL.");
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) _toast("Couldn't open the file.");
  }

  // ---------- OCR helpers ----------

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

  /// ✅ PDF: try direct text extract first (sf), else rasterize 1 page (pr) + OCR
  Future<String> _runOcrOnPdfSafe(String pdfPath, {int maxPages = 1}) async {
    // 1) Try extracting embedded text (VERY LIGHT)
    try {
      final bytes = await File(pdfPath).readAsBytes();
      final sf.PdfDocument doc = sf.PdfDocument(inputBytes: bytes);
      final String text = sf.PdfTextExtractor(doc).extractText().trim();
      doc.dispose();
      if (text.isNotEmpty) return text;
    } catch (_) {
      // fallback
    }

    // 2) Fallback: rasterize low-res JPEG to avoid OOM
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    pr.PdfDocument? pdf;

    try {
      pdf = await pr.PdfDocument.openFile(pdfPath);

      final take = pdf.pageCount < maxPages ? pdf.pageCount : maxPages;
      final buffer = StringBuffer();

      for (int i = 1; i <= take; i++) {
        await Future.delayed(const Duration(milliseconds: 50));

        final page = await pdf.getPage(i);

        // ✅ low resolution
        const int targetWidth = 420;
        final int targetHeight =
        (targetWidth * page.height / page.width).round();

        final pageImage = await page.render(
          width: targetWidth,
          height: targetHeight,
        );

        final img = im.Image.fromBytes(
          width: pageImage.width,
          height: pageImage.height,
          bytes: pageImage.pixels.buffer,
          numChannels: 4,
        );

        // ✅ JPEG smaller than PNG
        final jpgBytes =
        Uint8List.fromList(im.encodeJpg(img, quality: 60));

        final tmpFile = File(
          "${Directory.systemTemp.path}/rafiq_pdf_ocr_${DateTime.now().millisecondsSinceEpoch}_p$i.jpg",
        );
        await tmpFile.writeAsBytes(jpgBytes);

        final input = InputImage.fromFilePath(tmpFile.path);
        final result = await recognizer.processImage(input);
        final txt = result.text.trim();

        if (txt.isNotEmpty) {
          buffer.writeln("----- Page $i -----");
          buffer.writeln(txt);
          buffer.writeln();
        }

        try {
          await tmpFile.delete();
        } catch (_) {}

        pageImage.dispose();
      }

      return buffer.toString().trim();
    } finally {
      await recognizer.close();
      await pdf?.dispose();
    }
  }

  // ---------- Conditions extraction (allowed list ONLY) ----------

  List<String> _extractConditionsFromAllowed(String text) {
    final lower = text.toLowerCase();
    final found = <String>{};

    for (final c in allowedConditions) {
      if (lower.contains(c.toLowerCase())) found.add(c);
    }

    if (found.contains("Eczema") &&
        found.contains("Atopic Dermatitis (Eczema)")) {
      found.remove("Eczema");
    }

    final list = found.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  // ---------- Upload ----------

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

      // 1) Create Firestore doc FIRST
      reportRef = await _reportsCol.add({
        "fileName": picked.name,
        "fileType": isPdf ? "pdf" : "image",
        "status": "uploading",
        "uploadedAt": Timestamp.fromDate(now),
        "uploadedBy": FirebaseAuth.instance.currentUser?.uid,
        "fileUrl": null,
        "extractedText": null,
        "conditions": <String>[],
      });

      final reportId = reportRef.id;

      // 2) Upload to Storage
      final storagePath =
          "children/${widget.childId}/medical_reports/$reportId.$ext";
      final storageRef = FirebaseStorage.instance.ref(storagePath);

      final contentType = isPdf
          ? "application/pdf"
          : (ext == "jpg" ? "image/jpeg" : "image/$ext");

      await storageRef.putFile(
        File(path),
        SettableMetadata(contentType: contentType),
      );

      final url = await storageRef.getDownloadURL();

      // 3) Update URL + uploaded status
      await reportRef.update({
        "fileUrl": url,
        "status": "uploaded",
      });



      // 4) OCR AFTER upload (safe)
      String extractedText = "";
      List<String> extractedConditions = [];

      try {
        if (isImage) {
          extractedText = await _runOcrOnImage(path);
        } else {
          extractedText = await _runOcrOnPdfSafe(path, maxPages: 1);
        }
      } catch (_) {
        extractedText = "";
      }

      if (extractedText.isNotEmpty) {
        extractedConditions = _extractConditionsFromAllowed(extractedText);

        await reportRef.update({
          "status": "done",
          "extractedText": extractedText,
          "conditions": extractedConditions,
        });


      } else {
        await reportRef.update({
          "status": isPdf ? "ocr_failed_pdf" : "ocr_failed",
          "extractedText": null,
          "conditions": <String>[],
        });

        _toast("OCR failed (upload saved).");
      }
    } catch (e) {
      try {
        await reportRef?.delete();
      } catch (_) {}
      _toast("Upload failed. Check permissions.");
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  // ---------- UI helpers ----------

  List<String> _uniqueConditions(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
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

  List<_ConditionReportText> _textsForCondition(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      String condition,
      ) {
    final out = <_ConditionReportText>[];

    for (final d in docs) {
      final data = d.data();
      final conds = data["conditions"];
      if (conds is! List) continue;

      final hasCondition =
      conds.any((x) => (x ?? "").toString().trim() == condition);
      if (!hasCondition) continue;

      final extractedText = (data["extractedText"] ?? "").toString().trim();
      if (extractedText.isEmpty) continue;

      DateTime? dt;
      final ts = data["uploadedAt"];
      if (ts is Timestamp) dt = ts.toDate();

      out.add(
        _ConditionReportText(
          whenText: dt != null ? DateFormat("yyyy-MM-dd • HH:mm").format(dt) : "",
          text: extractedText,
        ),
      );
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topIconSize = screenWidth * 0.10;

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
            color: _pink,
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
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
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
                      Icon(Icons.description_outlined,
                          color: _pink, size: topIconSize),
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
                          label: Text(_uploading ? "Uploading..." : "Upload Report"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pink,
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
                    children: conditions.map((c) {
                      final isOpen = _expandedConditions.contains(c);
                      final texts = _textsForCondition(docs, c);

                      return _ConditionTileChevronRight(
                        title: c,
                        isExpanded: isOpen,
                        onToggle: () {
                          setState(() {
                            if (isOpen) {
                              _expandedConditions.remove(c);
                            } else {
                              _expandedConditions.add(c);
                            }
                          });
                        },
                        texts: texts,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 26),

                // Previous Reports
                const Text(
                  "Previous Reports",
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

                      final fileName = (data["fileName"] ?? "Report").toString();
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

class _ConditionReportText {
  final String whenText;
  final String text;

  _ConditionReportText({required this.whenText, required this.text});
}

class _ConditionTileChevronRight extends StatelessWidget {
  static const _pink = Color(0xFF9D5C7D);

  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<_ConditionReportText> texts;

  const _ConditionTileChevronRight({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                const Icon(Icons.description_outlined, color: _pink),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: _pink,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _ReportTextBox(texts: texts),
            ),
        ],
      ),
    );
  }
}

class _ReportTextBox extends StatelessWidget {
  final List<_ConditionReportText> texts;

  const _ReportTextBox({required this.texts});

  @override
  Widget build(BuildContext context) {
    if (texts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Text(
          "No extracted text available for this condition yet.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Color(0xFF6F6F6F),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: texts.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F5F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (t.whenText.isNotEmpty)
                Text(
                  t.whenText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6F6F6F),
                  ),
                ),
              if (t.whenText.isNotEmpty) const SizedBox(height: 8),
              SelectableText(
                t.text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
