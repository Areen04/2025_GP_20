import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/skin_classifier.dart';
import 'utils/skin_validator.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AiSkinAnalysisPage extends StatefulWidget {
  final String childId;
  final String childName;

  const AiSkinAnalysisPage({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<AiSkinAnalysisPage> createState() => _AiSkinAnalysisPageState();
}

class _AiSkinAnalysisPageState extends State<AiSkinAnalysisPage> {
  Uint8List? _selectedImage;
  String? _prediction;
  bool _isLoading = false;
  bool _modelReady = false;
  List<Map<String, dynamic>> _history = [];

  final Map<String, List<String>> _diseaseTips = {
    'Atopic Dermatitis Eczema': [
      "Apply prescribed cream",
      "Keep skin moisturized",
      "Avoid scratching",
      "Use gentle soap"
    ],
    'Bacterial Skin Infection': [
      "Take prescribed antibiotics",
      "Clean affected area gently",
      "Avoid sharing towels",
      "Keep area dry"
    ],
    'Chickenpox': [
      "Avoid scratching blisters",
      "Use soothing lotion",
      "Stay hydrated",
      "Rest and avoid public places"
    ],
    'Fungal Infections': [
      "Keep area clean and dry",
      "Use antifungal cream",
      "Avoid tight clothing",
      "Change socks daily"
    ],
    'Hand Foot And Mouth Disease': [
      "Drink fluids",
      "Rest and avoid contact with others",
      "Use pain relief if needed",
      "Keep hands clean"
    ],
    'Urticaria': [
      "Avoid triggers",
      "Use antihistamines",
      "Apply cool compress",
      "Seek medical help if swelling"
    ],
    'Warts And Viral Infections': [
      "Avoid picking at warts",
      "Use medicated cream",
      "Keep area covered",
      "Wash hands often"
    ],
    'Insect Bite': [
      "Apply cold compress",
      "Use anti-itch cream",
      "Avoid scratching",
      "Keep area clean and covered"
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadHistoryFromFirestore();
  }

  Future<void> _loadModel() async {
    try {
      await SkinClassifier.instance.init();
      setState(() => _modelReady = true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load model: $e")));
    }
  }

  Future<void> _loadHistoryFromFirestore() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .collection('skinHistory')
          .orderBy('date', descending: true)
          .get();

      setState(() {
        _history = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Error loading history: $e");
    }
  }

  Future<void> _saveHistoryToFirestore(Map<String, dynamic> entry) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .collection('skinHistory')
          .add(entry);
    } catch (e) {
      print("Error saving history: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Choose Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Color(0xFF9D5C7D)),
              title: const Text("From Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF9D5C7D)),
              title: const Text("Take a Photo"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = bytes;
        _prediction = null;
      });
    }
  }

  void _showPopup({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF9D5C7D))),
        content: Text(message,
            style: const TextStyle(color: Color(0xFF6D6D6D), fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Re-upload",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF9D5C7D))),
          ),
        ],
      ),
    );
  }

  /// 🔹 التحليل مع فحص الجلد المصاب ونسبة اللون
  Future<void> _analyzeImage() async {
    if (_selectedImage == null || !_modelReady) return;

    // 1️⃣ فحص الإضاءة
    if (SkinValidator.isMostlyDark(_selectedImage!)) {
      _showPopup(
        title: "Too Dark",
        message: "The image is too dark. Please upload a clearer photo.",
      );
      return;
    }

    // 2️⃣ فحص الجلد المصاب
    final hasSkin = SkinValidator.containsInfectedSkin(_selectedImage!);
    if (!hasSkin) {
      _showPopup(
        title: "Not Detected",
        message:
            "No infected skin area detected. Please re-upload a valid skin photo showing the affected area.",
      );
      setState(() => _prediction = "Not Detected");
      return;
    }

    // 3️⃣ فحص نسبة الجلد في الصورة
    final ratio = SkinValidator.skinColorRatio(_selectedImage!);
    print("🎨 Skin Color Ratio: ${(ratio * 100).toStringAsFixed(2)}%");
    if (ratio < 0.29) {
      _showPopup(
        title: "Re-upload",
        message:
            "The skin area isn’t clear. Please retake the photo and make sure the affected skin is clear.",
      );
      setState(() => _prediction = "Re-upload");
      return;
    }

    // 4️⃣ بدء التحليل
    setState(() => _isLoading = true);

    try {
      final result = await SkinClassifier.instance.predict(_selectedImage!);
      final label = _formatLabel(result['label']);

      print("🧠 Prediction: $label");

      final now = DateTime.now();
      final entry = {
        'label': label,
        'image': base64Encode(_selectedImage!),
        'date': now.toIso8601String(),
      };

      setState(() {
        _prediction = label;
        _history.insert(0, entry);
      });

      await _saveHistoryToFirestore(entry);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatLabel(String raw) {
    return raw
        .replaceAll("_", " ")
        .replaceAll("-", " ")
        .split(" ")
        .map((e) => e.isEmpty ? "" : "${e[0].toUpperCase()}${e.substring(1)}")
        .join(" ");
  }

  List<String> _getTipsForDisease(String label) {
    final normalized =
        label.replaceAll("_", " ").replaceAll("-", " ").trim().toLowerCase();
    for (final entry in _diseaseTips.entries) {
      final key = entry.key
          .replaceAll("_", " ")
          .replaceAll("-", " ")
          .trim()
          .toLowerCase();
      if (key == normalized) return entry.value;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "${widget.childName}'s Skin Analysis",
          maxLines: 1,
          minFontSize: 14,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF9D5C7D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF9D5C7D)),
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F3F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _selectedImage == null
                        ? Column(children: const [
                            Icon(Icons.camera_alt_rounded,
                                size: 50, color: Color(0xFF9D5C7D)),
                            SizedBox(height: 12),
                            Text("Click Here",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            SizedBox(height: 6),
                            Text("Get an instant AI-powered skin analysis.",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF6D6D6D))),
                          ])
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(_selectedImage!,
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity),
                          ),
                  ],
                ),
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        (!_modelReady || _isLoading) ? null : _analyzeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D5C7D),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text("Analyze Now",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xFF9D5C7D), width: 1.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: Color(0xFF9D5C7D), size: 26),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
            const Text("Latest Analysis",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(height: 14),
            if (_prediction != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE8D8E0)),
                ),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(_selectedImage!,
                        width: 80, height: 80, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_prediction!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black)),
                          const SizedBox(height: 6),
                          const Text("Recommended care tips:",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6D6D6D))),
                          const SizedBox(height: 4),
                          ..._getTipsForDisease(_prediction!).map((tip) => Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xFFD1B6C8),
                                          width: 2),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.check,
                                            size: 11,
                                            color: Color(0xFF9D5C7D))),
                                  ),
                                  Expanded(
                                      child: Text(tip,
                                          style: const TextStyle(
                                              fontSize: 13.5,
                                              color: Color(0xFF5A5A5A)))),
                                ],
                              )),
                        ]),
                  ),
                ]),
              ),
            const SizedBox(height: 30),
            const Text("Analysis History",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: _history.isEmpty
                  ? const Center(
                      child: Text(
                        "No previous analyses yet.",
                        style:
                            TextStyle(color: Color(0xFF9D5C7D), fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final item = _history[index];
                        final imgBytes = base64Decode(item['image']);
                        final date = DateTime.parse(item['date']);
                        return Container(
                          width: 125,
                          margin: const EdgeInsets.only(right: 10),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  imgBytes,
                                  width: 125,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: Colors.black.withOpacity(0.35),
                                ),
                                child: Text(
                                  "${item['label']}\n${date.toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
