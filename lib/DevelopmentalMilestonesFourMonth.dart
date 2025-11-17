import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔗 Firebase Base URL
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// 🔹 Generate Firebase File URL
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesFourMonth extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesFourMonth({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesFourMonth> createState() =>
      _DevelopmentalMilestonesFourMonthState();
}

class _DevelopmentalMilestonesFourMonthState
    extends State<DevelopmentalMilestonesFourMonth> {
  int expandedIndex = 0;
  int completedCount = 0;
  final int totalMilestones = 13;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateProgress(bool checked) {
    setState(() {
      completedCount += checked ? 1 : -1;
      if (completedCount < 0) completedCount = 0;
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
          .doc('4_months')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        int count = data.values.where((v) => v == true).length;
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
            _buildHeader(), // ← ثابت 100%
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // ----------------- SOCIAL -----------------
                    _buildSection(
                      title: "Social & Emotional Milestones",
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title: "Smiles on his own to get your attention",
                          videoUrl: firebase('videos/4m_smiles_attention.mp4'),
                          thumbUrl:
                              firebase('images/4m_smiles_attention_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Chuckles (not a full laugh) when you try to make her laugh",
                          videoUrl: firebase('videos/4m_chuckles.mp4'),
                          thumbUrl: firebase('images/4m_chuckles_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title:
                              "Looks at you, moves, or makes sounds to get your attention",
                          videoUrl:
                              firebase('videos/4m_looks_moves_attention.mp4'),
                          thumbUrl: firebase(
                              'images/4m_looks_moves_attention_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    // ----------------- SPEECH -----------------
                    _buildSection(
                      title: "Speech & Language",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title: "Makes sounds like 'ooo', 'aahh' (cooing)",
                          videoUrl: firebase('videos/4m_cooing.mp4'),
                          thumbUrl: firebase('images/4m_cooing_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Makes sounds back when you talk to her",
                          videoUrl: firebase('videos/4m_talk_back.mp4'),
                          thumbUrl: firebase('images/4m_talk_back_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Turns head towards sound of your voice",
                          videoUrl: firebase('videos/4m_turns_head.mp4'),
                          thumbUrl: firebase('images/4m_turns_head_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    // ----------------- COGNITIVE -----------------
                    _buildSection(
                      title: "Cognitive Development",
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "If hungry, opens mouth when she sees breast or bottle",
                          imageUrl: firebase('images/4m_open_mouth_hungry.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Looks at hands with interest",
                          videoUrl: firebase('videos/4m_looks_hands.mp4'),
                          thumbUrl: firebase('images/4m_looks_hands_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                      ],
                    ),

                    // ----------------- MOVEMENT -----------------
                    _buildSection(
                      title: "Movement & Physical Development",
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: "Holds head steady without support",
                          videoUrl: firebase('videos/4m_hold_head.mp4'),
                          thumbUrl: firebase('images/4m_hold_head_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Holds a toy when you put it in her hand",
                          videoUrl: firebase('videos/4m_hold_toy.mp4'),
                          thumbUrl: firebase('images/4m_hold_toy_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Uses arm to swing at toys",
                          videoUrl: firebase('videos/4m_swing_toys.mp4'),
                          thumbUrl: firebase('images/4m_swing_toys_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Brings hands to mouth",
                          videoUrl: firebase('videos/4m_hands_to_mouth.mp4'),
                          thumbUrl:
                              firebase('images/4m_hands_to_mouth_thumb.jpg'),
                          childId: widget.childId,
                          onChecked: updateProgress,
                        ),
                        _MilestoneCard(
                          title: "Pushes up onto elbows/forearms when on tummy",
                          imageUrl: firebase('images/4m_push_elbows.jpg'),
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

  // ------------------------------------------------------------
  //                 HEADER (ثاااابت)
  // ------------------------------------------------------------
  Widget _buildHeader() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.25))),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF9D5C7D), size: 18),
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

  // ------------------------------------------------------------
  //                      Progress Card
  // ------------------------------------------------------------
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
            Text("$completedCount of $totalMilestones milestones complete",
                style: const TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.25),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // ------------------------------------------------------------
  //                      Section Builder
  // ------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required int index,
    required List<Widget> milestones,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),

        // ✨ هذا border مثل Two Month بالضبط
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E2E6)),
        ),

        // ✨ وهذا يخفي الخط اللي داخل الـ ExpansionTile
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: expandedIndex == index,
            onExpansionChanged: (v) =>
                setState(() => expandedIndex = v ? index : -1),
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

// #####################################################################
//                 M I L E S T O N E   C A R D
//                 (Video يعيد نفسه + يرجع زر Play)
// #####################################################################

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

      // 🔥 لما ينتهي الفيديو → يرجع زر Play
      _controller!.addListener(() {
        if (_controller!.value.position >= _controller!.value.duration) {
          if (isPlaying) {
            setState(() => isPlaying = false);
          }
        }
      });
    }
  }

  // ---------------- FIREBASE CHECKBOX ----------------

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
          .doc('4_months')
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
          .doc('4_months')
          .set({widget.title: value}, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  //                     MEDIA BUILDER
  // ------------------------------------------------------------
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

    // قبل الضغط — نعرض الثمب
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
          ),
        ],
      );
    }

    // بعد الضغط — عرض الفيديو
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

  // ------------------------------------------------------------
  //                       CARD UI
  // ------------------------------------------------------------
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
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
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
}
