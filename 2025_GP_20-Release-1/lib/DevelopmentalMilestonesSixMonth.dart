import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/i18n.dart';

// 🔗 Firebase Base URL
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// 🔹 Generate Firebase media URL
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesSixMonth extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesSixMonth({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesSixMonth> createState() =>
      _DevelopmentalMilestonesSixMonthState();
}

class _DevelopmentalMilestonesSixMonthState
    extends State<DevelopmentalMilestonesSixMonth> {
  int expandedIndex = 0;
  int completedCount = 0;
  final int totalMilestones = 12;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🎯 Unified video controller (same as 4m / 9m / 1y)
  final ValueNotifier<String?> activeVideo = ValueNotifier<String?>(null);

  /// 🎯 Auto-scroll to opened section
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _sectionKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  // -------------------- LOAD PROGRESS --------------------
  @override
  void initState() {
    super.initState();
    loadProgressFromFirebase();
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
          .doc('6_months')
          .get();

      if (doc.exists) {
        int count = 0;
        doc.data()!.forEach((k, v) {
          if (v == true) count++;
        });
        setState(() => completedCount = count);
      }
    } catch (_) {}
  }

  void updateProgress(bool value) {
    setState(() {
      completedCount += value ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
      if (completedCount > totalMilestones) completedCount = totalMilestones;
    });
  }

  // --------------------------------------------------------
  // BUILD UI
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final progress = completedCount / totalMilestones;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            t(context, "Developmental Milestones", "مراحل النمو والتطور"),
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
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // SOCIAL & EMOTIONAL
                    // ------------------------------------------------------------
                    _buildSection(
                      title: t(context, "Social & Emotional", "الاجتماعي والعاطفي"),
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Knows familiar people", "يتعرف على الأشخاص المألوفين"),
                          imageUrl: firebase('images/6m_knows_people.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Likes to look at herself in a mirror", "يحب النظر إلى نفسه في المرآة"),
                          imageUrl: firebase('images/6m_look_mirror.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Laughs", "يضحك"),
                          videoUrl: firebase('videos/6m_laughs.mp4'),
                          thumbUrl: firebase('images/6m_laughs_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ------------------------------------------------------------
                    // SPEECH & LANGUAGE
                    // ------------------------------------------------------------
                    _buildSection(
                      title: t(context, "Speech & Language", "الكلام واللغة"),
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Takes turns making sounds with you", "يتبادل إصدار الأصوات معك"),
                          videoUrl: firebase('videos/6m_takes_turns.mp4'),
                          thumbUrl: firebase('images/6m_takes_turns_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Blows “raspberries”", "يُصدر أصوات الفقاعات بالشفاه"),
                          videoUrl: firebase('videos/6m_raspberries.mp4'),
                          thumbUrl: firebase('images/6m_raspberries_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Makes squealing noises", "يصدر أصواتًا عالية حادة"),
                          videoUrl: firebase('videos/6m_squealing.mp4'),
                          thumbUrl: firebase('images/6m_squealing_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ------------------------------------------------------------
                    // COGNITIVE
                    // ------------------------------------------------------------
                    _buildSection(
                      title: t(context, "Cognitive Development", "التطور المعرفي"),
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Puts things in her mouth to explore them", "يضع الأشياء في فمه لاستكشافها"),
                          imageUrl: firebase('images/6m_puts_in_mouth.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Reaches to grab a toy she wants", "يمد يده ليمسك لعبة يريدها"),
                          imageUrl: firebase('images/6m_reaches_toy.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Closes lips to show she doesn’t want more food", "يغلق شفتيه ليُظهر أنه لا يريد المزيد من الطعام"),
                          videoUrl: firebase('videos/6m_closes_lips.mp4'),
                          thumbUrl: firebase('images/6m_closes_lips_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ------------------------------------------------------------
                    // MOVEMENT
                    // ------------------------------------------------------------
                    _buildSection(
                      title: t(context, "Movement & Physical Development", "التطور الحركي والبدني"),
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Rolls from tummy to back", "يتدحرج من البطن إلى الظهر"),
                          videoUrl: firebase('videos/6m_rolls_tummy_back.mp4'),
                          thumbUrl: firebase('images/6m_rolls_tummy_back_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Pushes up with straight arms when on tummy", "يدفع نفسه بذراعين مستقيمتين عند الاستلقاء على البطن"),
                          imageUrl: firebase('images/6m_pushes_arms.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Leans on hands to support herself when sitting", "يسند نفسه على يديه عند الجلوس"),
                          imageUrl: firebase('images/6m_leans_hands.jpg'),
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

  // -------------------- PROGRESS CARD --------------------
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
              t(context, "Overall Progress", "التقدم العام"),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),


                 Text(
        t(
          context,
          "Only check milestones you're confident your child has achieved",
          "حدّد فقط المعالم التي أنت متأكد أن طفلك حققها",
        ),
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF6F6F6F),
          fontSize: 13,
        ),
      ),

            const SizedBox(height: 6),
            Text(
              t(
                context,
                "$completedCount of $totalMilestones milestones complete",
                "$completedCount من أصل $totalMilestones مهارة مكتملة",
              ),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Color(0xFF6F6F6F),
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

  // -------------------- SECTION BUILDER --------------------
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
                setState(() => expandedIndex = index);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    _sectionKeys[index]!.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });

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

// ---------------------------------------------------------------------------
// ⭐ UPDATED MILESTONE CARD — SAME LOGIC AS 3y / 4y / 5y / 24m / 18m
// ---------------------------------------------------------------------------
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

    _loadCheckboxState();

    _notifierListener = () {
      // If another card starts playing, pause this one
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

  // ---------------------------------------------------------------
  // SAVE / LOAD CHECKBOX
  // ---------------------------------------------------------------
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
          .doc('15_months')
          .get();

      if (doc.exists && doc.data()![widget.title] != null) {
        setState(() => isChecked = doc.data()![widget.title]);
      }
    } catch (_) {}
  }

  Future<void> _saveCheckboxState(bool v) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('parents')
        .doc(user.uid)
        .collection('children')
        .doc(widget.childId)
        .collection('milestones')
        .doc('15_months')
        .set({widget.title: v}, SetOptions(merge: true));
  }

  // ---------------------------------------------------------------
  // VIDEO SYSTEM
  // ---------------------------------------------------------------

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

  Future<void> _initializeAndPlay() async {
    if (loading) return;
    setState(() => loading = true);

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

    try {
      await _controller!.initialize();
      if (!mounted) return;

      _controller!.addListener(() {
        if (!mounted) return;

        final v = _controller!.value;

        // Finished → reset
        if (!v.isPlaying &&
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
      // If ended, restart
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

  // ---------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
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
  }

  // ---------------------------------------------------------------
  // MEDIA (image or video)
  // ---------------------------------------------------------------
  Widget _buildMedia() {
    // IMAGE ONLY
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // BEFORE INITIALIZATION → show thumbnail + play icon
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
            )
        ],
      );
    }

    // WHEN INITIALIZED → show video
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
