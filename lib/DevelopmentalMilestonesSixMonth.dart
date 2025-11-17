import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ رابط قاعدة ملفات Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// ✅ دالة توليد الرابط (تضيف token إذا وُجد)
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

  void updateProgress(bool isChecked) {
    setState(() {
      completedCount += isChecked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
    });
  }

  // ✅ تحميل التقدّم من Firebase
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context), // ← ثابت

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
                      isExpanded: expandedIndex == 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Knows familiar people",
                          imageUrl: firebase('images/6m_knows_people.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Likes to look at herself in a mirror",
                          imageUrl: firebase('images/6m_look_mirror.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Laughs",
                          videoUrl: firebase('videos/6m_laughs.mp4'),
                          thumbUrl: firebase('images/6m_laughs_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 💬 Speech & Language
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      isExpanded: expandedIndex == 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Takes turns making sounds with you",
                          videoUrl: firebase('videos/6m_takes_turns.mp4'),
                          thumbUrl: firebase('images/6m_takes_turns_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Blows “raspberries” (sticks tongue out and blows)",
                          videoUrl: firebase('videos/6m_raspberries.mp4'),
                          thumbUrl: firebase('images/6m_raspberries_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Makes squealing noises",
                          videoUrl: firebase('videos/6m_squealing.mp4'),
                          thumbUrl: firebase('images/6m_squealing_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 🧠 Cognitive
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      isExpanded: expandedIndex == 2,
                      milestones: [
                        _MilestoneCard(
                          title: "Puts things in her mouth to explore them",
                          imageUrl: firebase('images/6m_puts_in_mouth.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Reaches to grab a toy she wants",
                          imageUrl: firebase('images/6m_reaches_toy.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Closes lips to show she doesn’t want more food",
                          videoUrl: firebase('videos/6m_closes_lips.mp4'),
                          thumbUrl: firebase('images/6m_closes_lips_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                      ],
                    ),

                    // 💪 Movement
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      isExpanded: expandedIndex == 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Rolls from tummy to back",
                          videoUrl: firebase('videos/6m_rolls_tummy_back.mp4'),
                          thumbUrl:
                              firebase('images/6m_rolls_tummy_back_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title: "Pushes up with straight arms when on tummy",
                          imageUrl: firebase('images/6m_pushes_arms.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                        ),
                        _MilestoneCard(
                          title:
                              "Leans on hands to support herself when sitting",
                          imageUrl: firebase('images/6m_leans_hands.jpg'),
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
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

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
            Text("$completedCount of $totalMilestones Milestones Complete",
                style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.black54)),
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
    required bool isExpanded,
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
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => expandedIndex = expanded ? index : -1),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            iconColor: const Color(0xFF9D5C7D),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            children: milestones,
          ),
        ),
      );
}
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

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();

    if (widget.videoUrl != null) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              _controller?.setLooping(false);
              _controller?.addListener(_videoListener);
              setState(() {});
            });
    }
  }

  // 🔥🔥 يرجع للثمب بعد الانتهاء EXACTLY like six month
  void _videoListener() {
    if (_controller!.value.position >= _controller!.value.duration) {
      setState(() {
        isPlaying = false;
      });
      _controller!.pause();
      _controller!.seekTo(Duration.zero);
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
          .doc('2_months')
          .get();

      if (doc.exists && doc.data()?[widget.title] != null) {
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

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  value: isChecked,
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => isChecked = val);
                    widget.onChecked?.call(val);
                    _saveCheckboxState(val);
                  },
                ),
                Expanded(
                  child: Text(widget.title,
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildMedia(),
            ),
          ],
        ),
      );

  Widget _buildMedia() {
    // صورة بدون فيديو
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // قبل التشغيل → الثمب
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
    if (_controller?.value.isInitialized ?? false) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    }

    return const Center(
      child: SizedBox(
        height: 200,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
