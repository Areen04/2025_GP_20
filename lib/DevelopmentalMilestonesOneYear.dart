import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ رابط Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// ✅ دالة توليد الرابط
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesOneYear extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesOneYear({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesOneYear> createState() =>
      _DevelopmentalMilestonesOneYearState();
}

class _DevelopmentalMilestonesOneYearState
    extends State<DevelopmentalMilestonesOneYear> {
  int expandedIndex = 0;
  int completedCount = 0;
  final int totalMilestones = 10;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadProgressFromFirebase();
  }

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
    });
  }

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
          .doc('1_year')
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
      debugPrint("⚠️ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = completedCount / totalMilestones;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // SOCIAL
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      isExpanded: expandedIndex == 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Waves bye-bye",
                          videoUrl: firebase('videos/1y_waves_bye.mp4'),
                          thumbUrl: firebase('images/1y_waves_bye_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Plays pat-a-cake with you",
                          videoUrl: firebase('videos/1y_plays_patacake.mp4'),
                          thumbUrl:
                              firebase('images/1y_plays_patacake_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // LANGUAGE
                    _buildSection(
                      title: "Language & Communication",
                      index: 1,
                      isExpanded: expandedIndex == 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Says mama or dada",
                          videoUrl: firebase('videos/1y_says_mama_dada.mp4'),
                          thumbUrl:
                              firebase('images/1y_says_mama_dada_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Understands “no”",
                          videoUrl: firebase('videos/1y_understands_no.mp4'),
                          thumbUrl:
                              firebase('images/1y_understands_no_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // COGNITIVE
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      isExpanded: expandedIndex == 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Puts things in a container",
                          videoUrl: firebase('videos/1y_puts_in_container.mp4'),
                          thumbUrl:
                              firebase('images/1y_puts_in_container_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Looks for hidden toys",
                          videoUrl:
                              firebase('videos/1y_looks_for_hidden_toy.mp4'),
                          thumbUrl: firebase(
                              'images/1y_looks_for_hidden_toy_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // MOVEMENT
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      isExpanded: expandedIndex == 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Pulls up to stand",
                          imageUrl: firebase('images/1y_pulls_to_stand.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Walks holding furniture",
                          videoUrl:
                              firebase('videos/1y_walks_with_support.mp4'),
                          thumbUrl: firebase(
                              'images/1y_walks_with_support_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Drinks from a cup",
                          videoUrl: firebase('videos/1y_drinks_from_cup.mp4'),
                          thumbUrl:
                              firebase('images/1y_drinks_from_cup_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Uses thumb + finger to pick things",
                          videoUrl: firebase('videos/1y_pincer_grasp.mp4'),
                          thumbUrl:
                              firebase('images/1y_pincer_grasp_thumb.jpg'),
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

  // 🩷 أعلى الصفحة — الهيدر ثابت
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
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF9D5C7D),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Developmental Milestones",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  // 📊 كرت التقدم
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overall Progress",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$completedCount of $totalMilestones milestones complete",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // 📦 البوكسات (أقسام المهارات)
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
          border: Border.all(color: const Color(0xFFE6E2E6)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => expandedIndex = expanded ? index : -1),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
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

// **********************************************************************
// 🔥🔥 كرت المهارة — نفس 2 MONTH بالضبط مع تحسينات السرعة والثمب 🔥🔥
// **********************************************************************

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

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();

    // 🎥 نجهز الفيديو بدون تشغيل — ونخليه يرجع Play button لما ينتهي
    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              _controller!.setLooping(false);
              _controller!.addListener(() {
                if (_controller!.value.position >=
                    _controller!.value.duration) {
                  if (mounted) {
                    setState(() => isPlaying = false);
                  }
                }
              });
              if (mounted) setState(() {});
            });
    }
  }

  // 🔘 تحميل حالة الشيك من Firebase
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
          .doc('1_year')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (e) {
      debugPrint("⚠️ checkbox error: $e");
    }
  }

  // حفظ الشيك
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
          .doc('1_year')
          .set({widget.title: value}, SetOptions(merge: true));
    } catch (e) {
      debugPrint("⚠️ save checkbox error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // **********************************************************************
  // 🖼️ عرض الصورة + الثمب + الفيديو (نفس 2 MONTH تماماً)
  // **********************************************************************
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6DDE2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: const Color(0xFF9D5C7D),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                value: isChecked,
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
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildMedia(),
          ),
        ],
      ),
    );
  }

  // *****************************************************
  // 🧡 اهم جزء — عرض الفيديو + الثمب بدون تأخير مثل 2 MONTH
  // **Widget _buildMedia() {
  // صورة فقط
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
      // 🔥 زر Play + Thumb يظهرون فوراً
      if (!isPlaying) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // الثمب دائمًا يظهر سريع
            Image.network(
              widget.thumbUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // زر التشغيل يظهر فووووراً
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 60,
                color: Color(0xFF9D5C7D),
              ),
              onPressed: () {
                setState(() => isPlaying = true);
                _controller?.play();
              },
            ),
          ],
        );
      }

      // الفيديو شغال
      if (!_controller!.value.isInitialized) {
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
