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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  /// 🔔 يخبر الكروت أي فيديو شغال الآن
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // يمنع تحوّل اللون عند السكروول
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
                      milestones: [
                        _MilestoneCard(
                          title: "Calms down when spoken to or picked up",
                          imageUrl: firebase("images/2m_social_calms_down.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Looks at your face",
                          imageUrl:
                              firebase("images/2m_social_looks_at_face.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Seems happy to see you when you walk up to her",
                          imageUrl:
                              firebase("images/2m_social_happy_to_see.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Smiles when you talk to or smile at her",
                          videoUrl: firebase("videos/2m_social_smile.mp4"),
                          thumbUrl:
                              firebase("images/2m_social_smile_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // SPEECH
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Makes cooing sounds",
                          videoUrl: firebase("videos/2m_language_cooing.mp4"),
                          thumbUrl:
                              firebase("images/2m_language_cooing_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Reacts to loud sounds",
                          videoUrl: firebase("videos/2m_language_reacts.mp4"),
                          thumbUrl:
                              firebase("images/2m_language_reacts_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // COGNITIVE
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Watches you as you move",
                          videoUrl: firebase("videos/2m_cognitive_watch.mp4"),
                          thumbUrl:
                              firebase("images/2m_cognitive_watch_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Looks at a toy for several seconds",
                          imageUrl:
                              firebase("images/2m_cognitive_look_toy.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // MOVEMENT
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Holds head up when on tummy",
                          imageUrl: firebase("images/2m_movement_head_up.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Moves both arms and both legs",
                          videoUrl:
                              firebase("videos/2m_movement_arms_legs.mp4"),
                          thumbUrl: firebase(
                              "images/2m_movement_arms_legs_thumb.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Opens hands briefly",
                          videoUrl:
                              firebase("videos/2m_movement_opens_hands.mp4"),
                          thumbUrl: firebase(
                              "images/2m_movement_opens_hands_thumb.jpg"),
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


                 const Text(
        "Only check milestones you're confident your child has achieved",
        style: TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF6F6F6F),
          fontSize: 13,
        ),
      ),

            const SizedBox(height: 6),
            Text(
              "$completedCount of $totalMilestones milestones complete",
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF6F6F6F),
                fontSize: 13,
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

                // إيقاف أي فيديو شغال عند تغيير القسم
                activeVideo.value = null;
              } else {
                setState(() => expandedIndex = -1);
                activeVideo.value = null;
              }
            },
            trailing: AnimatedRotation(
              turns: expandedIndex == index ? 0.5 : 0.0,
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

    // لما فيديو ثاني يصير active → نوقف هذا بس بدون reset
    _notifierListener = () {
      if (widget.notifier.value != widget.title && isPlaying) {
        _controller?.pause();
        if (mounted) {
          setState(() => isPlaying = false);
        }
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
      initialized = false; // ← يرجع للثمب
      isPlaying = false;
      loading = false;
    });
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
        .doc('2_months')
        .set({widget.title: v}, SetOptions(merge: true));
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

        // 🎯 لما يخلص الفيديو → يرجع للثمب
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
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  /// تشغيل / إكمال / إعادة تشغيل
  Future<void> _togglePlayPause() async {
    if (_controller == null) {
      // أول مرة بعد الثمب
      await _initializeAndPlay();
      return;
    }

    final v = _controller!.value;

    if (!isPlaying) {
      // لو الفيديو في آخره → أعد من البداية
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
                  borderRadius: BorderRadius.circular(5),
                ),
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

  Widget _buildMedia() {
    // 🖼 بدون فيديو → صورة فقط
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // 🎞 قبل التهيئة → نعرض الثمب + زر تشغيل أو لودينغ
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

    // 🎥 بعد التهيئة → نعرض الفيديو مع أوفرلاي للأيقونة
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
