import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط الأساس Firebase (نفس TwoMonth)
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// دالة روابط
String firebase(String path) =>
    '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';

class DevelopmentalMilestones3year extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones3year({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones3year> createState() =>
      _DevelopmentalMilestones3yearState();
}

class _DevelopmentalMilestones3yearState
    extends State<DevelopmentalMilestones3year> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 12;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // تحميل من Firebase
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
          .doc('3_years')
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
      if (completedCount < 0) completedCount = 0;
      if (completedCount > totalMilestones) completedCount = totalMilestones;
    });
  }
final List<_MilestoneCardState> _milestoneStates = [];

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

  @override
  Widget build(BuildContext context) {
    double progress = completedCount / totalMilestones;

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
            // ثابت

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // SOCIAL
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Calms down within 10 minutes after you leave her",
                          imageUrl: firebase('images/3y_calms_down.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Notices other children and joins them to play",
                          videoUrl: firebase('videos/3y_notices_children.mp4'),
                          thumbUrl: firebase('images/3y_notices_children.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // SPEECH
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Talks with you in at least two back-and-forth exchanges",
                          videoUrl: firebase('videos/3y_talks_with_you.mp4'),
                          thumbUrl: firebase('images/3y_talks_with_you.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Asks “who”, “what”, “where”, or “why” questions",
                          videoUrl: firebase('videos/3y_asks_questions.mp4'),
                          thumbUrl: firebase('images/3y_asks_questions.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Says what action is happening in a picture or book",
                          videoUrl: firebase('videos/3y_says_action.mp4'),
                          thumbUrl: firebase('images/3y_says_action.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Says first name when asked",
                          videoUrl: firebase('videos/3y_says_first_name.mp4'),
                          thumbUrl: firebase('images/3y_says_first_name.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Talks well enough for others to understand",
                          videoUrl: firebase('videos/3y_talks_clear.mp4'),
                          thumbUrl: firebase('images/3y_talks_clear.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // COGNITIVE
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Draws a circle when you show her how",
                          videoUrl: firebase('videos/3y_draws_circle.mp4'),
                          thumbUrl: firebase('images/3y_draws_circle.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Avoids touching hot objects",
                          videoUrl:
                              firebase('videos/3y_avoids_hot_objects.mp4'),
                          thumbUrl:
                              firebase('images/3y_avoids_hot_objects.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // MOVEMENT
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Strings items together like beads",
                          imageUrl: firebase('images/3y_strings_items.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Puts on some clothes by herself",
                          imageUrl: firebase('images/3y_puts_clothes.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Uses a fork",
                          imageUrl: firebase('images/3y_uses_fork.jpg'),
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

 
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overall Progress",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),
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
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
         child: ExpansionTile(
  initiallyExpanded: expandedIndex == index,
  onExpansionChanged: (isOpen) {
    if (!isOpen) _resetAllVideos();
    setState(() => expandedIndex = isOpen ? index : -1);
  },

  iconColor: const Color(0xFF9D5C7D),

  // ⭐ CUSTOM ROTATING ARROW
  trailing: AnimatedRotation(
    turns: expandedIndex == index ? 0.5 : 0,   // 0 → down, 0.5 → up
    duration: const Duration(milliseconds: 250),
    child: const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 32,                                 // 👈 bigger size
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
  childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  children: milestones,
),
        ),
      );
}

// ★★★ MilestoneCard — نفس TwoMonth 100%
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
  bool isPaused = false;     // video is paused but frame still visible
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    widget.stateRegistry.add(this);

    _loadCheckboxState();

  if (widget.videoUrl != null) {
  _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

  _controller!.initialize().then((_) async {
    // Forces video engine to render something
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
          .doc('3_years')
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
        .doc('3_years')
        .set({widget.title: v}, SetOptions(merge: true));
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
    setState(() => isPlaying = false); // show thumbnail again
  }
}

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
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

Widget _buildMedia() {
  // IMAGE MILESTONE (no video)
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

  // VIDEO NOT READY YET
  if (!initialized) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  // ALWAYS SHOW VIDEO FRAME — EVEN BEFORE PLAYING
  return Stack(
    alignment: Alignment.center,
    children: [
      SizedBox(
        height: 200,
        width: double.infinity,
        child: VideoPlayer(_controller!),
      ),

      // BEFORE PLAYING → SHOW PLAY ICON
      if (!isPlaying && !isPaused)
        IconButton(
          icon:  Icon(Icons.play_circle_fill,
              size: 60, color: Colors.white.withOpacity(0.6)),
          onPressed: () {
            setState(() {
              isPlaying = true;
              isPaused = false;
            });
            _controller!.play();
          },
        ),

      // WHEN PAUSED → SHOW PLAY ICON AGAIN
      if (isPaused)
        IconButton(
          icon:  Icon(Icons.play_circle_fill,
              size: 60, color: Colors.white.withOpacity(0.6)),
          onPressed: () {
            setState(() {
              isPlaying = true;
              isPaused = false;
            });
            _controller!.play();
          },
        ),

      // WHEN PLAYING → TAP ANYWHERE TO PAUSE
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
            color: Colors.transparent, // no dark dim
          ),
        ),
    ],
  );
}
}
