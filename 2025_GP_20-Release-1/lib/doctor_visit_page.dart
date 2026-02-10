import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'doctor_ocr_reports_page.dart';

class DoctorVisitPage extends StatefulWidget {
  final String childId;

  const DoctorVisitPage({
    super.key,
    required this.childId,
  });

  @override
  State<DoctorVisitPage> createState() => _DoctorVisitPageState();
}

class _DoctorVisitPageState extends State<DoctorVisitPage> {
  Map<String, dynamic>? _child;
  bool _loading = true;

  String? _imageUrl;
  String _childName = "Child";
  String _childAge = "Unknown";

  // optional: نحتفظ ب parentId إذا احتجتيه لاحقًا
  String? _parentId;

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  Future<void> _loadChild() async {
    try {
      // 1) نجيب كل الآباء
      final parentsSnap =
      await FirebaseFirestore.instance.collection('parents').get();

      // 2) ندور داخل كل parent عن childId
      for (final parent in parentsSnap.docs) {
        final childDoc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(parent.id)
            .collection('children')
            .doc(widget.childId)
            .get();

        if (childDoc.exists) {
          final data = childDoc.data() as Map<String, dynamic>;

          // name
          final name =
          (data['name'] ?? data['childName'] ?? "Child").toString();

          // image
          final img = (data['imageUrl'] ?? data['photoUrl'] ?? "").toString();
          final imageUrl = img.isNotEmpty ? img : null;

          // birthDate (Timestamp or String)
          DateTime? birthDate;
          final bd = data['birthDate'];
          if (bd is Timestamp) {
            birthDate = bd.toDate();
          } else if (bd is String) {
            birthDate = DateTime.tryParse(bd);
          }

          final ageText =
          birthDate != null ? _calculateAgePretty(birthDate) : "Unknown";

          if (!mounted) return;
          setState(() {
            _parentId = parent.id;
            _child = data;
            _childName = name;
            _childAge = ageText;
            _imageUrl = imageUrl;
            _loading = false;
          });

          return; // ✅ لقيناه
        }
      }

      // ❌ ما لقينا الطفل بأي parent
      if (!mounted) return;
      setState(() {
        _child = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _child = null;
        _loading = false;
      });
    }
  }

  String _calculateAgePretty(DateTime birthDate) {
    final now = DateTime.now();

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (months < 0) {
      years--;
      months += 12;
    }

    if (years <= 0) return "$months months";
    if (months == 0) return "$years years";
    return "$years years, $months months";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.075;
    final cardPadding = screenWidth * 0.035;
    final fontSizeTitle = screenWidth * 0.035;
    final fontSizeSubtitle = screenWidth * 0.030;

    return Scaffold(
      backgroundColor: Colors.white,

      // نفس هيدر ChildDashboard
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Patient Details",
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
          actions: const [SizedBox(width: 18)],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Color(0xFFE0E0E0)),
          ),
        ),
      ),

      body: _loading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF9D5C7D),
        ),
      )
          : (_child == null)
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Child not found",
              style: TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 10),
            Text(
              "Child ID: ${widget.childId}",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF6F6F6F),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          children: [
            // 🩷 Patient Summary Card (نفس ChildDashboard)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFF4E9EF),
                        backgroundImage: (_imageUrl != null &&
                            _imageUrl!.isNotEmpty)
                            ? NetworkImage(_imageUrl!)
                            : const AssetImage('lib/icons/child.png')
                        as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _childName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _childAge,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),



                ],
              ),
            ),

            const SizedBox(height: 35),

            // 📈 Growth Chart Placeholder (بدون شارت)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Growth Chart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF6F6F6F),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Growth chart will appear here later",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🟣 Grid cards الأربع
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
              children: [
                _DashboardCard(
                  iconPath: 'lib/icons/signpost.svg',
                  title: "Milestones",
                  subtitle: "Track development progress",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    // TODO: افتحي صفحة milestones للدكتور
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/scan.svg',
                  title: "AI Skin Analysis History",
                  subtitle: "View previous AI results",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    // TODO: افتحي صفحة history
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/stethoscope.svg',
                  title: "Medical Conditions",
                  subtitle: "Scan & extract conditions",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorOcrReportsPage(childId: widget.childId),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/syringe.png',
                  title: "Vaccinations",
                  subtitle: "Schedule & history",
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    // TODO: افتحي صفحة vaccinations
                  },
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Finish Visit (مقفّل حالياً)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Finish Visit",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final double iconSize;
  final double padding;
  final double fontSizeTitle;
  final double fontSizeSubtitle;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.iconSize,
    required this.padding,
    required this.fontSizeTitle,
    required this.fontSizeSubtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding + 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF9D5C7D),
                BlendMode.srcIn,
              ),
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF9D5C7D),
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6F6F6F),
                fontSize: fontSizeSubtitle,
                height: 1.3,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
