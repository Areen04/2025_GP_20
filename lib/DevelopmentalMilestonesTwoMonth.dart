import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesTwoMonth extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesTwoMonth({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesTwoMonth> createState() =>
      _DevelopmentalMilestonesTwoMonthState();
}

class _DevelopmentalMilestonesTwoMonthState
    extends State<DevelopmentalMilestonesTwoMonth> {
  int expandedIndex = 0;
  int completedCount = 0;
  final int totalMilestones = 11;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
          .doc('2_months')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        int count = 0;
        data.forEach((key, value) {
          if (value == true) count++;
        });
        setState(() => completedCount = count);
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // ---------------------------
                    // SOCIAL
                    // ---------------------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      isExpanded: expandedIndex == 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Calms down when spoken to or picked up",
                          imageUrl: firebase("images/2m_social_calms_down.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Looks at your face",
                          imageUrl:
                              firebase("images/2m_social_looks_at_face.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Seems happy to see you when you walk up to her",
                          imageUrl:
                              firebase("images/2m_social_happy_to_see.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        // ⭐ الفيديو الأول اللي يجيب الهم 😭
                        _MilestoneCard(
                          title: "Smiles when you talk to or smile at her",
                          videoUrl: firebase("videos/2m_social_smile.mp4"),
                          thumbUrl: firebase(
                              "images/2m_social_smile_thumb.jpg"), // ← لا تنسي الثمب
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    // SPEECH
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      isExpanded: expandedIndex == 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Makes cooing sounds",
                          videoUrl: firebase("videos/2m_language_cooing.mp4"),
                          thumbUrl:
                              firebase("images/2m_language_cooing_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Reacts to loud sounds",
                          videoUrl: firebase("videos/2m_language_reacts.mp4"),
                          thumbUrl:
                              firebase("images/2m_language_reacts_thumb.jpg"),
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
                          title: "Watches you as you move",
                          videoUrl: firebase("videos/2m_cognitive_watch.mp4"),
                          thumbUrl:
                              firebase("images/2m_cognitive_watch_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Looks at a toy for several seconds",
                          imageUrl:
                              firebase("images/2m_cognitive_look_toy.jpg"),
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
                          title: "Holds head up when on tummy",
                          imageUrl: firebase("images/2m_movement_head_up.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Moves both arms and both legs",
                          videoUrl:
                              firebase("videos/2m_movement_arms_legs.mp4"),
                          thumbUrl: firebase(
                              "images/2m_movement_arms_legs_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Opens hands briefly",
                          videoUrl:
                              firebase("videos/2m_movement_opens_hands.mp4"),
                          thumbUrl: firebase(
                              "images/2m_movement_opens_hands_thumb.jpg"),
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

  // HEADER
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
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

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
            Text("$completedCount of $totalMilestones Milestones Complete",
                style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.black54)),
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

// ==========================================
// CARD
// ==========================================
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
          initialized = true;

          _controller!.setLooping(false);

          // 👇 listener يشغّل حتى الفيديو القصير
          _controller!.addListener(_videoListener);

          setState(() {});
        });
    }
  }

  // ⭐⭐⭐ الحل السحري للفيديو الاول ⭐⭐⭐
  void _videoListener() async {
    final c = _controller!;
    final pos = c.value.position;
    final dur = c.value.duration;

    // الفيديو القصير = نخليه 1.5 ثانية وهمياً
    final fakeDuration = dur < const Duration(milliseconds: 1500)
        ? const Duration(milliseconds: 1500)
        : dur;

    if (pos >= fakeDuration - const Duration(milliseconds: 150)) {
      if (mounted) {
        setState(() => isPlaying = false);
      }
      c.pause();
      await c.seekTo(Duration.zero);
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
          .doc('2_months')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (_) {}
  }

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
          .doc('2_months')
          .set({widget.title: value}, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
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
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                        fontSize: 15),
                  ),
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

    // الثمب
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

    // الفيديو شغال
    if (initialized) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
