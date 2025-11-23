import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 Firebase base URL
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// Generate Firebase URL
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

  // Registry to reset all videos when sections collapse
  final List<_MilestoneCardState> _milestoneStates = [];

  void _resetAllVideos() {
    for (var m in _milestoneStates) {
      m.resetVideo();
    }
  }

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
    surfaceTintColor: Colors.white,
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

    // ⭐ EXACT SAME LINE AS 15-MONTH PAGE
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
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Looks at your face",
                          imageUrl:
                              firebase("images/2m_social_looks_at_face.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Seems happy to see you when you walk up to her",
                          imageUrl:
                              firebase("images/2m_social_happy_to_see.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Smiles when you talk to or smile at her",
                          videoUrl: firebase("videos/2m_social_smile.mp4"),
                          // thumbUrl not needed in new system, kept optional
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // ---------------------------
                    // SPEECH
                    // ---------------------------
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Makes cooing sounds",
                          videoUrl: firebase("videos/2m_language_cooing.mp4"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Reacts to loud sounds",
                          videoUrl: firebase("videos/2m_language_reacts.mp4"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // ---------------------------
                    // COGNITIVE
                    // ---------------------------
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Watches you as you move",
                          videoUrl: firebase("videos/2m_cognitive_watch.mp4"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Looks at a toy for several seconds",
                          imageUrl:
                              firebase("images/2m_cognitive_look_toy.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // ---------------------------
                    // MOVEMENT
                    // ---------------------------
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Holds head up when on tummy",
                          imageUrl:
                              firebase("images/2m_movement_head_up.jpg"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Moves both arms and both legs",
                          videoUrl:
                              firebase("videos/2m_movement_arms_legs.mp4"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Opens hands briefly",
                          videoUrl:
                              firebase("videos/2m_movement_opens_hands.mp4"),
                          childId: widget.childId,
                          onChecked: updateProgress,
                          stateRegistry: _milestoneStates,
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

  // ---------------- PROGRESS CARD ----------------
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
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // ---------------- SECTION BUILDER ----------------
  Widget _buildSection({
    required String title,
    required int index,
    required List<Widget> milestones,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (isOpen) {
              if (!isOpen) _resetAllVideos();
              setState(() => expandedIndex = isOpen ? index : -1);
            },
            iconColor: const Color(0xFF9D5C7D),
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

// #####################################################################
// UNIFIED MILESTONE CARD
// #####################################################################

class _MilestoneCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbUrl; // kept but not needed now
  final Function(bool)? onChecked;
  final String childId;
  final List<_MilestoneCardState> stateRegistry;

  const _MilestoneCard({
    required this.title,
    this.imageUrl,
    this.videoUrl,
    this.thumbUrl,
    this.onChecked,
    required this.childId,
    required this.stateRegistry,
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
    widget.stateRegistry.add(this);

    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      _controller!.initialize().then((_) async {
        // Trick to force first frame rendering
        await _controller!.setLooping(true);
        await _controller!.play();
        await Future.delayed(const Duration(milliseconds: 80));
        await _controller!.pause();

        setState(() {
          initialized = true;
          isPlaying = false;
          isPaused = false;
        });
      });

      _controller!.addListener(() {
        if (_controller == null) return;
        final finished =
            _controller!.value.position >= _controller!.value.duration;

        if (finished) {
          setState(() {
            isPlaying = false;
            isPaused = false;
          });
          _controller!.seekTo(Duration.zero);
          _controller!.pause();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.stateRegistry.remove(this);
    _controller?.dispose();
    super.dispose();
  }

  // Load checkbox state from Firestore (2_months)
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

  void pauseVideo() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  void resetVideo() {
    if (_controller != null) {
      _controller!.pause();
      _controller!.seekTo(Duration.zero);
      setState(() {
        isPlaying = false;
        isPaused = false;
      });
    }
  }

  Widget _buildMedia() {
    // IMAGE ONLY
    if (widget.videoUrl == null) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.network(
          widget.imageUrl!,
          fit: BoxFit.cover,
        ),
      );
    }

    // VIDEO NOT READY
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // VIDEO READY — show frame + overlay controls
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // Show play icon when not playing
        if (!isPlaying && !isPaused)
          IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Colors.white.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // Show play icon again when paused
        if (isPaused)
          IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Colors.white.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // Tap anywhere to pause when playing
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
          color: const Color(0xFFFFFFFF),
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
