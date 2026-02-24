import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

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
import 'parent_medical_reports_page.dart';

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

  const ChildDashboard({
    super.key,
    required this.childId,
    required this.childName,
    this.imageUrl,
  });

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

  // ✅ نخزن جندر الطفل من بيانات الحساب (بدون ما نضيفه بالمشرمنتس)
  String? _childGender; // "male" / "female" أو "M"/"F" حسب بياناتك

  // ✅ مهم: هذا هو نفس مسار الدكتور (يفترض انه يحفظ هنا)
  CollectionReference<Map<String, dynamic>> get _growthCol =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .collection('growth_measurements');

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
  int minAllowedIndex = 7;
  final ScrollController _scrollController = ScrollController();

  // ✅ جدول التطعيمات المعتمد (متوافق مع صفحة التطعيمات)
  final Map<String, int> vaccineScheduleMonth = {
    "BCG_0": 0,
    "HEPB_BIRTH": 0,
    "DTAP_1": 2,
    "HIB_1": 2,
    "HEPB_1": 2,
    "PCV_1": 2,
    "IPV_1": 2,
    "ROTA_1": 2,
    "DTAP_2": 4,
    "HIB_2": 4,
    "HEPB_2": 4,
    "PCV_2": 4,
    "IPV_2": 4,
    "ROTA_2": 4,
    "DTAP_3": 6,
    "HIB_3": 6,
    "HEPB_3": 6,
    "PCV_3": 6,
    "IPV_3": 6,
    "OPV_1": 6,
    "MCV4_1": 9,
    "MEASLES_1": 9,
    "PCV_FINAL": 12,
    "MMR_1": 12,
    "VARICELLA_1": 12,
    "MCV4_2": 12,
    "OPV_2": 12,
    "DTAP_4": 18,
    "MMR_2": 18,
    "VARICELLA_2": 18,
    "HEPA_1": 18,
    "OPV_3": 18,
    "HIB_FINAL": 18,
    "HEPA_2": 24,
    "DTAP_5": 60,
    "OPV_4": 60,
    "MMR_SCHOOL": 60,
    "VARICELLA_SCHOOL": 60,
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

  bool _isTaken(String key) {
    if (_takenVaccines.containsKey(key)) return true;
    if (key == "HEPB_BIRTH" &&
        _takenVaccines["HEPB_1"] is Map &&
        _birthDate != null) {
      final takenOnRaw =
      (_takenVaccines["HEPB_1"] as Map)['takenOn']?.toString();
      final takenOn = takenOnRaw != null ? DateTime.tryParse(takenOnRaw) : null;
      if (takenOn != null) {
        final days = takenOn.difference(_birthDate!).inDays.abs();
        if (days <= 30) return true;
      }
    }
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
    if (key.contains("_5")) {
      String previousKey = key.replaceAll("_5", "_4");
      return _takenVaccines.containsKey(previousKey);
    }
    if (key.contains("_FINAL") && !key.contains("IPV") && !key.contains("BCG")) {
      String base = key.split("_")[0];
      return _takenVaccines.containsKey("${base}_3");
    }
    if (key.endsWith("_SCHOOL")) {
      final base = key.split("_")[0];
      return _takenVaccines.containsKey("${base}_2");
    }
    return true;
  }

  bool _isSectionComplete(int sectionMonth, int ageMonths) {
    final keys = vaccineScheduleMonth.entries
        .where((e) => e.value == sectionMonth)
        .map((e) => e.key);

    for (final key in keys) {
      if (_isTaken(key)) continue;
      if (_isExpired(key, ageMonths)) continue;
      return false;
    }
    return true;
  }

  int? _getNextSectionMonth(int ageMonths) {
    final sectionMonths = vaccineScheduleMonth.values.toSet().toList()..sort();
    for (final month in sectionMonths) {
      if (!_isSectionComplete(month, ageMonths)) return month;
    }
    return null;
  }

  void _calculateUpcomingVaccines() {
    if (_birthDate == null) return;
    List<_UpcomingVaccine> allPending = [];
    final now = DateTime.now();
    final ageMonths =
        (now.year - _birthDate!.year) * 12 + (now.month - _birthDate!.month);

    vaccineScheduleMonth.forEach((key, months) {
      if (!_isTaken(key)) {
        if (_isExpired(key, ageMonths)) return;
        if (!_isDependencyMet(key)) return;

        final scheduledDate = DateTime(
          _birthDate!.year,
          _birthDate!.month + months,
          _birthDate!.day,
        );
        allPending.add(_UpcomingVaccine(
          key: key,
          name: _getVaccineDisplayName(key),
          date: scheduledDate,
        ));
      }
    });

    allPending.sort((a, b) => a.date.compareTo(b.date));
    _dashboardVaccines = allPending.take(3).toList();

    final nextSectionMonth = _getNextSectionMonth(ageMonths);
    if (nextSectionMonth == null) {
      _nextAppointment = null;
    } else {
      DateTime? sectionEarliest;
      vaccineScheduleMonth.forEach((key, month) {
        if (month != nextSectionMonth) return;
        if (_isTaken(key)) return;
        if (_isExpired(key, ageMonths)) return;

        final scheduledDate = DateTime(
          _birthDate!.year,
          _birthDate!.month + month,
          _birthDate!.day,
        );
        if (sectionEarliest == null || scheduledDate.isBefore(sectionEarliest!)) {
          sectionEarliest = scheduledDate;
        }
      });
      _nextAppointment = sectionEarliest ??
          DateTime(_birthDate!.year, _birthDate!.month + nextSectionMonth, _birthDate!.day);
    }

    _loadingVaccines = false;
  }

  String _getVaccineDisplayName(String key) {
    switch (key) {
      case "BCG_0":
        return "BCG (Tuberculosis)";
      case "HEPB_BIRTH":
        return "Hepatitis B (Birth Dose)";
      case "HEPB_1":
        return "Hepatitis B (Dose 1)";
      case "HEPB_2":
        return "Hepatitis B (Dose 2)";
      case "HEPB_3":
        return "Hepatitis B (Dose 3)";
      case "DTAP_1":
        return "DTaP (Dose 1)";
      case "DTAP_2":
        return "DTaP (Dose 2)";
      case "DTAP_3":
        return "DTaP (Dose 3)";
      case "DTAP_4":
        return "DTaP (Dose 4)";
      case "DTAP_5":
        return "DTaP (Dose 5)";
      case "PCV_1":
        return "PCV (Dose 1)";
      case "PCV_2":
        return "PCV (Dose 2)";
      case "PCV_3":
        return "PCV (Dose 3)";
      case "PCV_FINAL":
        return "PCV (Final)";
      case "HIB_1":
        return "Hib (Dose 1)";
      case "HIB_2":
        return "Hib (Dose 2)";
      case "HIB_3":
        return "Hib (Dose 3)";
      case "HIB_FINAL":
        return "Hib (Final)";
      case "IPV_1":
        return "IPV (Polio Dose 1)";
      case "IPV_2":
        return "IPV (Polio Dose 2)";
      case "IPV_3":
        return "IPV (Polio Dose 3)";
      case "OPV_1":
        return "OPV (Dose 1)";
      case "OPV_2":
        return "OPV (Dose 2)";
      case "OPV_3":
        return "OPV (Dose 3)";
      case "OPV_4":
        return "OPV (Dose 4)";
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
      case "MMR_SCHOOL":
        return "MMR (School Age)";
      case "VARICELLA_1":
        return "Varicella (Dose 1)";
      case "VARICELLA_2":
        return "Varicella (Dose 2)";
      case "VARICELLA_SCHOOL":
        return "Varicella (School Age)";
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

        // ✅ جندر الطفل من حسابه (بدون ما نضيفه بالمشرمنتس)
        final g = (data['gender'] ?? data['childGender'] ?? "").toString().trim();
        _childGender = g.isEmpty ? null : g;

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
          minAllowedIndex = selectedIndex;
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
        _scrollController.animateTo(
          index * 45.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // -------------------------------------------------------------------------
  // ✅ Growth Charts (عرض فقط - بدون أي إدخال)
  // -------------------------------------------------------------------------

  bool get _isFemale {
    final g = (_childGender ?? "").toLowerCase();
    return g == "female" || g == "f" || g.contains("girl") || g.contains("أنث") || g.contains("بنت");
  }

  List<FlSpot> _baselineHeight() {
    // خط طبيعي "منطقي" (تقريب متوسط) — مو بيانات طبية رسمية
    // بنات أقل شوي عن عيال
    if (_isFemale) {
      return const [
        FlSpot(0, 49),
        FlSpot(2, 56),
        FlSpot(4, 61),
        FlSpot(6, 65),
        FlSpot(9, 70),
        FlSpot(12, 74),
        FlSpot(18, 80),
        FlSpot(24, 86),
        FlSpot(36, 95),
        FlSpot(48, 102),
        FlSpot(60, 108),
      ];
    }
    return const [
      FlSpot(0, 50),
      FlSpot(2, 57),
      FlSpot(4, 62),
      FlSpot(6, 66),
      FlSpot(9, 71),
      FlSpot(12, 75),
      FlSpot(18, 81),
      FlSpot(24, 87),
      FlSpot(36, 96),
      FlSpot(48, 103),
      FlSpot(60, 109),
    ];
  }

  List<FlSpot> _baselineWeight() {
    // خط طبيعي "منطقي" (تقريب متوسط) — مو بيانات طبية رسمية
    if (_isFemale) {
      return const [
        FlSpot(0, 3.2),
        FlSpot(2, 5.1),
        FlSpot(4, 6.2),
        FlSpot(6, 7.2),
        FlSpot(9, 8.2),
        FlSpot(12, 8.9),
        FlSpot(18, 10.6),
        FlSpot(24, 11.8),
        FlSpot(36, 13.9),
        FlSpot(48, 15.8),
        FlSpot(60, 17.6),
      ];
    }
    return const [
      FlSpot(0, 3.4),
      FlSpot(2, 5.6),
      FlSpot(4, 6.8),
      FlSpot(6, 7.7),
      FlSpot(9, 8.8),
      FlSpot(12, 9.6),
      FlSpot(18, 11.2),
      FlSpot(24, 12.4),
      FlSpot(36, 14.5),
      FlSpot(48, 16.5),
      FlSpot(60, 18.4),
    ];
  }

  Widget _growthChartsCard() {
    // نفس ديزاين كاردك: أبيض + بوردر رمادي + عنوان
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
            ],
          ),
          const SizedBox(height: 14),

          // ✅ تشارت الطول
          _singleChartBlock(title: "Height (cm)", isHeight: true),

          const SizedBox(height: 14),

          // ✅ تشارت الوزن
          _singleChartBlock(title: "Weight (kg)", isHeight: false),
        ],
      ),
    );
  }

  Widget _singleChartBlock({
    required String title,
    required bool isHeight,
  }) {
    final baseline = isHeight ? _baselineHeight() : _baselineWeight();

    final stream = _growthCol
        .orderBy("ageMonths", descending: false)
        .limit(80)
        .snapshots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F5F6),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: stream,
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];

              final childSpots = <FlSpot>[];
              for (final d in docs) {
                final data = d.data();
                final x = (data["ageMonths"] as num?)?.toDouble();
                final y = (isHeight
                    ? (data["heightCm"] as num?)
                    : (data["weightKg"] as num?))
                    ?.toDouble();

                if (x != null && y != null) {
                  childSpots.add(FlSpot(x, y));
                }
              }

              // ✅ محاور ثابتة وواضحة
              final minX = 0.0;
              final maxX = 60.0;

              // الوزن 0..24 | الطول 40..120
              final minY = isHeight ? 40.0 : 0.0;
              final maxY = isHeight ? 120.0 : 24.0;

              return LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.35),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.25),
                      strokeWidth: 1,
                    ),
                  ),

                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xFF9D5C7D),
                      width: 1.2,
                    ),
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 6,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          if (value % 6 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: isHeight ? 10 : 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            isHeight ? value.toInt().toString() : value.toStringAsFixed(0),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Color(0xFF6F6F6F),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  lineBarsData: [
                    // Normal line
                    LineChartBarData(
                      spots: baseline,
                      isCurved: true,
                      color: const Color(0xFF9D5C7D),
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),

                    // Child line
                    if (childSpots.isNotEmpty)
                      LineChartBarData(
                        spots: childSpots,
                        isCurved: true,
                        color: const Color(0xFFC9A2B8),
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _LegendDot(color: Color(0xFF9D5C7D), label: "Normal Growth"),
            SizedBox(width: 26),
            _LegendDot(color: Color(0xFFC9A2B8), label: "Child Growth"),
          ],
        ),
      ],
    );
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
          const Text(
            "Vaccination Timeline",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
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
              child: CircularProgressIndicator(color: Color(0xFF9D5C7D)),
            )
          else if (_dashboardVaccines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("No immediate vaccinations. All set! ✨"),
            )
          else
            ..._dashboardVaccines.map(
                  (v) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: Color(0xFF9D5C7D), size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                v.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFDADADA)),
                        ),
                        child: const Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                      height: 28, thickness: 1, color: Color(0xFFF1F1F1)),
                ],
              ),
            ),
          const SizedBox(height: 10),
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
                      canConfirm: false,
                    ),
                  ),
                );
                _loadChildData();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "View Full Timeline",
                    style: TextStyle(
                      color: Color(0xFF9D5C7D),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
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
          title: Text(
            widget.childName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF9D5C7D),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF9D5C7D)),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            // ✅ نفس كارد السمري حقك (ولا لمسته)
            Container(
              padding: const EdgeInsets.all(16),
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
                        backgroundImage: (updatedImageUrl != null &&
                            updatedImageUrl!.isNotEmpty)
                            ? NetworkImage(updatedImageUrl!)
                            : const AssetImage('lib/icons/child.png')
                        as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.childName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            childAge ?? "Calculating...",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6F6F6F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => ChildQRPopup(
                        childId: widget.childId,
                        childName: widget.childName,
                      ),
                    ),
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
                ],
              ),
            ),

            // ✅ هنا أضفنا الشارتين فقط (بدون ما نغير أي شيء ثاني)


            const SizedBox(height: _sectionGap),

            // ✅ بقية الصفحة نفس كودك حرفيًا
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
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Health Journey",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _arrowButton(
                        Icons.arrow_back_ios_new_rounded,
                        viewIndex > minAllowedIndex
                            ? () {
                          setState(() {
                            viewIndex--;
                            selectedIndex = viewIndex;
                          });
                          _scrollToIndex(viewIndex);
                        }
                            : null,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              child: Row(
                                children: ages
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => Container(
                                    key: _ageKeys[e.key],
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: e.key == selectedIndex
                                          ? const Color(0xFFC9A2B8)
                                          : Colors.transparent,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      e.value,
                                      style: TextStyle(
                                        color: e.key == selectedIndex
                                            ? Colors.white
                                            : const Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius:
                                    BorderRadius.circular(8),
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
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _arrowButton(Icons.arrow_forward_ios_rounded, () {
                        if (viewIndex < ages.length - 1) {
                          setState(() {
                            viewIndex++;
                            selectedIndex = viewIndex;
                          });
                          _scrollToIndex(viewIndex);
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: _sectionGap),
            _growthChartsCard(),
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
                  onTap: () => _navigateToMilestones(),
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/scan.svg',
                  title: "AI Skin Analysis",
                  subtitle: "Upload photos for insights",
                  iconSize: sw * 0.075,
                  padding: sw * 0.035,
                  fontSizeTitle: sw * 0.035,
                  fontSizeSubtitle: sw * 0.030,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AiSkinAnalysisPage(
                          childId: widget.childId,
                          childName: widget.childName,
                        ),
                      ),
                    );
                    if (!mounted) return;
                    _loadChildData();
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/stethoscope.svg',
                  title: "Medical Conditions",
                  subtitle: "Overview of conditions",
                  iconSize: sw * 0.075,
                  padding: sw * 0.035,
                  fontSizeTitle: sw * 0.035,
                  fontSizeSubtitle: sw * 0.030,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParentMedicalReportsPage(
                          childId: widget.childId,
                          childName: widget.childName,
                        ),
                      ),
                    );
                    if (!mounted) return;
                    _loadChildData();
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/book.svg',
                  title: "Activity Library",
                  subtitle: "Curated learning content",
                  iconSize: sw * 0.075,
                  padding: sw * 0.035,
                  fontSizeTitle: sw * 0.035,
                  fontSizeSubtitle: sw * 0.030,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityLibraryPage(
                          ageKey: ages[selectedIndex],
                        ),
                      ),
                    );
                    if (!mounted) return;
                    _loadChildData();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToMilestones() async {
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) => dest));
    if (!mounted) return;
    _loadChildData();
  }

  Widget _arrowButton(IconData icon, VoidCallback? onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF9D5C7D)),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String iconPath, title, subtitle;
  final double iconSize, padding, fontSizeTitle, fontSizeSubtitle;
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
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter:
              const ColorFilter.mode(Color(0xFF9D5C7D), BlendMode.srcIn),
              width: iconSize,
              height: iconSize,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
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
                fontFamily: 'Inter',
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}