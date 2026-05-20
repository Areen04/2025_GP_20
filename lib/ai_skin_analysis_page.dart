import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import 'services/skin_classifier.dart';
import 'utils/skin_validator.dart';

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
  Uint8List? _tempImage;

  List<Map<String, dynamic>> _history = [];
  String? _latestValidPrediction;
  Uint8List? _latestValidImage;
  final Map<String, List<String>> _diseaseTips = {
    'Atopic Dermatitis Eczema': [
      "Keep the skin clean and dry",
      "Avoid scratching the affected area",
      "Use mild, fragrance-free products",
      "Consult a healthcare professional if symptoms persist"
    ],
    'Bacterial Skin Infection': [
      "Keep the affected area clean",
      "Avoid touching or scratching the skin",
      "Do not share personal items",
      "Seek medical advice if the condition worsens"
    ],
    'Chickenpox': [
      "Avoid scratching the skin",
      "Maintain good hygiene",
      "Stay hydrated and rest well",
      "Consult a doctor if symptoms become severe"
    ],
    'Fungal Infections': [
      "Keep the area clean and dry",
      "Avoid tight or damp clothing",
      "Practice good personal hygiene",
      "Seek medical advice if there is no improvement"
    ],
    'Hand Foot And Mouth Disease': [
      "Maintain good hygiene",
      "Rest and stay hydrated",
      "Avoid close contact with others",
      "Consult a healthcare provider if symptoms worsen"
    ],
    'Urticaria': [
      "Avoid known triggers",
      "Keep the skin cool and clean",
      "Avoid scratching the affected area",
      "Seek medical help if swelling or breathing issues occur"
    ],
    'Warts And Viral Infections': [
      "Avoid touching or picking the affected area",
      "Keep the skin clean and dry",
      "Do not share personal items",
      "Consult a healthcare professional if needed"
    ],
    'Insect Bite': [
      "Keep the area clean",
      "Avoid scratching",
      "Apply a cool compress if needed",
      "Seek medical advice if swelling or redness increases"
    ],
  };

  final Map<String, List<String>> _diseaseTipsAr = {
    'Atopic Dermatitis Eczema': [
      "حافظ على نظافة الجلد وجفافه",
      "تجنب حكّ المنطقة المصابة",
      "استخدم منتجات لطيفة وخالية من العطور",
      "استشر مختصًا صحيًا إذا استمرت الأعراض"
    ],
    'Bacterial Skin Infection': [
      "حافظ على نظافة المنطقة المصابة",
      "تجنب لمس الجلد أو حكه",
      "لا تشارك الأدوات الشخصية",
      "اطلب المشورة الطبية إذا ساءت الحالة"
    ],
    'Chickenpox': [
      "تجنب حك الجلد",
      "حافظ على النظافة",
      "اشرب السوائل واسترح جيدًا",
      "استشر الطبيب إذا أصبحت الأعراض شديدة"
    ],
    'Fungal Infections': [
      "حافظ على المنطقة نظيفة وجافة",
      "تجنب الملابس الضيقة أو الرطبة",
      "حافظ على النظافة الشخصية",
      "اطلب المشورة الطبية إذا لم تتحسن الحالة"
    ],
    'Hand Foot And Mouth Disease': [
      "حافظ على النظافة",
      "ارتح واشرب سوائل كافية",
      "تجنب المخالطة القريبة للآخرين",
      "استشر مقدم الرعاية الصحية إذا ساءت الأعراض"
    ],
    'Urticaria': [
      "تجنب المحفزات المعروفة",
      "أبقِ الجلد باردًا ونظيفًا",
      "تجنب حك المنطقة المصابة",
      "اطلب المساعدة الطبية إذا حدث تورم أو صعوبة تنفس"
    ],
    'Warts And Viral Infections': [
      "تجنب لمس أو العبث بالمنطقة المصابة",
      "حافظ على الجلد نظيفًا وجافًا",
      "لا تشارك الأدوات الشخصية",
      "استشر مختصًا صحيًا عند الحاجة"
    ],
    'Insect Bite': [
      "حافظ على نظافة المنطقة",
      "تجنب الحك",
      "استخدم كمادة باردة عند الحاجة",
      "اطلب المشورة الطبية إذا زاد التورم أو الاحمرار"
    ],
  };

  final Map<String, String> _diseaseLabelsAr = {
    'Atopic Dermatitis Eczema': 'التهاب الجلد التأتبي (الإكزيما)',
    'Bacterial Skin Infection': 'عدوى جلدية بكتيرية',
    'Chickenpox': 'جدري الماء',
    'Fungal Infections': 'العدوى الفطرية',
    'Hand Foot And Mouth Disease': 'مرض اليد والقدم والفم',
    'Urticaria': 'الشرى (الأرتيكاريا)',
    'Warts And Viral Infections': 'الثآليل والعدوى الفيروسية',
    'Insect Bite': 'لدغة حشرة',
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
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        l10n.aiSkinModelLoadFailed(e.toString()),
      )));
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
      if (_history.isNotEmpty) {
        final latest = _history.first;
        _latestValidPrediction = latest['label'];
        _latestValidImage = base64Decode(latest['image']);
      }
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
    final l10n = AppLocalizations.of(context);
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),

          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),

          title: Padding(
            padding: EdgeInsets.only(bottom: 4), // slightly tighter
            child: Text(
              l10n.aiSkinChooseImageTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Color(0xFF9D5C7D),
              ),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.photo, color: Color(0xFF9D5C7D)),
                title: Text(
                  l10n.chooseFromGallery,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black87,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.camera_alt, color: Color(0xFF9D5C7D)),
                title: Text(
                  l10n.takePhoto,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black87,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
              12, 0, 12, 8), // 🔥 Tighter bottom space

          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      _tempImage = bytes;
      _showConfirmImageDialog();
    }
  }

  void _showPopup({required String title, required String message}) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D5C7D),
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.ok,
              style: const TextStyle(
                color: Color(0xFF9D5C7D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 التحليل مع فحص الجلد المصاب ونسبة اللون
  Future<void> _analyzeImage() async {
    if (_selectedImage == null || !_modelReady) return;
    final l10n = AppLocalizations.of(context);

    // 1️⃣ فحص الإضاءة
    if (SkinValidator.isMostlyDark(_selectedImage!)) {
      _showPopup(
        title: l10n.aiSkinTooDarkTitle,
        message: l10n.aiSkinTooDarkMessage,
      );
      return;
    }

    // 2️⃣ فحص الجلد المصاب
    final hasSkin = SkinValidator.containsInfectedSkin(_selectedImage!);
    if (!hasSkin) {
      _showPopup(
        title: l10n.aiSkinNotDetectedTitle,
        message: l10n.aiSkinNotDetectedMessage,
      );
      setState(() => _prediction = "Not Detected");
      return;
    }

    // 3️⃣ فحص نسبة الجلد في الصورة
    final ratio = SkinValidator.skinColorRatio(_selectedImage!);
    print("🎨 Skin Color Ratio: ${(ratio * 100).toStringAsFixed(2)}%");
    if (ratio < 0.29) {
      _showPopup(
        title: l10n.aiSkinReuploadTitle,
        message: l10n.aiSkinReuploadMessage,
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
        _prediction = label; // temporary for top UI
        _history.insert(0, entry); // add history
        _latestValidPrediction = label; // save as latest valid
        _latestValidImage = _selectedImage;
        _selectedImage = null;
      });
      await _saveHistoryToFirestore(entry);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPrefix(e.toString()))));
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

  String _localizedLabel(BuildContext context, String label) {
    if (Localizations.localeOf(context).languageCode == 'ar') {
      return _diseaseLabelsAr[label] ?? label;
    }
    return label;
  }

  String _diagnosisDisclaimer(BuildContext context) {
    if (Localizations.localeOf(context).languageCode == 'ar') {
      return 'تنبيه: هذه النتيجة ليست تشخيصًا نهائيًا، يرجى زيارة الطبيب.';
    }
    return 'Note: This result is not a final diagnosis. Please visit a doctor.';
  }

  List<String> _getTipsForDisease(BuildContext context, String label) {
    final normalized =
        label.replaceAll("_", " ").replaceAll("-", " ").trim().toLowerCase();
    for (final entry in _diseaseTips.entries) {
      final key = entry.key
          .replaceAll("_", " ")
          .replaceAll("-", " ")
          .trim()
          .toLowerCase();
      if (key == normalized) {
        if (Localizations.localeOf(context).languageCode == 'ar') {
          return _diseaseTipsAr[entry.key] ?? entry.value;
        }
        return entry.value;
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: Text(
            l10n.aiSkinTitle,
            style: const TextStyle(
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
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (_selectedImage == null) ? _pickImage : null,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TOP CONTAINER UI
// TOP BOX
                      if (_selectedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                size: 50, color: Color(0xFF9D5C7D)),
                            SizedBox(height: 12),
                            Text(
                              l10n.aiSkinClickHere,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              l10n.aiSkinSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9D5C7D), // your purple
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        l10n.aiSkinReuploadButton,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
            const SizedBox(height: 30),
            Text(l10n.aiSkinLatestAnalysis,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(height: 14),
            if (_latestValidPrediction != null && _latestValidImage != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _latestValidImage!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _localizedLabel(context, _latestValidPrediction!),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 1),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFFC94C4C),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _diagnosisDisclaimer(context),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                    color: Color(0xFFC94C4C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.aiSkinRecommendedTips,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ..._getTipsForDisease(
                                  context, _latestValidPrediction!)
                              .map(
                            (tip) => Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  margin:
                                      const EdgeInsetsDirectional.only(end: 6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xFFD1B6C8),
                                        width: 2),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 11,
                                      color: Color(0xFF9D5C7D),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6F6F6F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            Text(l10n.aiSkinHistory,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: _history.isEmpty
                  ? Center(
                      child: Text(
                        l10n.aiSkinNoHistory,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13),
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Image.memory(
                                  imgBytes,
                                  width: 125,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(6),
                                  color: Colors.black.withOpacity(0.35),
                                  child: Text(
                                    "${_localizedLabel(context, item['label'])}\n${date.toLocal().toString().split(' ')[0]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  void _showConfirmImageDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(
          l10n.aiSkinConfirmImageTitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D5C7D),
          ),
        ),
        content: Text(
          l10n.aiSkinConfirmImageMessage,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _tempImage = null;
              Navigator.pop(context);
            },
            child: Text(l10n.no),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9D5C7D),
            ),
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                _selectedImage = _tempImage;
                _tempImage = null;
                _prediction = null;
              });

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _analyzeImage();
              });
            },
            child: Text(
              l10n.yes,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
