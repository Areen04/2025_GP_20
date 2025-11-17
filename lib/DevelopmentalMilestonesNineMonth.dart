// 🔥 ———————————————————————————————————————————————
// Developmental Milestones 9 Month (FINAL VERSION)
// نفس تو منث + نفس ست منث + بدون أي حذف + تحسين كامل
// 🔥 ———————————————————————————————————————————————

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط قاعدة ملفات Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// 🔹 دالة توليد رابط الملفات
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesNineMonth extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesNineMonth({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesNineMonth> createState() =>
      _DevelopmentalMilestonesNineMonthState();
}

class _DevelopmentalMilestonesNineMonthState
    extends State<DevelopmentalMilestonesNineMonth> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 13;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
    });
  }

  // تحميل التقدم
  Future<void> loadProgressFromFirebase() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc('9_months')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        int count = 0;
        data.forEach((key, value) {
          if (value == true) count++;
        });
        setState(() => completedCount = count);
      }
    } catch (e) {
      debugPrint('⚠️ Error loading progress: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadProgressFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final progress = completedCount / totalMilestones;

    return Scaffold(
      backgroundColor: Colors.white,

      // ⭐⭐ الهيدر ثابت ⭐⭐
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context), // ثابت

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // ------------- Sections -------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      isExpanded: expandedIndex == 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Is shy, clingy, or fearful around strangers",
                          videoUrl: firebase('videos/9m_shy_strangers.mp4'),
                          thumbUrl:
                              firebase('images/9m_shy_strangers_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Shows facial expressions like happy, sad, angry, and surprised",
                          imageUrl:
                              firebase('images/9m_facial_expressions.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Looks when you call her name",
                          videoUrl: firebase('videos/9m_responds_name.mp4'),
                          thumbUrl:
                              firebase('images/9m_responds_name_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Language & Communication",
                      index: 1,
                      isExpanded: expandedIndex == 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Makes sounds like 'mamama' or 'babababa'",
                          videoUrl: firebase('videos/9m_babbling.mp4'),
                          thumbUrl: firebase('images/9m_babbling_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      isExpanded: expandedIndex == 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Looks for objects when dropped out of sight",
                          videoUrl: firebase('videos/9m_object_search.mp4'),
                          thumbUrl:
                              firebase('images/9m_object_search_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      isExpanded: expandedIndex == 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Gets to a sitting position by herself",
                          videoUrl: firebase('videos/9m_gets_sitting.mp4'),
                          thumbUrl:
                              firebase('images/9m_gets_sitting_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Sits without support",
                          imageUrl: firebase('images/9m_sits_unsupported.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.25))),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: Color(0xFF9D5C7D)),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Developmental Milestones",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  // ---------------- PROGRESS CARD ----------------
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overall Progress",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            const SizedBox(height: 6),
            Text("$completedCount of $totalMilestones milestones complete",
                style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.25),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // ---------------- SECTION ----------------

  Widget _buildSection({
    required String title,
    required int index,
    required bool isExpanded,
    required List<Widget> milestones,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

          // ✔️ هذا البوردر اللي انتي تبينه
          border: Border.all(color: const Color(0xFFE6E2E6)),
        ),

        // ✔️ هذا أهم جزء لإخفاء الخط اللي داخل الـ ExpansionTile
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => expanded ? index : -1),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            iconColor: const Color(0xFF9D5C7D),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: milestones,
          ),
        ),
      );
}

// ==================== CARD WIDGET ====================
class _MilestoneCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbUrl;
  final Function(bool)? onChecked;
  final String childId;

  const _MilestoneCard({
    required this.title,
    this.imageUrl,
    this.videoUrl,
    this.thumbUrl,
    this.onChecked,
    required this.childId,
  });

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  VideoPlayerController? _controller;
  bool isChecked = false;
  bool isPlaying = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
      )..initialize().then((_) {
          setState(() => initialized = true);

          // ⭐ يرجعه للثمب بعد نهاية التشغيل
          _controller!.addListener(() {
            if (_controller!.value.position >= _controller!.value.duration) {
              setState(() => isPlaying = false);
            }
          });
        });
    }
  }

  // تحميل حالة التشيك
  Future<void> _loadCheckboxState() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc('9_months')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (e) {}
  }

  // حفظ حالة التشيك
  Future<void> _saveCheckboxState(bool value) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc('9_months')
          .set({widget.title: value}, SetOptions(merge: true));
    } catch (e) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ---------------- CARD UI ----------------
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F3F6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6DDE2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE + CHECKBOX
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: const Color(0xFF9D5C7D),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => isChecked = val);
                    widget.onChecked?.call(val);
                    _saveCheckboxState(val);
                  },
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // MEDIA
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildMedia(),
            ),
          ],
        ),
      );

  // ---------------- MEDIA LOGIC ----------------
  Widget _buildMedia() {
    // صورة فقط
    if (widget.imageUrl != null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // فيديو
    if (widget.videoUrl != null) {
      // إذا مو شغال → نعرض الثمب
      if (!isPlaying) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              widget.thumbUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            IconButton(
              icon: const Icon(Icons.play_circle_fill,
                  size: 60, color: Color(0xFF9D5C7D)),
              onPressed: () {
                setState(() => isPlaying = true);
                _controller?.play();
              },
            ),
          ],
        );
      }

      // شغال الآن
      if (!initialized) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    return const SizedBox.shrink();
  }
}
