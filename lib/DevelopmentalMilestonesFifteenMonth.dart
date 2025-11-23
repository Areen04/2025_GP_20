import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ رابط Firebase
const String baseFirebaseURL =
    'https://firebasestorage.googleapis.com/v0/b/rafiq-app-95bb1.firebasestorage.app/o/';

// ✅ دالة توليد الروابط
String firebase(String path, [String? token]) {
  String url = '$baseFirebaseURL${Uri.encodeComponent(path)}?alt=media';
  if (token != null) url += '&token=$token';
  return url;
}

class DevelopmentalMilestonesFifteenMonth extends StatefulWidget {
  final String childId;
  final String childName;

  const DevelopmentalMilestonesFifteenMonth({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<DevelopmentalMilestonesFifteenMonth> createState() =>
      _DevelopmentalMilestonesFifteenMonthState();
}

class _DevelopmentalMilestonesFifteenMonthState
    extends State<DevelopmentalMilestonesFifteenMonth> {
  int expandedIndex = 0;
  int completedCount = 0;

  final int totalMilestones = 13;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // registry to reset all videos when collapsing a section
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
          .doc('15_months')
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
                              "Copies other children while playing, like taking toys out of a container when another child does",
                          imageUrl: firebase('images/15m_copies_children.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Shows you an object she likes",
                          imageUrl: firebase('images/15m_shows_object.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Claps when excited",
                          videoUrl:
                              firebase('videos/15m_claps_when_excited.mp4'),
                          thumbUrl: firebase(
                              'images/15m_claps_when_excited_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Hugs stuffed doll or other toy",
                          imageUrl: firebase('images/15m_hugs_toy.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Shows affection",
                          imageUrl: firebase('images/15m_shows_affection.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                      ],
                    ),

                    // LANGUAGE
                    _buildSection(
                      title: "Language & Communication",
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              "Tries to say one or two words besides “mama” or “dada”",
                          videoUrl: firebase('videos/15m_says_words.mp4'),
                          thumbUrl: firebase('images/15m_says_words_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Looks at familiar objects when named",
                          videoUrl: firebase('videos/15m_looks_at_object.mp4'),
                          thumbUrl:
                              firebase('images/15m_looks_at_object_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title:
                              "Follows directions with both a gesture and words",
                          videoUrl:
                              firebase('videos/15m_follows_directions.mp4'),
                          thumbUrl: firebase(
                              'images/15m_follows_directions_thumb.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Points to ask for something",
                          videoUrl: firebase('videos/15m_points_to_ask.mp4'),
                          thumbUrl:
                              firebase('images/15m_points_to_ask_thumb.jpg'),
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
                          title: "Uses things the right way (phone, cup...)",
                          imageUrl: firebase(
                              'images/15m_uses_things_right_way.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Stacks two objects",
                          videoUrl: firebase('videos/15m_stacks_blocks.mp4'),
                          thumbUrl:
                              firebase('images/15m_stacks_blocks_thumb.jpg'),
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
                          title: "Takes a few steps on her own",
                          imageUrl: firebase('images/15m_steps_on_own.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          stateRegistry: _milestoneStates,
                        ),
                        _MilestoneCard(
                          title: "Feeds herself using fingers",
                          videoUrl: firebase('videos/15m_feeds_self.mp4'),
                          thumbUrl:
                              firebase('images/15m_feeds_self_thumb.jpg'),
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

  // Progress card — unified style
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
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
          ],
        ),
      );

  // Section — unified with rotating arrow + video reset
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

// ---------------------------------------------------------------------------
// ⭐ MilestoneCard — unified like 18m/24m/30m/3y/4y/5y
// ---------------------------------------------------------------------------
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
        // show first frame
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
          .doc('15_months')
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
          .doc('15_months')
          .set({widget.title: value}, SetOptions(merge: true));
    } catch (_) {}
  }

  @override
  void dispose() {
    widget.stateRegistry.remove(this);
    _controller?.dispose();
    super.dispose();
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
            // Checkbox + title
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
                      color: Colors.black,
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

    // الفيديو غير جاهز بعد
    if (!initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // تشغيل الفيديو مع overlay
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: VideoPlayer(_controller!),
        ),

        // أول مرة تشغيل
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

        // بعد الإيقاف المؤقت
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

        // أثناء التشغيل → لمس الشاشة يوقف الفيديو
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
