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
/// 📌 DevelopmentalMilestones30Month — unified with 3y / 24m
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  /// 🔔 يحدد أي فيديو نشط حاليًّا (حتى لا تعمل أكثر من وحدة في نفس الوقت)
  final ValueNotifier<String?> activeVideo = ValueNotifier<String?>(null);

  // مفاتيح الأقسام للسكرول
  final Map<int, GlobalKey> _sectionKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
      if (completedCount > totalMilestones) completedCount = totalMilestones;
    });
  }

  /// load stored checkboxes from Firebase
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

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    double progress = completedCount / totalMilestones;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "Developmental Milestones",
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
            child: Container(
              height: 1,
              color: const Color(0xFFE0E0E0),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Shows you what she can do by saying 'Look at me!'",
                          videoUrl: firebase('videos/30m_look_at_me.mp4'),
                          thumbUrl:
                              firebase('images/30m_look_at_me_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Follows simple routines when told, like helping to pick up toys when you say 'It’s clean-up time.'",
                          videoUrl:
                              firebase('videos/30m_follows_routine.mp4'),
                          thumbUrl:
                              firebase('images/30m_follows_routine_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
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
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Says two or more words together, with one action word",
                          videoUrl:
                              firebase('videos/30m_two_words_action.mp4'),
                          thumbUrl:
                              firebase('images/30m_two_words_action_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Names things in a book when you point and ask",
                          videoUrl:
                              firebase('videos/30m_names_in_book.mp4'),
                          thumbUrl:
                              firebase('images/30m_names_in_book_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Says words like 'I,' 'me,' or 'we'",
                          videoUrl: firebase('videos/30m_says_I_me_we.mp4'),
                          thumbUrl:
                              firebase('images/30m_says_I_me_we_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
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
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Shows simple problem-solving skills",
                          videoUrl:
                              firebase('videos/30m_problem_solving.mp4'),
                          thumbUrl:
                              firebase('images/30m_problem_solving_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Follows two-step instructions",
                          videoUrl:
                              firebase('videos/30m_two_step_instruction.mp4'),
                          thumbUrl: firebase(
                              'images/30m_two_step_instruction_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Knows at least one color",
                          videoUrl: firebase('videos/30m_knows_color.mp4'),
                          thumbUrl:
                              firebase('images/30m_knows_color_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
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
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Takes some clothes off by herself",
                          imageUrl:
                              firebase('images/30m_takes_clothes_off.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Jumps off the ground with both feet",
                          videoUrl:
                              firebase('videos/30m_jumps_both_feet.mp4'),
                          thumbUrl:
                              firebase('images/30m_jumps_both_feet_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Turns book pages one at a time",
                          imageUrl:
                              firebase('images/30m_turns_book_pages.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
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

  /// PROGRESS CARD — unified
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overall Progress",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "$completedCount of $totalMilestones milestones complete",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
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

  /// SECTION — unified with rotating arrow + scroll + single expanded
  Widget _buildSection({
    required String title,
    required int index,
    required List<Widget> milestones,
  }) =>
      Container(
        key: _sectionKeys[index],
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: ValueKey("$index-${expandedIndex == index}"),
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (isOpen) {
              if (isOpen) {
                setState(() {
                  expandedIndex = index;
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    _sectionKeys[index]!.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });

                // أوقف أي فيديو شغّال عند تغيير القسم
                activeVideo.value = null;
              } else {
                setState(() => expandedIndex = -1);
                activeVideo.value = null;
              }
            },
            trailing: AnimatedRotation(
              turns: expandedIndex == index ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 32,
                color: Color(0xFF9D5C7D),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
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
/// ⭐ MilestoneCard — unified with 3y / 24m (ValueNotifier + warm start)
/// ---------------------------------------------------------------------------
class _MilestoneCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbUrl;
  final Function(bool)? onChecked;
  final String childId;
  final ValueNotifier<String?> notifier;

  const _MilestoneCard({
    required this.title,
    this.imageUrl,
    this.videoUrl,
    this.thumbUrl,
    this.onChecked,
    required this.childId,
    required this.notifier,
  });

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  VideoPlayerController? _controller;
  bool isChecked = false;
  bool isPlaying = false;
  bool isPaused = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    widget.notifier.addListener(_checkPause);
    _loadCheckbox();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      _controller!.initialize().then((_) async {
        // Warm up decoder
        await _controller!.play();
        await Future.delayed(const Duration(milliseconds: 250));
        await _controller!.pause();

        // Show preview frame at 0.35s
        await _controller!.seekTo(const Duration(milliseconds: 350));

        if (mounted) {
          setState(() {
            initialized = true;
            isPlaying = false;
            isPaused = false;
          });
        }
      });

      _controller!.addListener(() {
        if (!mounted) return;

        final position = _controller!.value.position;
        final duration = _controller!.value.duration;

        // إذا الفيديو قرب ينتهي (آخر 150ms) → اعتبره انتهى وأعده لبداية المعاينة
        if (duration.inMilliseconds > 0 &&
            duration.inMilliseconds - position.inMilliseconds <= 150) {
          _controller!.pause();
          _controller!.seekTo(const Duration(milliseconds: 350)).then((_) {
            if (mounted) {
              setState(() {
                isPlaying = false;
                isPaused = false;
              });
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_checkPause);
    _controller?.dispose();
    super.dispose();
  }

  void _checkPause() {
    // إذا تم اختيار فيديو آخر كنشط وهذا الفيديو كان يعمل → أوقفه
    if (widget.notifier.value != widget.title && isPlaying) {
      _controller?.pause();
      if (mounted) {
        setState(() {
          isPlaying = false;
          isPaused = true;
        });
      }
    }
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
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
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
                    borderRadius: BorderRadius.circular(5),
                  ),
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
                      fontSize: 14,
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

  /// MEDIA (image or video with overlay)
  Widget _buildMedia() {
    // IMAGE ONLY
    if (widget.videoUrl == null) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.network(
          widget.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.error)),
        ),
      );
    }

    // VIDEO NOT READY YET
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // VIDEO PLAYER WITH PLAY/PAUSE OVERLAY
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // Not playing → show play icon
        if (!isPlaying)
          IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Colors.white.withOpacity(0.7),
            ),
            onPressed: () {
              widget.notifier.value = widget.title; // set this video as active
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // Playing → tap to pause
        if (isPlaying)
          GestureDetector(
            onTap: () {
              _controller!.pause();
              setState(() {
                isPaused = true;
                isPlaying = false;
              });
            },
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
      ],
    );
  }
}
