import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ استيراد كافة الصفحات لضمان عمل الـ Navigation
import 'ai_skin_analysis_page.dart';
import 'DevelopmentalMilestonesTwoMonth.dart';
import 'DevelopmentalMilestonesFourMonth.dart';
import 'DevelopmentalMilestonesSixMonth.dart';
import 'DevelopmentalMilestonesNineMonth.dart';
import 'DevelopmentalMilestonesOneYear.dart';
import 'DevelopmentalMilestonesFifteenMonth.dart';
import 'DevelopmentalMilestones18month.dart';
import 'DevelopmentalMilestones24month.dart';
import 'DevelopmentalMilestones30month.dart';
import 'DevelopmentalMilestones3year.dart';
import 'DevelopmentalMilestones4year.dart';
import 'DevelopmentalMilestones5year.dart';
import 'activity_library_page.dart';
import 'vaccinations_page.dart';
import 'widgets/child_qr_popup.dart';

class _UpcomingVaccine {
  final String key;
  final String name;
  final DateTime date;

  _UpcomingVaccine({required this.key, required this.name, required this.date});
}

class ChildDashboard extends StatefulWidget {
  final String childId;
  final String childName;
  final String? imageUrl;

  const ChildDashboard(
      {super.key,
      required this.childId,
      required this.childName,
      this.imageUrl});

  @override
  State<ChildDashboard> createState() => _ChildDashboardState();
}

class _ChildDashboardState extends State<ChildDashboard> {
  // --- Variables ---
  String? childAge;
  String? updatedImageUrl;
  bool _loading = true;
  final List<GlobalKey> _ageKeys = List.generate(12, (_) => GlobalKey());
  static const double _sectionGap = 24;

  DateTime? _birthDate;
  Map<String, dynamic> _takenVaccines = {};
  DateTime? _nextAppointment;
  List<_UpcomingVaccine> _dashboardVaccines = [];
  bool _loadingVaccines = true;

  final List<String> ages = [
    '2M',
    '4M',
    '6M',
    '9M',
    '1Y',
    '15M',
    '18M',
    '2Y',
    '30M',
    '3Y',
    '4Y',
    '5Y'
  ];
  int selectedIndex = 7;
  int viewIndex = 7;
  final ScrollController _scrollController = ScrollController();

  // ✅ جدول التطعيمات المعتمد
  final Map<String, int> vaccineScheduleMonth = {
    "BCG_0": 0,
    "HEPB_1": 0,
    "HEPB_2": 2,
    "DTAP_1": 2,
    "PCV_1": 2,
    "IPV_1": 2,
    "ROTA_1": 2,
    "PCV_2": 4,
    "IPV_2": 4,
    "ROTA_2": 4,
    "PCV_3": 6,
    "HEPB_3": 6,
    "IPV_3": 6,
    "MCV4_1": 9,
    "MEASLES_1": 9,
    "HIB_FINAL": 12,
    "PCV_FINAL": 12,
    "MMR_1": 12,
    "VARICELLA_1": 12,
    "MCV4_2": 12,
    "DTAP_4": 18,
    "MMR_2": 18,
    "VARICELLA_2": 18,
    "HEPA_1": 18,
    "HEPA_2": 24,
    "IPV_FINAL": 60,
  };

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  // -------------------------------------------------------------------------
  // ⚙️ Smart Dependency & Medical Logic 😈
  // -------------------------------------------------------------------------

  bool _isExpired(String key, int ageMonths) {
    if (key.contains("ROTA") && ageMonths > 8) return true;
    if (key == "BCG_0" && ageMonths >= 12) return true;
    return false;
  }

  bool _isDependencyMet(String key) {
    if (key.contains("_2")) {
      String previousKey = key.replaceAll("_2", "_1");
      return _takenVaccines.containsKey(previousKey);
    }
    if (key.contains("_3")) {
      String previousKey = key.replaceAll("_3", "_2");
      return _takenVaccines.containsKey(previousKey);
    }
    if (key.contains("_4")) {
      String previousKey = key.replaceAll("_4", "_3");
      return _takenVaccines.containsKey(previousKey);
    }
    if (key.contains("_FINAL") &&
        !key.contains("IPV") &&
        !key.contains("BCG")) {
      String base = key.split("_")[0];
      return _takenVaccines.containsKey("${base}_3");
    }
    return true;
  }

