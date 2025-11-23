import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ---------------------------------------------------------------
// 🔗 Firebase Base URL
// ---------------------------------------------------------------
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

// ---------------------------------------------------------------
// 📌 MAIN SCREEN — 18 MONTHS
// ---------------------------------------------------------------
class DevelopmentalMilestones18month extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones18month({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones18month> createState() =>
      _DevelopmentalMilestones18monthState();
}

class _DevelopmentalMilestones18monthState
    extends State<DevelopmentalMilestones18month> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 15;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  // 💡 EXACTLY LIKE 3-YEAR PAGE
  final ValueNotifier<String?> activeVideo = ValueNotifier<String?>(null);

  // Keys to scroll to section
  final Map<int, GlobalKey> _sectionKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    loadProgressFromFirebase();
  }

  // ---------------------------------------------------------------
  // 🔥 Load stored progress
  // ---------------------------------------------------------------
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
          .doc('18_months')
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

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      completedCount = completedCount.clamp(0, totalMilestones);
    });
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

      // -------------------------------------------------------------
      // BODY
      // -------------------------------------------------------------
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
                    // ---------------------------------------------------
                    // 🧡 SOCIAL
                    // ---------------------------------------------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Moves away from you, but looks to make sure you are close by",
                          videoUrl: firebase('videos/18m_moves_away.mp4'),
                          thumbUrl: firebase('images/18m_moves_away_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Points to show you something interesting",
                          imageUrl: firebase('images/18m_points_interest.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Puts hands out for you to wash them",
                          imageUrl: firebase('images/18m_puts_hands.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Looks at a few pages in a book with you",
                          imageUrl: firebase('images/18m_looks_book.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Helps you dress by pushing arm through sleeve or lifting up foot",
                          videoUrl: firebase('videos/18m_helps_dress.mp4'),
                          thumbUrl:
                              firebase('images/18m_helps_dress_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ---------------------------------------------------
                    // 💬 SPEECH
                    // ---------------------------------------------------
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Tries to say three or more words besides 'mama' or 'dada'",
                          videoUrl: firebase('videos/18m_say_words.mp4'),
                          thumbUrl: firebase('images/18m_say_words_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Follows one-step directions without gestures, like 'Give it to me'",
                          videoUrl:
                              firebase('videos/18m_follows_direction.mp4'),
                          thumbUrl:
                              firebase('images/18m_follows_direction_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ---------------------------------------------------
                    // 🧠 COGNITIVE
                    // ---------------------------------------------------
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Copies you doing chores, like sweeping with a broom",
                          videoUrl: firebase('videos/18m_copies_chores.mp4'),
                          thumbUrl:
                              firebase('images/18m_copies_chores_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Plays with toys in a simple way, like pushing a toy car",
                          imageUrl: firebase('images/18m_push_car.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // ---------------------------------------------------
                    // 💪 MOVEMENT
                    // ---------------------------------------------------
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Walks without holding on to anyone or anything",
                          videoUrl: firebase('videos/18m_walks.mp4'),
                          thumbUrl: firebase('images/18m_walks_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Scribbles",
                          imageUrl: firebase('images/18m_scribbles.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Drinks from a cup without a lid and may spill sometimes",
                          imageUrl: firebase('images/18m_drinks_cup.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Feeds herself with her fingers",
                          imageUrl: firebase('images/18m_feeds_fingers.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Tries to use a spoon",
                          imageUrl: firebase('images/18m_uses_spoon.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              "Climbs on and off a couch or chair without help",
                          imageUrl: firebase('images/18m_climbs_chair.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
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

  // ---------------------------------------------------------------
  // PROGRESS CARD — same as 3-year/4-year
  // ---------------------------------------------------------------
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
                  fontSize: 18),
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
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );
  // ---------------------------------------------------------------
  // SECTION — same behavior as 3-year page:
  // - Scroll into view
  // - Arrow rotation
  // - Auto-stop other videos via ValueNotifier
  // ---------------------------------------------------------------
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

                // Scroll exactly like 3-year page
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    _sectionKeys[index]!.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });

                // Stop all videos
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

// ---------------------------------------------------------------
// ⭐ MILESTONE CARD — IDENTICAL LOGIC TO 3-YEAR
// ---------------------------------------------------------------
class _MilestoneCard extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbUrl;
  final Function(bool)? onChecked;
  final String childId;

  // NEW: same notifier as 3-year page
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

    // notifier watches current playing card
    widget.notifier.addListener(_checkPause);

    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      _controller!.initialize().then((_) async {
        // Warm up decoder like 3-year page
        await _controller!.play();
        await Future.delayed(const Duration(milliseconds: 250));
        await _controller!.pause();

        // Show preview at 0.35s
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

  // ⛔ Pause if another card starts playing
  void _checkPause() {
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

  // ---------------------------------------------------------------
  // CHECKBOX SAVE / LOAD
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
          .doc('18_months')
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
        .doc('18_months')
        .set({widget.title: v}, SetOptions(merge: true));
  }

  // ---------------------------------------------------------------
  // CARD UI
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
  // MEDIA CONTENT (VIDEO + IMAGE) — SAME AS 3-YEAR
  // ---------------------------------------------------------------
  Widget _buildMedia() {
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
        ),
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

        // Play button — same icon style as 3-year
        if (!isPlaying)
          IconButton(
            icon: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Colors.white.withOpacity(0.7),
            ),
            onPressed: () {
              widget.notifier.value = widget.title;
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // Tap to pause
        if (isPlaying)
          GestureDetector(
            onTap: () {
              _controller!.pause();
              setState(() {
                isPlaying = false;
                isPaused = true;
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
