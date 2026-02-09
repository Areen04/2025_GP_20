import 'package:flutter/material.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
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
  AppLocalizations get l10n => AppLocalizations.of(context)!;

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
    final l10n = AppLocalizations.of(context)!;
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
          title: Text(
            l10n.ms_30month_developmental_milestones,
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
                      title: l10n.ms_30month_social_emotional,
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              l10n.ms_30month_plays_next_to_other_children_and_sometimes_plays_with_them,
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
                              l10n.ms_30month_shows_you_what_she_can_do_by_saying_look_at_me,
                          videoUrl: firebase('videos/30m_look_at_me.mp4'),
                          thumbUrl:
                              firebase('images/30m_look_at_me_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              l10n.ms_30month_follows_simple_routines_when_told_like_helping_to_pick_up_to,
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
                      title: l10n.ms_30month_language_communication,
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: l10n.ms_30month_says_about_50_words,
                          videoUrl: firebase('videos/30m_says_50_words.mp4'),
                          thumbUrl:
                              firebase('images/30m_says_50_words_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              l10n.ms_30month_says_two_or_more_words_together_with_one_action_word,
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
                              l10n.ms_30month_names_things_in_a_book_when_you_point_and_ask,
                          videoUrl:
                              firebase('videos/30m_names_in_book.mp4'),
                          thumbUrl:
                              firebase('images/30m_names_in_book_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_says_words_like_i_me_or_we,
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
                      title: l10n.ms_30month_cognitive_development,
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title:
                              l10n.ms_30month_uses_things_to_pretend_feeding_a_block_to_a_doll,
                          videoUrl: firebase('videos/30m_pretend_play.mp4'),
                          thumbUrl:
                              firebase('images/30m_pretend_play_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_shows_simple_problem_solving_skills,
                          videoUrl:
                              firebase('videos/30m_problem_solving.mp4'),
                          thumbUrl:
                              firebase('images/30m_problem_solving_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_follows_two_step_instructions,
                          videoUrl:
                              firebase('videos/30m_two_step_instruction.mp4'),
                          thumbUrl: firebase(
                              'images/30m_two_step_instruction_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_knows_at_least_one_color,
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
                      title: l10n.ms_30month_movement_physical_development,
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: l10n.ms_30month_uses_hands_to_twist_things,
                          imageUrl: firebase('images/30m_twist_things.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_takes_some_clothes_off_by_herself,
                          imageUrl:
                              firebase('images/30m_takes_clothes_off.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_jumps_off_the_ground_with_both_feet,
                          videoUrl:
                              firebase('videos/30m_jumps_both_feet.mp4'),
                          thumbUrl:
                              firebase('images/30m_jumps_both_feet_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: l10n.ms_30month_turns_book_pages_one_at_a_time,
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
            Text(
              l10n.ms_30month_overall_progress,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

                 Text(
        l10n.ms_30month_only_check_milestones_you_re_confident_your_child_has_achiev,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF6F6F6F),
          fontSize: 13,
        ),
      ),

            const SizedBox(height: 6),
            Text(
              l10n.ms_30month_completedcount_of_totalmilestones_milestones_complete(completedCount, totalMilestones),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF6F6F6F),
              ),
            ),
            const SizedBox(height: 6),
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
/// ⭐ MilestoneCard — identical logic to 3y / 4y / 5y (thumbnail + play/pause)
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
  bool initialized = false;
  bool loading = false;
  bool isPlaying = false;

  late final VoidCallback _notifierListener;

  @override
  void initState() {
    super.initState();
    _loadCheckbox();

    // Pause when another card becomes active
    _notifierListener = () {
      if (widget.notifier.value != widget.title && isPlaying) {
        _controller?.pause();
        if (mounted) setState(() => isPlaying = false);
      }
    };
    widget.notifier.addListener(_notifierListener);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_notifierListener);
    _controller?.dispose();
    super.dispose();
  }

  void _resetToThumbnail() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;

    setState(() {
      initialized = false;
      isPlaying = false;
      loading = false;
    });
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

  // Initialize + play on demand
  Future<void> _initializeAndPlay() async {
    if (loading) return;

    setState(() => loading = true);

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl!),
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;

      // Detect finish → reset to thumbnail
      _controller!.addListener(() {
        if (!mounted) return;

        final v = _controller!.value;
        if (v.isInitialized &&
            !v.isPlaying &&
            v.position >= v.duration &&
            v.duration > Duration.zero) {
          _resetToThumbnail();
        }
      });

      setState(() {
        initialized = true;
        loading = false;
        isPlaying = true;
      });

      widget.notifier.value = widget.title;
      _controller!.play();
    } catch (_) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _togglePlayPause() async {
    if (_controller == null) {
      await _initializeAndPlay();
      return;
    }

    final v = _controller!.value;

    if (!isPlaying) {
      if (v.position >= v.duration - const Duration(milliseconds: 200)) {
        await _controller!.seekTo(Duration.zero);
      }
      widget.notifier.value = widget.title;
      await _controller!.play();
      setState(() => isPlaying = true);
    } else {
      await _controller!.pause();
      setState(() => isPlaying = false);
    }
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
            /// Checkbox row
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

  Widget _buildMedia() {
    // no video → just image
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // video not initialized → show thumbnail + button
    if (!initialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            widget.thumbUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          if (loading)
            const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 60,
                color: Colors.white,
              ),
              onPressed: _togglePlayPause,
            ),
        ],
      );
    }

    // video is ready
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: VideoPlayer(_controller!),
          ),

          if (!isPlaying)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