  void _calculateUpcomingVaccines() {
    if (_birthDate == null) return;
    List<_UpcomingVaccine> allPending = [];
    final now = DateTime.now();
    final ageMonths =
        (now.year - _birthDate!.year) * 12 + (now.month - _birthDate!.month);

    vaccineScheduleMonth.forEach((key, months) {
      if (!_takenVaccines.containsKey(key)) {
        if (_isExpired(key, ageMonths)) return;
        if (!_isDependencyMet(key)) return;

        final scheduledDate = DateTime(
            _birthDate!.year, _birthDate!.month + months, _birthDate!.day);
        allPending.add(_UpcomingVaccine(
            key: key, name: _getVaccineDisplayName(key), date: scheduledDate));
      }
    });

    allPending.sort((a, b) => a.date.compareTo(b.date));
    _dashboardVaccines = allPending.take(3).toList();

    final futureOnly = allPending
        .where((v) => !v.date.isBefore(DateTime(now.year, now.month, now.day)))
        .toList();
    _nextAppointment = futureOnly.isNotEmpty ? futureOnly.first.date : null;

    _loadingVaccines = false;
  }

  String _getVaccineDisplayName(String key) {
    switch (key) {
      case "BCG_0":
        return "BCG (Tuberculosis)";
      case "HEPB_1":
        return "Hepatitis B (Dose 1)";
      case "HEPB_2":
        return "Hepatitis B (Dose 2)";
      case "HEPB_3":
        return "Hepatitis B (Dose 3)";
      case "DTAP_1":
        return "DTaP (Dose 1)";
      case "DTAP_4":
        return "DTaP (Dose 4)";
      case "PCV_1":
        return "PCV (Dose 1)";
      case "PCV_2":
        return "PCV (Dose 2)";
      case "PCV_3":
        return "PCV (Dose 3)";
      case "PCV_FINAL":
        return "PCV (Final)";
      case "HIB_FINAL":
        return "Hib (Final)";
      case "IPV_1":
        return "IPV (Polio Dose 1)";
      case "IPV_2":
        return "IPV (Polio Dose 2)";
      case "IPV_3":
        return "IPV (Polio Dose 3)";
      case "IPV_FINAL":
        return "IPV (Polio Final)";
      case "ROTA_1":
        return "Rotavirus (Dose 1)";
      case "ROTA_2":
        return "Rotavirus (Dose 2)";
      case "MEASLES_1":
        return "Measles (Dose 1)";
      case "MMR_1":
        return "MMR (Dose 1)";
      case "MMR_2":
        return "MMR (Dose 2)";
      case "VARICELLA_1":
        return "Varicella (Dose 1)";
      case "VARICELLA_2":
        return "Varicella (Dose 2)";
      case "MCV4_1":
        return "Meningococcal (Dose 1)";
      case "MCV4_2":
        return "Meningococcal (Dose 2)";
      case "HEPA_1":
        return "Hepatitis A (Dose 1)";
      case "HEPA_2":
        return "Hepatitis A (Dose 2)";
      default:
        return key.replaceAll('_', ' ');
    }
  }

  Future<void> _loadChildData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final doc = await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _takenVaccines = data['takenVaccines'] != null
            ? Map<String, dynamic>.from(data['takenVaccines'])
            : {};
        if (data['birthDate'] is Timestamp) {
          _birthDate = (data['birthDate'] as Timestamp).toDate();
        } else if (data['birthDate'] is String) {
          _birthDate = DateTime.tryParse(data['birthDate']);
        }

