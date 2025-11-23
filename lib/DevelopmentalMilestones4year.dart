import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط الأساس Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// دالة روابط
String firebase(String path) =>
    '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';

class DevelopmentalMilestones4year extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones4year({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones4year> createState() =>
      _DevelopmentalMilestones4yearState();
}

class _DevelopmentalMilestones4yearState
    extends State<DevelopmentalMilestones4year> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 17;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<_MilestoneCardState> _milestoneStates = [];

  void _resetAllVideos() {
    for (var s in _milestoneStates) {
      s.resetVideo();
    }
  }

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
          .doc('4_years')
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
                              "Pretends to be something else during play (teacher, superhero, dog)",
                          videoUrl: firebase('videos/4y_pretends_play.mp4'),
                          thumbUrl: firebase('images/4y_pretends_play.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Asks to go play with children if none are around",
                          videoUrl: firebase('videos/4y_asks_play.mp4'),
                          thumbUrl: firebase('images/4y_asks_play.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Comforts others who are hurt or sad, like hugging a crying friend",
                          imageUrl: firebase('images/4y_comforts_others.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Avoids danger, like not jumping from tall heights at the playground",
                          videoUrl: firebase('videos/4y_avoids_danger.mp4'),
                          thumbUrl: firebase('images/4y_avoids_danger.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Likes to be a helper",
                          videoUrl: firebase('videos/4y_likes_helper.mp4'),
                          thumbUrl: firebase('images/4y_likes_helper.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Changes behavior based on where she is (library, playground, etc.)",
                          videoUrl: firebase('videos/4y_changes_behavior.mp4'),
                          thumbUrl: firebase('images/4y_changes_behavior.jpg'),
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
                          title: "Says sentences with four or more words",
                          videoUrl: firebase('videos/4y_says_sentences.mp4'),
                          thumbUrl: firebase('images/4y_says_sentences.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Says some words from a song, story, or nursery rhyme",
                          videoUrl: firebase('videos/4y_says_words_song.mp4'),
                          thumbUrl: firebase('images/4y_says_words_song.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Talks about at least one thing that happened during her day",
                          videoUrl: firebase('videos/4y_talks_about_day.mp4'),
                          thumbUrl: firebase('images/4y_talks_about_day.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Answers simple questions like 'What is a coat for?'",
                          videoUrl: firebase('videos/4y_answers_questions.mp4'),
                          thumbUrl: firebase('images/4y_answers_questions.jpg'),
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
                          title: "Names a few colors of items",
                          videoUrl: firebase('videos/4y_names_colors.mp4'),
                          thumbUrl: firebase('images/4y_names_colors.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Tells what comes next in a well-known story",
                          videoUrl: firebase('videos/4y_tells_next_story.mp4'),
                          thumbUrl: firebase('images/4y_tells_next_story.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Draws a person with three or more body parts",
                          imageUrl: firebase('images/4y_draws_person.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // PHYSICAL
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Catches a large ball most of the time",
                          imageUrl: firebase('images/4y_catches_ball.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Serves herself food or pours water",
                          imageUrl: firebase('images/4y_serves_food.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Unbuttons some buttons",
                          videoUrl: firebase('videos/4y_unbuttons_buttons.mp4'),
                          thumbUrl: firebase('images/4y_unbuttons_buttons.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Holds crayon or pencil between fingers and thumb (not a fist)",
                          imageUrl: firebase('images/4y_holds_pencil.jpg'),
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

// ★★★ MilestoneCard — مطابق تماماً لصفحة 3 سنوات
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
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

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
          .doc('4_years')
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
        .doc('4_years')
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

  Widget _buildMedia() {
    // IMAGE
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

    // VIDEO LOADING
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // ALWAYS SHOW FIRST FRAME UNTIL PLAYING
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // BEFORE PLAYING
        if (!isPlaying && !isPaused)
          IconButton(
            icon: Icon(Icons.play_circle_fill,
                size: 60, color: Colors.white.withOpacity(0.6)),
            onPressed: () {
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // WHEN PAUSED
        if (isPaused)
          IconButton(
            icon: Icon(Icons.play_circle_fill,
                size: 60, color: Colors.white.withOpacity(0.6)),
            onPressed: () {
              setState(() {
                isPlaying = true;
                isPaused = false;
              });
              _controller!.play();
            },
          ),

        // WHEN PLAYING
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
