import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ Firebase Base URL
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// ✅ رابط ملفات Firebase
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

/// ---------------------------------------------------------------------------
/// 📌 DevelopmentalMilestones24Month — نسخة طبق الأصل من TwoMonth
/// ---------------------------------------------------------------------------
class DevelopmentalMilestones24month extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones24month({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones24month> createState() =>
      _DevelopmentalMilestones24monthState();
}

class _DevelopmentalMilestones24monthState
    extends State<DevelopmentalMilestones24month> {
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
          .doc('24_months')
          .get();

      if (doc.exists) {
        int c = 0;
        doc.data()!.forEach((key, value) {
          if (value == true) c++;
        });
        setState(() => completedCount = c);
      }
    } catch (_) {}
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
                          title:
                              "Notices when others are hurt or upset, like pausing or looking sad when someone is crying",
                          imageUrl: firebase('images/24m_notices_hurt.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Looks at your face to see how to react in a new situation",
                          imageUrl: firebase('images/24m_looks_face.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    // SPEECH & LANGUAGE
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      isExpanded: expandedIndex == 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Points to things in a book when you ask, like 'Where is the bear?'",
                          videoUrl: firebase('videos/24m_points_book.mp4'),
                          thumbUrl:
                              firebase('images/24m_points_book_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Says at least two words together, like 'More milk.'",
                          videoUrl: firebase('videos/24m_two_words.mp4'),
                          thumbUrl: firebase('images/24m_two_words_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Points to at least two body parts when you ask him to show you",
                          videoUrl: firebase('videos/24m_points_body.mp4'),
                          thumbUrl:
                              firebase('images/24m_points_body_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Uses more gestures than just waving and pointing, like blowing a kiss or nodding yes",
                          videoUrl: firebase('videos/24m_gestures.mp4'),
                          thumbUrl: firebase('images/24m_gestures_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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
                          title:
                              "Holds something in one hand while using the other hand, like holding a container and taking the lid off",
                          videoUrl: firebase('videos/24m_holds_container.mp4'),
                          thumbUrl:
                              firebase('images/24m_holds_container_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Tries to use switches, knobs, or buttons on a toy",
                          imageUrl: firebase('images/24m_uses_switch.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Plays with more than one toy at the same time, like putting toy food on a toy plate",
                          imageUrl: firebase('images/24m_plays_toys.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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
                          title: "Kicks a ball",
                          imageUrl: firebase('images/24m_kicks_ball.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Runs",
                          videoUrl: firebase('videos/24m_runs.mp4'),
                          thumbUrl: firebase('images/24m_runs_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Walks (not climbs) up a few stairs with or without help",
                          imageUrl: firebase('images/24m_walks_stairs.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Eats with a spoon",
                          imageUrl: firebase('images/24m_eats_spoon.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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

  // HEADER — نفس TwoMonth
  Widget _buildHeader(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
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
                child: Text("Developmental Milestones",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 17)),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  // PROGRESS CARD — نفس TwoMonth
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
            Text(
              "$completedCount of $totalMilestones Milestones Complete",
              style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // SECTION — نفس TwoMonth
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
            onExpansionChanged: (v) =>
                setState(() => expandedIndex = v ? index : -1),
            title: Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            iconColor: const Color(0xFF9D5C7D),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: milestones,
          ),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// ⭐ _MilestoneCard — نسخه مطابقه ل TwoMonth بالحرف
/// ---------------------------------------------------------------------------
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
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              setState(() => initialized = true);
            });

      _controller!.addListener(() {
        final bool isFinished =
            _controller!.value.position >= _controller!.value.duration;
        if (isFinished) {
          setState(() => isPlaying = false);
          _controller!.seekTo(Duration.zero);
        }
      });
    }
  }

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
          .doc('24_months')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (_) {}
  }

  Future<void> _saveCheckboxState(bool value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('parents')
        .doc(user.uid)
        .collection('children')
        .doc(widget.childId)
        .collection('milestones')
        .doc('24_months')
        .set({widget.title: value}, SetOptions(merge: true));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
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
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => isChecked = v);
                    widget.onChecked?.call(v);
                    _saveCheckboxState(v);
                  },
                ),
                Expanded(
                  child: Text(widget.title,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildMedia(),
            ),
          ],
        ),
      );

  Widget _buildMedia() {
    // صورة فقط
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // عرض الثمب
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

    // تشغيل الفيديو
    if (!initialized) {
      return const SizedBox(
          height: 200, child: Center(child: CircularProgressIndicator()));
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}
