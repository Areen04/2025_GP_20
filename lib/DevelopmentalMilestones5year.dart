import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 رابط الأساس لتخزين Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// 🔹 دالة توليد الرابط
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

  // تحميل التقدم
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
        int count = 0;
        doc.data()!.forEach((key, value) {
          if (value == true) count++;
        });
        setState(() => completedCount = count);
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
    final progress = completedCount / totalMilestones;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context), // ثابت

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // 🧡 Social & Emotional
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Follows rules or takes turns when playing games with other children",
                          imageUrl: firebase('images/5y_follows_rules.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Does simple chores at home, like matching socks or clearing the table after eating",
                          imageUrl: firebase('images/5y_does_chores.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Sings, dances, or acts for you",
                          videoUrl: firebase('videos/5y_sings_dances.mp4'),
                          thumbUrl: firebase('images/5y_sings_dances.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 💬 Speech & Language
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Tells a story she heard or made up with at least two events",
                          videoUrl: firebase('videos/5y_tells_story.mp4'),
                          thumbUrl: firebase('images/5y_tells_story.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Answers simple questions about a book or story after you read or tell it to her",
                          videoUrl: firebase('videos/5y_answers_questions.mp4'),
                          thumbUrl: firebase('images/5y_answers_questions.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Keeps a conversation going with more than three back-and-forth exchanges",
                          videoUrl:
                              firebase('videos/5y_keeps_conversation.mp4'),
                          thumbUrl:
                              firebase('images/5y_keeps_conversation.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Uses or recognizes simple rhymes (bat-cat, ball-tall)",
                          videoUrl: firebase('videos/5y_recognizes_rhymes.mp4'),
                          thumbUrl: firebase('images/5y_recognizes_rhymes.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 🧠 Cognitive Development
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
                        ),
                        _MilestoneCard(
                          title:
                              "Names some numbers between 1 and 5 when you point to them",
                          videoUrl: firebase('videos/5y_names_numbers.mp4'),
                          thumbUrl: firebase('images/5y_names_numbers.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Uses words about time, like “yesterday,” “tomorrow,” “morning,” or “night”",
                          videoUrl: firebase('videos/5y_uses_words_time.mp4'),
                          thumbUrl: firebase('images/5y_uses_words_time.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Pays attention for 5 to 10 minutes during activities (e.g., story time or arts & crafts)",
                          videoUrl: firebase('videos/5y_pays_attention.mp4'),
                          thumbUrl: firebase('images/5y_pays_attention.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Writes some letters in her name",
                          videoUrl: firebase('videos/5y_writes_letters.mp4'),
                          thumbUrl: firebase('images/5y_writes_letters.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Names some letters when you point to them",
                          videoUrl: firebase('videos/5y_names_letters.mp4'),
                          thumbUrl: firebase('images/5y_names_letters.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 💪 Movement / Physical
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
                        ),
                        _MilestoneCard(
                          title: "Hops on one foot",
                          imageUrl: firebase('images/5y_hops_one_foot.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
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

  // HEADER ثابت
  Widget _buildHeader(BuildContext context) => Container(
        height: 58,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.25)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF9D5C7D),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Developmental Milestones",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  // Progress Card
  Widget _buildProgressCard(double progress) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overall Progress",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              "$completedCount of $totalMilestones milestones complete",
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Colors.black54,
                fontSize: 14,
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E2E6)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (v) =>
                setState(() => expandedIndex = v ? index : -1),
            iconColor: const Color(0xFF9D5C7D),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: milestones,
          ),
        ),
      );
}

// 🎵 بطاقة المهارة — نسخة TwoMonth 100%
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
  bool isChecked = false;
  bool isPlaying = false;
  bool initialized = false;

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
        final finished =
            _controller!.value.position >= _controller!.value.duration;

        if (finished) {
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
          .doc('5_years')
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
        .doc('5_years')
        .set({widget.title: value}, SetOptions(merge: true));
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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  activeColor: const Color(0xFF9D5C7D),
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
                      fontSize: 15,
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
    // صورة فقط
    if (widget.imageUrl != null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // ثــــــمـــب (Play)
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
            icon: const Icon(
              Icons.play_circle_fill,
              size: 60,
              color: Color(0xFF9D5C7D),
            ),
            onPressed: () {
              setState(() => isPlaying = true);
              _controller?.play();
            },
          ),
        ],
      );
    }

    // تشغيل الفيديو
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}
