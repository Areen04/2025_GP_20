import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ---------------------------------------------------------------
// 🔗 Firebase URL Base
// ---------------------------------------------------------------
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// دالة الروابط
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

  // عدد الـ milestones حسب اللي أنتِ كتبتيه بدون تغيير
  final int totalMilestones = 15;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        final data = doc.data()!;
        int c = 0;
        data.forEach((k, v) {
          if (v == true) c++;
        });
        setState(() => completedCount = c);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    double progress = completedCount / totalMilestones;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
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
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Points to show you something interesting",
                          imageUrl: firebase('images/18m_points_interest.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Puts hands out for you to wash them",
                          imageUrl: firebase('images/18m_puts_hands.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Looks at a few pages in a book with you",
                          imageUrl: firebase('images/18m_looks_book.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Helps you dress by pushing arm through sleeve or lifting up foot",
                          videoUrl: firebase('videos/18m_helps_dress.mp4'),
                          thumbUrl:
                              firebase('images/18m_helps_dress_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Follows one-step directions without gestures, like 'Give it to me'",
                          videoUrl:
                              firebase('videos/18m_follows_direction.mp4'),
                          thumbUrl: firebase(
                              'images/18m_follows_direction_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Plays with toys in a simple way, like pushing a toy car",
                          imageUrl: firebase('images/18m_push_car.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
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
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Scribbles",
                          imageUrl: firebase('images/18m_scribbles.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Drinks from a cup without a lid and may spill sometimes",
                          imageUrl: firebase('images/18m_drinks_cup.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Feeds herself with her fingers",
                          imageUrl: firebase('images/18m_feeds_fingers.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Tries to use a spoon",
                          imageUrl: firebase('images/18m_uses_spoon.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Climbs on and off a couch or chair without help",
                          imageUrl: firebase('images/18m_climbs_chair.jpg'),
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

  // ---------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------
  Widget _buildHeader(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
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
                      fontSize: 17),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  // ---------------------------------------------------------------
  // PROGRESS CARD
  // ---------------------------------------------------------------
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Overall Progress",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              "$completedCount of $totalMilestones Milestones Complete",
              style: const TextStyle(
                  fontFamily: 'Inter', fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 12),
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
  // SECTION
  // ---------------------------------------------------------------
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
            onExpansionChanged: (expanded) => setState(
                () => expanded ? expandedIndex = index : expandedIndex = -1),
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

// ---------------------------------------------------------------
// ⭐ MILESTONE CARD — COPY/PASTE FROM TwoMonth AS REQUESTED
// ---------------------------------------------------------------
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
  bool initialized = false;
  bool isPlaying = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              setState(() => initialized = true);
            });

      _controller!.addListener(() {
        if (_controller!.value.position >= _controller!.value.duration) {
          setState(() => isPlaying = false);
          _controller!.seekTo(Duration.zero);
        }
      });
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
          .doc('18_months')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
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
                offset: const Offset(0, 2)),
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

    // عرض الثمب
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
          )
        ],
      );
    }

    // تشغيل الفيديو
    if (!initialized) {
      return const SizedBox(
          height: 200, child: Center(child: CircularProgressIndicator()));
    }

    return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!));
  }
}
