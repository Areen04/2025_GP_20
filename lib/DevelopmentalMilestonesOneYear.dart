import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// -------------------------------------------------------------------------------------------------
// 🔗 Firebase Base URL
// -------------------------------------------------------------------------------------------------
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// Generate Firebase media URL
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

// -------------------------------------------------------------------------------------------------
// MAIN WIDGET
// -------------------------------------------------------------------------------------------------
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

  // Registry of all card states → to reset videos
  final List<_MilestoneCardState> _milestoneStates = [];

  // Reset all videos in all cards (called when closing a section)
  void _resetAllVideos() {
    for (var m in _milestoneStates) {
      m.resetVideo();
    }
  }

  @override
  void initState() {
    super.initState();
    loadProgressFromFirebase();
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
          .doc('1_year')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        int count = data.values.where((v) => v == true).length;
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
      // ⭐ Unified AppBar for all milestone pages
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

      // BODY
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // -------------------------------------------------------------------------------------------------
                    // SOCIAL
                    // -------------------------------------------------------------------------------------------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Waves bye-bye",
                          videoUrl: firebase('videos/1y_waves_bye.mp4'),
                          thumbUrl: firebase('images/1y_waves_bye_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Plays pat-a-cake with you",
                          videoUrl: firebase('videos/1y_plays_patacake.mp4'),
                          thumbUrl:
                              firebase('images/1y_plays_patacake_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // -------------------------------------------------------------------------------------------------
                    // LANGUAGE
                    // -------------------------------------------------------------------------------------------------
                    _buildSection(
                      title: "Language & Communication",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Says mama or dada",
                          videoUrl: firebase('videos/1y_says_mama_dada.mp4'),
                          thumbUrl:
                              firebase('images/1y_says_mama_dada_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Understands “no”",
                          videoUrl: firebase('videos/1y_understands_no.mp4'),
                          thumbUrl:
                              firebase('images/1y_understands_no_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // -------------------------------------------------------------------------------------------------
                    // COGNITIVE
                    // -------------------------------------------------------------------------------------------------
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Puts things in a container",
                          videoUrl:
                              firebase('videos/1y_puts_in_container.mp4'),
                          thumbUrl:
                              firebase('images/1y_puts_in_container_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Looks for hidden toys",
                          videoUrl:
                              firebase('videos/1y_looks_for_hidden_toy.mp4'),
                          thumbUrl:
                              firebase('images/1y_looks_for_hidden_toy_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // -------------------------------------------------------------------------------------------------
                    // MOVEMENT
                    // -------------------------------------------------------------------------------------------------
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Pulls up to stand",
                          imageUrl: firebase('images/1y_pulls_to_stand.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Walks holding furniture",
                          videoUrl:
                              firebase('videos/1y_walks_with_support.mp4'),
                          thumbUrl:
                              firebase('images/1y_walks_with_support_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Drinks from a cup",
                          videoUrl: firebase('videos/1y_drinks_from_cup.mp4'),
                          thumbUrl:
                              firebase('images/1y_drinks_from_cup_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Uses thumb + finger to pick things",
                          videoUrl: firebase('videos/1y_pincer_grasp.mp4'),
                          thumbUrl:
                              firebase('images/1y_pincer_grasp_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
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

  // -------------------------------------------------------------------------------------------------
  // PROGRESS CARD
  // -------------------------------------------------------------------------------------------------
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
                color: Colors.black54,
                fontSize: 13,
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
                    const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // -------------------------------------------------------------------------------------------------
  // SECTION BUILDER (Unified for all pages)
  // -------------------------------------------------------------------------------------------------
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
          data:
              Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (isOpen) {
              if (!isOpen) _resetAllVideos();
              setState(() => expandedIndex = isOpen ? index : -1);
            },
            iconColor: const Color(0xFF9D5C7D),

            // Rotating arrow
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

// #################################################################################################
// MILESTONE CARD — Full Unified Version (same as 3y, 4m, 9m)
// #################################################################################################

class _MilestoneCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbUrl;
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
        final finished = _controller!.value.position >=
            _controller!.value.duration;

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

  // Load checkbox state
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
        .doc('1_year')
        .set({widget.title: v}, SetOptions(merge: true));
  }

  // Pause only
  void pauseVideo() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  // Reset full
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

  // Video/Image Rendering
  Widget _buildMedia() {
    // IMAGE ONLY
    if (widget.videoUrl == null) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: Image.network(widget.imageUrl!, fit: BoxFit.cover),
      );
    }

    // VIDEO NOT READY
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // VIDEO READY → ALWAYS SHOW LAST FRAME
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // PLAY BUTTON — when not playing
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

        // PLAY BUTTON — when paused
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

        // TAP ANYWHERE TO PAUSE
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
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