        if (_birthDate != null) {
          final ageData = _calculateAge(_birthDate!);
          childAge = ageData["display"];
          selectedIndex = _getAgeIndex(ageData["totalMonths"]);
          viewIndex = selectedIndex;
          _calculateUpcomingVaccines();
        }
        updatedImageUrl = data['imageUrl'] ?? widget.imageUrl;
        _loading = false;
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingVaccines = false;
        });
      }
    }
    _scrollToIndex(selectedIndex);
  }

  int _getAgeIndex(int months) {
    if (months <= 2) return 0;
    if (months <= 4) return 1;
    if (months <= 6) return 2;
    if (months <= 9) return 3;
    if (months <= 12) return 4;
    if (months <= 15) return 5;
    if (months <= 18) return 6;
    if (months <= 24) return 7;
    if (months <= 30) return 8;
    if (months <= 36) return 9;
    if (months <= 48) return 10;
    return 11;
  }

  Map<String, dynamic> _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return {
      "totalMonths": (years * 12 + months),
      "display": years == 0 ? "$months months" : "$years years, $months months"
    };
  }

  void _scrollToIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(index * 45.0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut);
      }
    });
  }

  // -------------------------------------------------------------------------
  // 🎨 UI (Centered Button)
  // -------------------------------------------------------------------------

  Widget _vaccinationTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vaccination Timeline",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2)),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: Color(0xFF9D5C7D), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _nextAppointment != null
                      ? "Next Appointment: ${_nextAppointment!.day}-${_nextAppointment!.month}-${_nextAppointment!.year}"
                      : "Next Appointment: ---",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_loadingVaccines)
            const Center(
                child: CircularProgressIndicator(color: Color(0xFF9D5C7D)))
          else if (_dashboardVaccines.isEmpty)
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("No immediate vaccinations. All set! ✨"))
          else
            ..._dashboardVaccines.map((v) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Color(0xFF9D5C7D), size: 22),
                            const SizedBox(width: 12),
                            Text(v.name,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFDADADA)),
                          ),
                          child: const Text("Upcoming",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87)),
                        ),
                      ],
                    ),
                    const Divider(
                        height: 28, thickness: 1, color: Color(0xFFF1F1F1)),
                  ],
                )),
          const SizedBox(height: 10),
          // ✅ تم وضعه في المنتصف هنا
          Center(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VaccinationsPage(
                            childId: widget.childId,
                            childName: widget.childName,
                            showConfirmSection: false,
                            canConfirm: false)));
                _loadChildData();
              },
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // للحفاظ على توازن العناصر في المركز
                children: const [
                  Text("View Full Timeline",
                      style: TextStyle(
                          color: Color(0xFF9D5C7D),
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, color: Color(0xFF9D5C7D), size: 22),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(widget.childName,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black87)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF9D5C7D)),
              onPressed: () => Navigator.pop(context)),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: const Color(0xFFE0E0E0))),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF9D5C7D)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFFF4E9EF),
                              backgroundImage: (updatedImageUrl != null &&
                                      updatedImageUrl!.isNotEmpty)
                                  ? NetworkImage(updatedImageUrl!)
                                  : const AssetImage('lib/icons/child.png')
                                      as ImageProvider),
                          const SizedBox(width: 12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.childName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                Text(childAge ?? "Calculating...",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF6F6F6F))),
                              ]),
                        ]),
                        GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) => ChildQRPopup(
                                  childId: widget.childId,
                                  childName: widget.childName)),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.qr_code_2_outlined,
                              color: Color(0xFF9D5C7D),
                              size: 22,
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: _sectionGap),
                Container(
                  padding: const EdgeInsets.all(18),
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
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Health Journey",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 20),
                        Row(children: [
                          _arrowButton(Icons.arrow_back_ios_new_rounded, () {
                            if (viewIndex > 0) {
                              setState(() {
                                viewIndex--;
                                selectedIndex = viewIndex;
                              });
                              _scrollToIndex(viewIndex);
                            }
                          }),
                          Expanded(
                              child: Column(children: [
                            SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                child: Row(
                                    children: ages
                                        .asMap()
                                        .entries
                                        .map((e) => Container(
                                            key: _ageKeys[e.key],
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: e.key == selectedIndex
                                                    ? const Color(0xFFC9A2B8)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(e.value,
                                                style: TextStyle(
                                                    color:
                                                        e.key == selectedIndex
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF5E5E5E),
                                                    fontWeight:
                                                        FontWeight.w600))))
                                        .toList())),
                            const SizedBox(height: 14),
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor:
                                      (selectedIndex + 1) / ages.length,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF9D5C7D),
                                          Color(0xFFC9A2B8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                          _arrowButton(Icons.arrow_forward_ios_rounded, () {
                            if (viewIndex < ages.length - 1) {
                              setState(() {
                                viewIndex++;
                                selectedIndex = viewIndex;
                              });
                              _scrollToIndex(viewIndex);
                            }
                          }),
                        ]),
                      ]),
                ),
                const SizedBox(height: _sectionGap),
                _vaccinationTimelineCard(),
                const SizedBox(height: _sectionGap),
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
                        title: "Developmental Milestones",
                        subtitle: "Monitor growth and learning",
                        iconSize: sw * 0.075,
                        padding: sw * 0.035,
                        fontSizeTitle: sw * 0.035,
                        fontSizeSubtitle: sw * 0.030,
                        onTap: () => _navigateToMilestones()),
                    _DashboardCard(
                        iconPath: 'lib/icons/scan.svg',
                        title: "AI Skin Analysis",
                        subtitle: "Upload photos for insights",
                        iconSize: sw * 0.075,
                        padding: sw * 0.035,
                        fontSizeTitle: sw * 0.035,
                        fontSizeSubtitle: sw * 0.030,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AiSkinAnalysisPage(
                                    childId: widget.childId,
                                    childName: widget.childName)))),
                    _DashboardCard(
                        iconPath: 'lib/icons/stethoscope.svg',
                        title: "Medical Conditions",
                        subtitle: "Overview of conditions",
                        iconSize: sw * 0.075,
                        padding: sw * 0.035,
                        fontSizeTitle: sw * 0.035,
                        fontSizeSubtitle: sw * 0.030),
                    _DashboardCard(
                        iconPath: 'lib/icons/book.svg',
                        title: "Activity Library",
                        subtitle: "Curated learning content",
                        iconSize: sw * 0.075,
                        padding: sw * 0.035,
                        fontSizeTitle: sw * 0.035,
                        fontSizeSubtitle: sw * 0.030,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActivityLibraryPage(
                                    ageKey: ages[selectedIndex])))),
                  ],
                ),
              ]),
            ),
    );
  }

  void _navigateToMilestones() {
    final sel = ages[selectedIndex];
    Widget dest;
    switch (sel) {
      case '2M':
        dest = DevelopmentalMilestonesTwoMonth(
            childId: widget.childId, childName: widget.childName);
        break;
      case '4M':
        dest = DevelopmentalMilestonesFourMonth(
            childId: widget.childId, childName: widget.childName);
        break;
      case '6M':
        dest = DevelopmentalMilestonesSixMonth(
            childId: widget.childId, childName: widget.childName);
        break;
      case '9M':
        dest = DevelopmentalMilestonesNineMonth(
            childId: widget.childId, childName: widget.childName);
        break;
      case '1Y':
        dest = DevelopmentalMilestonesOneYear(
            childId: widget.childId, childName: widget.childName);
        break;
      case '15M':
        dest = DevelopmentalMilestonesFifteenMonth(
            childId: widget.childId, childName: widget.childName);
        break;
      case '18M':
        dest = DevelopmentalMilestones18month(
            childId: widget.childId, childName: widget.childName);
        break;
      case '2Y':
        dest = DevelopmentalMilestones24month(
            childId: widget.childId, childName: widget.childName);
        break;
      case '30M':
        dest = DevelopmentalMilestones30month(
            childId: widget.childId, childName: widget.childName);
        break;
      case '3Y':
        dest = DevelopmentalMilestones3year(
            childId: widget.childId, childName: widget.childName);
        break;
      case '4Y':
        dest = DevelopmentalMilestones4year(
            childId: widget.childId, childName: widget.childName);
        break;
      case '5Y':
        dest = DevelopmentalMilestones5year(
            childId: widget.childId, childName: widget.childName);
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => dest));
  }

  Widget _arrowButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: const Color(0xFF9D5C7D))));
  }
}

class _DashboardCard extends StatelessWidget {
  final String iconPath, title, subtitle;
  final double iconSize, padding, fontSizeTitle, fontSizeSubtitle;
  final VoidCallback? onTap;
  const _DashboardCard(
      {required this.iconPath,
      required this.title,
      required this.subtitle,
      required this.iconSize,
      required this.padding,
      required this.fontSizeTitle,
      required this.fontSizeSubtitle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding + 6),
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
            ]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(iconPath,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF9D5C7D), BlendMode.srcIn),
              width: iconSize,
              height: iconSize),
          const SizedBox(height: 12),
          Text(title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  color: const Color(0xFF9D5C7D),
                  fontSize: fontSizeTitle,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  height: 1.2)),
          const SizedBox(height: 6),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xFF6F6F6F),
                  fontSize: fontSizeSubtitle,
                  fontFamily: 'Inter',
                  height: 1.3)),
        ]),
      ),
    );
  }
}
