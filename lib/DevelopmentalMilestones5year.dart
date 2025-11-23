import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// دالة روابط
String firebase(String path) =>
    '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';

class DevelopmentalMilestones5year extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestones5year({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestones5year> createState() =>
      _DevelopmentalMilestones5yearState();
}

class _DevelopmentalMilestones5yearState
    extends State<DevelopmentalMilestones5year> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 15;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ScrollController _scrollController = ScrollController();

  /// 🔔 نفس نظام 3 سنوات: فيديو نشط واحد فقط
  final ValueNotifier<String?> activeVideo = ValueNotifier<String?> (null);

  // 🔗 Keys to scroll sections
  final Map<int, GlobalKey> _sectionKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
  };

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
          .doc('5_years')
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
    loadProgressFromFirebase();
  }

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
      if (completedCount > totalMilestones) completedCount = totalMilestones;
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // ------------------ SECTIONS ------------------

                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Follows rules or takes turns when playing games with other children",
                          imageUrl: firebase('images/5y_follows_rules.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Does simple chores at home",
                          imageUrl: firebase('images/5y_does_chores.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Sings, dances, or acts for you",
                          videoUrl: firebase('videos/5y_sings_dances.mp4'),
                          thumbUrl: firebase('images/5y_sings_dances.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Tells a story she heard or made up",
                          videoUrl: firebase('videos/5y_tells_story.mp4'),
                          thumbUrl: firebase('images/5y_tells_story.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Answers simple questions about a story",
                          videoUrl: firebase('videos/5y_answers_questions.mp4'),
                          thumbUrl: firebase('images/5y_answers_questions.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Keeps a conversation going",
                          videoUrl: firebase('videos/5y_keeps_conversation.mp4'),
                          thumbUrl: firebase('images/5y_keeps_conversation.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Recognizes simple rhymes",
                          videoUrl: firebase('videos/5y_recognizes_rhymes.mp4'),
                          thumbUrl: firebase('images/5y_recognizes_rhymes.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Counts to 10",
                          videoUrl: firebase('videos/5y_counts_to10.mp4'),
                          thumbUrl: firebase('images/5y_counts_to10.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Names some numbers between 1–5",
                          videoUrl: firebase('videos/5y_names_numbers.mp4'),
                          thumbUrl: firebase('images/5y_names_numbers.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Uses time words like yesterday / morning",
                          videoUrl: firebase('videos/5y_uses_words_time.mp4'),
                          thumbUrl: firebase('images/5y_uses_words_time.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Pays attention for 5–10 minutes",
                          videoUrl: firebase('videos/5y_pays_attention.mp4'),
                          thumbUrl: firebase('images/5y_pays_attention.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Writes some letters in her name",
                          videoUrl: firebase('videos/5y_writes_letters.mp4'),
                          thumbUrl: firebase('images/5y_writes_letters.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Names some letters",
                          videoUrl: firebase('videos/5y_names_letters.mp4'),
                          thumbUrl: firebase('images/5y_names_letters.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Buttons some buttons",
                          videoUrl: firebase('videos/5y_buttons_buttons.mp4'),
                          thumbUrl: firebase('images/5y_buttons_buttons.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: "Hops on one foot",
                          imageUrl: firebase('images/5y_hops_one_foot.jpg'),
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
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
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
                setState(() => expandedIndex = index);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    _sectionKeys[index]!.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });

                activeVideo.value = null; // stop all videos
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
            childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: milestones,
          ),
        ),
      );
}

// ★★★ MilestoneCard مع نفس النظام بالضبط مثل 3 سنوات
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
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

      _controller!.initialize().then((_) async {
        await _controller!.play();
        await Future.delayed(const Duration(milliseconds: 250));
        await _controller!.pause();
        await _controller!.seekTo(const Duration(milliseconds: 350));

        if (mounted) {
          setState(() {
            initialized = true;
          });
        }

        _controller!.addListener(() {
          if (!mounted) return;

          final pos = _controller!.value.position;
          final dur = _controller!.value.duration;

          if (dur.inMilliseconds > 0 &&
              dur.inMilliseconds - pos.inMilliseconds <= 150) {
            _controller!.pause();
            _controller!.seekTo(const Duration(milliseconds: 350));
            setState(() {
              isPlaying = false;
              isPaused = false;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_checkPause);
    _controller?.dispose();
    super.dispose();
  }

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

  Future<void> _loadCheckboxState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('parents')
        .doc(user.uid)
        .collection('children')
        .doc(widget.childId)
        .collection('milestones')
        .doc('5_years')
        .get();

    if (doc.exists && doc.data()![widget.title] != null) {
      setState(() => isChecked = doc.data()![widget.title]);
    }
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
        .doc('5_years')
        .set({widget.title: v}, SetOptions(merge: true));
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
          // --- Checkbox row ---
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

  // ------------------ MEDIA (Video or Image) ------------------
  Widget _buildMedia() {
    // IMAGE ONLY
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

    // VIDEO LOADING
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // VIDEO
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // SHOW PLAY ICON WHEN NOT PLAYING
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

        // TAP ANYWHERE TO PAUSE
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
