import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/i18n.dart';

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
  final ScrollController _scrollController = ScrollController();

  /// 🔔 هذا هو الكنترولر الذي يخبر الكروت أي فيديو هو النشط الآن
  final ValueNotifier<String?> activeVideo = ValueNotifier<String?>(null);

  // مفاتيح الأقسام للسكرول
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
    surfaceTintColor: Colors.transparent,   // ← prevents turning pink
    scrolledUnderElevation: 0,               // ← prevents shadow color blending
    centerTitle: true,
    title: Text(
      t(context, "Developmental Milestones", "مراحل النمو والتطور"),
      style: const TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgressCard(progress),
                    const SizedBox(height: 20),

                    // SOCIAL
                    _buildSection(
                      title: t(context, "Social & Emotional", "الاجتماعي والعاطفي"),
                      index: 0,
                      milestones: [
                        _MilestoneCard(
                          title:
                              t(
                                context,
                                "Calms down within 10 minutes after you leave her",
                                "يهدأ خلال 10 دقائق بعد مغادرتك",
                              ),
                          imageUrl: firebase('images/3y_calms_down.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              t(
                                context,
                                "Notices other children and joins them to play",
                                "يلتفت للأطفال الآخرين وينضم إليهم للعب",
                              ),
                          videoUrl: firebase('videos/3y_notices_children.mp4'),
                          thumbUrl: firebase('images/3y_notices_children.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // SPEECH
                    _buildSection(
                      title: t(context, "Speech & Language", "الكلام واللغة"),
                      index: 1,
                      milestones: [
                        _MilestoneCard(
                          title:
                              t(
                                context,
                                "Talks with you in at least two back-and-forth exchanges",
                                "يتحدث معك في تبادلات متبادلة مرتين على الأقل",
                              ),
                          videoUrl: firebase('videos/3y_talks_with_you.mp4'),
                          thumbUrl: firebase('images/3y_talks_with_you.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              t(
                                context,
                                "Asks “who”, “what”, “where”, or “why” questions",
                                "يسأل أسئلة «من» أو «ماذا» أو «أين» أو «لماذا»",
                              ),
                          videoUrl: firebase('videos/3y_asks_questions.mp4'),
                          thumbUrl: firebase('images/3y_asks_questions.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title:
                              t(
                                context,
                                "Says what action is happening in a picture or book",
                                "يقول ما يحدث من فعل في صورة أو كتاب",
                              ),
                          videoUrl: firebase('videos/3y_says_action.mp4'),
                          thumbUrl: firebase('images/3y_says_action.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Says first name when asked", "يقول اسمه الأول عند سؤاله"),
                          videoUrl: firebase('videos/3y_says_first_name.mp4'),
                          thumbUrl: firebase('images/3y_says_first_name.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Talks well enough for others to understand", "يتحدث بوضوح كافٍ ليفهمه الآخرون"),
                          videoUrl: firebase('videos/3y_talks_clear.mp4'),
                          thumbUrl: firebase('images/3y_talks_clear.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // COGNITIVE
                    _buildSection(
                      title: t(context, "Cognitive Development", "التطور المعرفي"),
                      index: 2,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Draws a circle when you show her how", "يرسم دائرة عندما تريه كيف"),
                          videoUrl: firebase('videos/3y_draws_circle.mp4'),
                          thumbUrl: firebase('images/3y_draws_circle.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Avoids touching hot objects", "يتجنب لمس الأشياء الساخنة"),
                          videoUrl:
                              firebase('videos/3y_avoids_hot_objects.mp4'),
                          thumbUrl:
                              firebase('images/3y_avoids_hot_objects.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                      ],
                    ),

                    // MOVEMENT
                    _buildSection(
                      title: t(context, "Movement & Physical Development", "التطور الحركي والبدني"),
                      index: 3,
                      milestones: [
                        _MilestoneCard(
                          title: t(context, "Strings items together like beads", "يربط أشياء معًا مثل الخرز"),
                          imageUrl: firebase('images/3y_strings_items.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Puts on some clothes by herself", "يرتدي بعض الملابس بنفسه"),
                          imageUrl: firebase('images/3y_puts_clothes.jpg'),
                          onChecked: updateProgress,
                          childId: widget.childId,
                          notifier: activeVideo,
                        ),
                        _MilestoneCard(
                          title: t(context, "Uses a fork", "يستخدم الشوكة"),
                          imageUrl: firebase('images/3y_uses_fork.jpg'),
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
            
            Text(t(context, "Overall Progress", "التقدم العام"),
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18)),

      Text(
        t(
          context,
          "Only check milestones you're confident your child has achieved",
          "حدّد فقط المعالم التي أنت متأكد أن طفلك حققها",
        ),
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF6F6F6F),
          fontSize: 13,
        ),
      ),

                    
            const SizedBox(height: 6),
            Text(
              t(
                context,
                "$completedCount of $totalMilestones milestones complete",
                "$completedCount من أصل $totalMilestones مهارة مكتملة",
              ),
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF6F6F6F),
                fontSize: 13,
              ),
            ),

const SizedBox(height: 6),

               ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF9D5C7D)),
              ),
            ),
               // ←← أضفنا الجملة هنا
 


          ],
        ),
      );
Widget _buildGuidanceBox() {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF8FB), // وردي فاتح جدًا يناسب رفيق
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color(0xFF9D5C7D).withOpacity(0.3)),
    ),
    child: const Text(
      "Please check a milestone only if you are fully confident your child has achieved it.",
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        height: 1.4,
        color: Colors.black87,
      ),
    ),
  );
}

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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    _sectionKeys[index]!.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });

                // إيقاف أي فيديو شغال عند تغيير القسم
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

  bool initialized = false;
  bool loading = false;
  bool isPlaying = false;

  late final VoidCallback _notifierListener;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();

    // عندما فيديو آخر يصير active → بس نعمل pause (بدون reset)
    _notifierListener = () {
      if (widget.notifier.value != widget.title && isPlaying) {
        _controller?.pause();
        if (mounted) {
          setState(() => isPlaying = false);
        }
      }
    };
    widget.notifier.addListener(_notifierListener);
  }

  @override
  void dispose() {
    widget.notifier.removeListener(_notifierListener);
    _controller?.dispose();
    super.dispose();
  }
