import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ---------------------------------------------------------------------------
/// 🔗 Firebase Base URL
/// ---------------------------------------------------------------------------
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

String firebase(String path) =>
    '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';

/// ---------------------------------------------------------------------------
/// 📌 DevelopmentalMilestones30Month — نسخة TwoMonth 100%
/// ---------------------------------------------------------------------------
class DevelopmentalMilestones30month extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones30month({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones30month> createState() =>
      _DevelopmentalMilestones30monthState();
}

class _DevelopmentalMilestones30monthState
    extends State<DevelopmentalMilestones30month> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 15;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// تحميل التشيكات
  Future<void> loadProgress() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc('30_months')
          .get();

      if (doc.exists) {
        int c = 0;
        doc.data()!.forEach((k, v) {
          if (v == true) c++;
        });
        setState(() => completedCount = c);
      }
    } catch (_) {}
  }

  void updateProgress(bool v) {
    setState(() {
      completedCount += v ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
      if (completedCount > totalMilestones) completedCount = totalMilestones;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    double progress = completedCount / totalMilestones;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context), // ← الهيدر ثابت

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    /// --------------------------------------------------------
                    /// 1 — SOCIAL
                    /// --------------------------------------------------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Plays next to other children and sometimes plays with them",
                          videoUrl:
                              firebase('videos/30m_plays_with_children.mp4'),
                          thumbUrl: firebase(
                              'images/30m_plays_with_children_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Shows you what she can do by saying 'Look at me!'",
                          videoUrl: firebase('videos/30m_look_at_me.mp4'),
                          thumbUrl: firebase('images/30m_look_at_me_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Follows simple routines when told, like helping to pick up toys when you say 'It’s clean-up time.'",
                          videoUrl: firebase('videos/30m_follows_routine.mp4'),
                          thumbUrl:
                              firebase('images/30m_follows_routine_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    /// --------------------------------------------------------
                    /// 2 — LANGUAGE
                    /// --------------------------------------------------------
                    _buildSection(
                      title: "Language & Communication",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Says about 50 words",
                          videoUrl: firebase('videos/30m_says_50_words.mp4'),
                          thumbUrl:
                              firebase('images/30m_says_50_words_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Says two or more words together, with one action word",
                          videoUrl: firebase('videos/30m_two_words_action.mp4'),
                          thumbUrl:
                              firebase('images/30m_two_words_action_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Names things in a book when you point and ask",
                          videoUrl: firebase('videos/30m_names_in_book.mp4'),
                          thumbUrl:
                              firebase('images/30m_names_in_book_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Says words like 'I,' 'me,' or 'we'",
                          videoUrl: firebase('videos/30m_says_I_me_we.mp4'),
                          thumbUrl:
                              firebase('images/30m_says_I_me_we_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    /// --------------------------------------------------------
                    /// 3 — COGNITIVE
                    /// --------------------------------------------------------
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Uses things to pretend (feeding a block to a doll)",
                          videoUrl: firebase('videos/30m_pretend_play.mp4'),
                          thumbUrl:
                              firebase('images/30m_pretend_play_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Shows simple problem-solving skills",
                          videoUrl: firebase('videos/30m_problem_solving.mp4'),
                          thumbUrl:
                              firebase('images/30m_problem_solving_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Follows two-step instructions",
                          videoUrl:
                              firebase('videos/30m_two_step_instruction.mp4'),
                          thumbUrl: firebase(
                              'images/30m_two_step_instruction_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Knows at least one color",
                          videoUrl: firebase('videos/30m_knows_color.mp4'),
                          thumbUrl:
                              firebase('images/30m_knows_color_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    /// --------------------------------------------------------
                    /// 4 — MOVEMENT
                    /// --------------------------------------------------------
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Uses hands to twist things",
                          imageUrl: firebase('images/30m_twist_things.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Takes some clothes off by herself",
                          imageUrl:
                              firebase('images/30m_takes_clothes_off.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Jumps off the ground with both feet",
                          videoUrl: firebase('videos/30m_jumps_both_feet.mp4'),
                          thumbUrl:
                              firebase('images/30m_jumps_both_feet_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Turns book pages one at a time",
                          imageUrl: firebase('images/30m_turns_book_pages.jpg'),
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

  /// HEADER ثابت
  Widget _buildHeader(BuildContext context) => Container(
        height: 58,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
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
                  ),
                ),
              ),
            ),
            const SizedBox(width: 45),
          ],
        ),
      );

  /// PROGRESS CARD
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
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  /// SECTION BUILDER
  Widget _buildSection({
    required String title,
    required int index,
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
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (v) =>
                setState(() => expandedIndex = v ? index : -1),
            iconColor: const Color(0xFF9D5C7D),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: milestones,
          ),
        ),
      );
}

/// ---------------------------------------------------------------------------
/// ⭐ MilestoneCard (مأخوذ من TwoMonth بالحرف)
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

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              setState(() => initialized = true);
            });

      _controller!.addListener(() {
        final pos = _controller!.value.position;
        final dur = _controller!.value.duration;

        if (pos >= dur - const Duration(milliseconds: 350)) {
          setState(() => isPlaying = false);
          _controller!.seekTo(Duration.zero);
        }
      });
    }

    _loadCheckbox();
  }

  Future<void> _loadCheckbox() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .doc(widget.childId)
          .collection('milestones')
          .doc('30_months')
          .get();

      if (doc.exists && doc.data()![widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (_) {}
  }

  Future<void> _saveCheckbox(bool v) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('parents')
        .doc(user.uid)
        .collection('children')
        .doc(widget.childId)
        .collection('milestones')
        .doc('30_months')
        .set({widget.title: v}, SetOptions(merge: true));
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
            /// Checkbox + title
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
                    _saveCheckbox(v);
                  },
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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

  /// -------------------------------------------------------------------------
  /// ⭐ MEDIA LOGIC — نفس TwoMonth حرفيًا
  /// -------------------------------------------------------------------------
  Widget _buildMedia() {
    /// صورة فقط
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    /// عرض الثمب أولًا
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

    /// عرض الفيديو
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
}
