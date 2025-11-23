import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Knows familiar people",
                          imageUrl: firebase('images/6m_knows_people.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Likes to look at herself in a mirror",
                          imageUrl: firebase('images/6m_look_mirror.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Laughs",
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
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Takes turns making sounds with you",
                          videoUrl: firebase('videos/6m_takes_turns.mp4'),
                          thumbUrl: firebase('images/6m_takes_turns_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Blows “raspberries”",
                          videoUrl: firebase('videos/6m_raspberries.mp4'),
                          thumbUrl: firebase('images/6m_raspberries_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Makes squealing noises",
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
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Puts things in her mouth to explore them",
                          imageUrl: firebase('images/6m_puts_in_mouth.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Reaches to grab a toy she wants",
                          imageUrl: firebase('images/6m_reaches_toy.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Closes lips to show she doesn’t want more food",
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
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Rolls from tummy to back",
                          videoUrl: firebase('videos/6m_rolls_tummy_back.mp4'),
                          thumbUrl: firebase('images/6m_rolls_tummy_back_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Pushes up with straight arms when on tummy",
                          imageUrl: firebase('images/6m_pushes_arms.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Leans on hands to support herself when sitting",
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
// ⭐ Unified Milestone Card (same as 4m / 9m / 1y / 15m / 3y / 4y)
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
  bool isPlaying = false;
  bool isPaused = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    widget.notifier.addListener(_checkPause);
    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      _controller!.initialize().then((_) async {
        await _controller!.play();
        await Future.delayed(const Duration(milliseconds: 250));
        await _controller!.pause();
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

        final pos = _controller!.value.position;
        final dur = _controller!.value.duration;

        if (dur.inMilliseconds > 0 &&
            dur.inMilliseconds - pos.inMilliseconds <= 150) {
          _controller!.pause();
          _controller!.seekTo(const Duration(milliseconds: 350));

          if (mounted) {
            setState(() {
              isPlaying = false;
              isPaused = false;
            });
          }
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

  // Auto-pause when another video plays
  void _checkPause() {
    if (widget.notifier.value != widget.title && isPlaying) {
      _controller?.pause();
      setState(() {
        isPlaying = false;
        isPaused = true;
      });
    }
  }

  // Load checkbox state (Firebase)
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
          .doc('6_months')
          .get();

      if (doc.exists && doc.data()![widget.title] != null) {
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
        .doc('6_months')
        .set({widget.title: value}, SetOptions(merge: true));
  }

  // -------------------- MEDIA BUILDER --------------------
  Widget _buildMedia() {
    if (widget.videoUrl == null) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.network(widget.imageUrl!, fit: BoxFit.cover),
      );
    }

    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        if (!isPlaying)
          IconButton(
            icon: Icon(Icons.play_circle_fill,
                size: 60, color: Colors.white.withOpacity(0.7)),
            onPressed: () {
              widget.notifier.value = widget.title;
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

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