void _resetToThumbnail() {
  _controller?.pause();
  _controller?.dispose();
  _controller = null;

  setState(() {
    initialized = false;   // ← back to thumbnail
    isPlaying = false;
    loading = false;
  });
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

  Future<void> _initializeAndPlay() async {
    if (loading) return;

    setState(() => loading = true);

    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));

    try {
      await _controller!.initialize();
      if (!mounted) return;

     _controller!.addListener(() {
  if (!mounted) return;

  final v = _controller!.value;

  // 🎯 Video finished
  if (v.isInitialized &&
      !v.isPlaying &&
      v.position >= v.duration &&
      v.duration > Duration.zero) {
    _resetToThumbnail();
  }
});


      setState(() {
        initialized = true;
        loading = false;
        isPlaying = true;
      });

      widget.notifier.value = widget.title;
      _controller!.play();
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  /// تشغيل / إكمال / إعادة تشغيل
  Future<void> _togglePlayPause() async {
    if (_controller == null) {
      // أول مرة بعد الثمب
      await _initializeAndPlay();
      return;
    }

    final v = _controller!.value;

    if (!isPlaying) {
      // لو الفيديو في آخره → أعد من البداية
      if (v.position >= v.duration - const Duration(milliseconds: 200)) {
        await _controller!.seekTo(Duration.zero);
      }
      widget.notifier.value = widget.title;
      await _controller!.play();
      setState(() => isPlaying = true);
    } else {
      await _controller!.pause();
      setState(() => isPlaying = false);
    }
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

  Widget _buildMedia() {
    // 🖼 بدون فيديو → صورة فقط
    if (widget.videoUrl == null) {
      return Image.network(
        widget.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    // 🎞 قبل التهيئة → نعرض الثمب + زر تشغيل أو لودينغ
    if (!initialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            widget.thumbUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          if (loading)
            const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              ),
            )
          else
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 60,
                color: Colors.white,
              ),
              onPressed: _togglePlayPause,
            ),
        ],
      );
    }

    // 🎥 بعد التهيئة → نعرض الفيديو مع أوفرلاي للأيقونة
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: VideoPlayer(_controller!),
          ),

          // لو مو شغال → أظهر زر التشغيل فوق الفيديو (بدون reset)
          if (!isPlaying)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.black26,
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
