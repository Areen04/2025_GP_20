import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

import 'doctor_ocr_reports_page.dart';
import 'vaccinations_page.dart';
import 'ai_skin_history_page.dart';
import 'doctor_milestones_overview_page.dart';

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
  AppLocalizations get l10n => AppLocalizations.of(context);
  Map<String, dynamic>? _child;
  bool _loading = true;

  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  bool _savingMeasure = false;

  String? _imageUrl;
  String _childName = "Child";
  String _childAge = "Unknown";
  DateTime? _birthDate;

  // optional: parentId لو احتجتيه بالصفحات الثانية
  String? _parentId;

  // الجندر من بيانات الطفل (مو من measurements)
  // متوقع قيم: "male"/"female" أو "boy"/"girl" أو "M"/"F"
  String? _gender;

  CollectionReference<Map<String, dynamic>> get _growthCol =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .collection('growth_measurements');

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _childName = _childName.isEmpty ? l10n.childSummaryDefaultName : _childName;
    if (_birthDate != null) {
      _childAge = _calculateAgePretty(_birthDate!);
    } else if (_childAge.isEmpty || _childAge == "Unknown") {
      _childAge = l10n.aiSkinHistoryUnknown;
    }
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  // ----------------------------
  // Load child (name, image, birthDate, gender, parentId)
  // ----------------------------
  Future<void> _loadChild() async {
    try {
      final parentsSnap =
      await FirebaseFirestore.instance.collection('parents').get();

      for (final parent in parentsSnap.docs) {
        final childDoc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(parent.id)
            .collection('children')
            .doc(widget.childId)
            .get();

        if (childDoc.exists) {
          final data = childDoc.data() as Map<String, dynamic>;

          final name = (data['name'] ??
                  data['childName'] ??
                  l10n.childSummaryDefaultName)
              .toString();
          final img = (data['imageUrl'] ?? data['photoUrl'] ?? "").toString();
          final imageUrl = img.isNotEmpty ? img : null;

          DateTime? birthDate;
          final bd = data['birthDate'];
          if (bd is Timestamp) {
            birthDate = bd.toDate();
          } else if (bd is String) {
            birthDate = DateTime.tryParse(bd);
          }

          final ageText = birthDate != null
              ? _calculateAgePretty(birthDate)
              : l10n.aiSkinHistoryUnknown;

          final g = (data['gender'] ??
              data['sex'] ??
              data['childGender'] ??
              data['childSex'])
              ?.toString();

          if (!mounted) return;
          setState(() {
            _parentId = parent.id;
            _child = data;
            _childName = name;
            _childAge = ageText;
            _imageUrl = imageUrl;
            _birthDate = birthDate;
            _gender = g;
            _loading = false;
          });
          return;
        }
      }

      if (!mounted) return;
      setState(() {
        _child = null;
        _loading = false;
      });
    } catch (_) {
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

    if (years <= 0) return l10n.ageMonths(months);
    if (months == 0) return l10n.ageYears(years);
    return l10n.ageYearsMonths(years, months);
  }

  // ----------------------------
  // Save measurement (height+weight + ageMonths auto)
  // ----------------------------
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF9D5C7D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveMeasurement() async {
    final hTxt = _heightCtrl.text.trim();
    final wTxt = _weightCtrl.text.trim();

    final height = double.tryParse(hTxt);
    final weight = double.tryParse(wTxt);

    if (height == null || weight == null) {
      _showSnackBar(l10n.doctorVisitEnterValidHeightWeight, isError: true);
      return;
    }

    if (_birthDate == null) {
      _showSnackBar(l10n.doctorVisitBirthDateNotAvailable, isError: true);
      return;
    }

    setState(() => _savingMeasure = true);

    try {
      final now = DateTime.now();

      final ageMonths =
          (now.year - _birthDate!.year) * 12 + (now.month - _birthDate!.month);

      final childRef =
      FirebaseFirestore.instance.collection('children').doc(widget.childId);

      await childRef.collection('growth_measurements').add({
        "heightCm": height,
        "weightKg": weight,
        "ageMonths": ageMonths,
        "recordedAt": Timestamp.fromDate(now),
        "recordedBy": "doctor",
      });

      await childRef.set({
        "latestHeightCm": height,
        "latestWeightKg": weight,
        "latestMeasuredAt": Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      _heightCtrl.clear();
      _weightCtrl.clear();

      if (mounted) {
        _showSnackBar(l10n.doctorVisitSaved);
      }
    } catch (_) {
      if (mounted) {
        _showSnackBar(l10n.doctorVisitSaveFailed, isError: true);
      }
    } finally {
      if (mounted) setState(() => _savingMeasure = false);
    }
  }

  // ----------------------------
  // Gender helper
  // ----------------------------
  bool get _isGirl {
    final g = (_gender ?? "").toLowerCase().trim();
    return g == "female" || g == "girl" || g == "f";
  }

  // ----------------------------
  // Baselines (approx medians) Boys vs Girls
  // x = months, y = value
  // ----------------------------
  List<FlSpot> _baselineHeight() {
    // Height cm (approx median)
    if (_isGirl) {
      return const [
        FlSpot(0, 49.1),
        FlSpot(6, 65.7),
        FlSpot(12, 74.0),
        FlSpot(18, 80.7),
        FlSpot(24, 86.4),
        FlSpot(36, 95.1),
        FlSpot(48, 102.7),
        FlSpot(60, 108.4),
      ];
    }
    return const [
      FlSpot(0, 49.9),
      FlSpot(6, 67.6),
      FlSpot(12, 75.7),
      FlSpot(18, 82.3),
      FlSpot(24, 87.8),
      FlSpot(36, 96.1),
      FlSpot(48, 103.3),
      FlSpot(60, 109.4),
    ];
  }

  List<FlSpot> _baselineWeight() {
    // Weight kg (approx median)
    if (_isGirl) {
      return const [
        FlSpot(0, 3.2),
        FlSpot(6, 7.3),
        FlSpot(12, 8.9),
        FlSpot(18, 10.2),
        FlSpot(24, 11.5),
        FlSpot(36, 13.9),
        FlSpot(48, 16.1),
        FlSpot(60, 18.2),
      ];
    }
    return const [
      FlSpot(0, 3.3),
      FlSpot(6, 7.9),
      FlSpot(12, 9.6),
      FlSpot(18, 10.9),
      FlSpot(24, 12.2),
      FlSpot(36, 14.3),
      FlSpot(48, 16.3),
      FlSpot(60, 18.3),
    ];
  }

  // ----------------------------
  // UI Cards
  // ----------------------------

  Widget _patientSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                backgroundImage: (_imageUrl != null && _imageUrl!.isNotEmpty)
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
    );
  }

  Widget _growthChartsCard() {
    // نفس ديزاين كاردك: أبيض + بوردر رمادي + عنوان + سهم
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
            children: [
             Text(
                l10n.childDashboardGrowthChartTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 14),

          // ✅ تشارت الطول
          _singleChartBlock(
            title: l10n.childDashboardGrowthChartHeight,
            isHeight: true,
          ),

          const SizedBox(height: 14),

          // ✅ تشارت الوزن
          _singleChartBlock(
            title: l10n.childDashboardGrowthChartWeight,
            isHeight: false,
          ),
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

              // محاور ثابتة (منطقية):
              // months: 0..60
              // weight: 0..24
              // height: 40..120
              final minX = 0.0;
              final maxX = 60.0;
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
                    topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 6,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          // 0 6 12 ... 60
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
                        interval: isHeight ? 10 : 2, // height: 10cm steps, weight: 2kg
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
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
                      color: const Color(0xFF3B82F6),
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
          children: [
            _LegendDot(
                color: const Color(0xFF3B82F6),
                label: l10n.childDashboardGrowthChartNormal),
            const SizedBox(width: 26),
            _LegendDot(
                color: const Color(0xFFC9A2B8),
                label: l10n.childDashboardGrowthChartChild),
          ],
        ),
      ],
    );
  }

  Widget _latestMeasurementsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
          Text(
            l10n.doctorVisitLatestMeasurements,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.childDashboardGrowthChartHeight,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _heightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.doctorVisitEnterHeight,
                        hintStyle: const TextStyle(fontFamily: 'Inter'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF9D5C7D), width: 1.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.childDashboardGrowthChartWeight,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _weightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: l10n.doctorVisitEnterWeight,
                        hintStyle: const TextStyle(fontFamily: 'Inter'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFF9D5C7D), width: 1.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 160,
            child: ElevatedButton.icon(
              onPressed: _savingMeasure ? null : _saveMeasurement,
              icon: const Icon(Icons.check_rounded),
              label: Text(_savingMeasure
                  ? l10n.doctorVisitSaving
                  : l10n.doctorVisitConfirm),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D5C7D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(
                    fontFamily: 'Inter', fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------
  // Build
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.075;
    final cardPadding = screenWidth * 0.035;
    final fontSizeTitle = screenWidth * 0.035;
    final fontSizeSubtitle = screenWidth * 0.030;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            l10n.doctorVisitPatientDetails,
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
            child: Container(height: 1, color: Color(0xFFE0E0E0)),
          ),
        ),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF9D5C7D)),
      )
          : (_child == null)
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.doctorVisitChildNotFound,
                style: const TextStyle(fontFamily: 'Inter')),
            const SizedBox(height: 10),
            Text(
              l10n.doctorVisitChildId(widget.childId),
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
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            _patientSummaryCard(),
            const SizedBox(height: 24),
            _latestMeasurementsCard(),
            // ✅ Growth Charts (height + weight) تحت بعض


            const SizedBox(height: 24),

            // ✅ Latest Measurements تحتهم
            _growthChartsCard(),

            const SizedBox(height: 24),

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
                  title: l10n.doctorVisitMilestonesTitle,
                  subtitle: l10n.doctorVisitMilestonesSubtitle,
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    if (_parentId == null || _birthDate == null) {
                      _showSnackBar(l10n.doctorVisitMilestonesNotAvailable,
                          isError: true);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorMilestonesOverviewPage(
                          childId: widget.childId,
                          childName: _childName,
                          parentId: _parentId!,
                          birthDate: _birthDate!,
                        ),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/scan.svg',
                  title: l10n.doctorVisitAiSkinHistoryTitle,
                  subtitle: l10n.doctorVisitAiSkinHistorySubtitle,
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AiSkinHistoryPage(
                          childId: widget.childId,
                          childName: _childName,
                          parentId: _parentId,
                        ),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/stethoscope.svg',
                  title: l10n.doctorVisitMedicalConditionsTitle,
                  subtitle: l10n.doctorVisitMedicalConditionsSubtitle,
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DoctorOcrReportsPage(childId: widget.childId),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  iconPath: 'lib/icons/syringe.png',
                  title: l10n.vaccinationsTitle,
                  subtitle: l10n.doctorVisitVaccinationsSubtitle,
                  iconSize: iconSize,
                  padding: cardPadding,
                  fontSizeTitle: fontSizeTitle,
                  fontSizeSubtitle: fontSizeSubtitle,
                  iconData: Icons.vaccines_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VaccinationsPage(
                          childId: widget.childId,
                          childName: _childName,
                          parentId: _parentId,
                          canConfirm: true,
                          showConfirmSection: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),


          ],
        ),
      ),
    );
  }
}

// ----------------------------
// Small UI Widgets
// ----------------------------
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
          decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
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

class _DashboardCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final double iconSize;
  final double padding;
  final double fontSizeTitle;
  final double fontSizeSubtitle;
  final VoidCallback? onTap;
  final IconData? iconData;

  const _DashboardCard({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.iconSize,
    required this.padding,
    required this.fontSizeTitle,
    required this.fontSizeSubtitle,
    this.onTap,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = iconData != null
        ? Icon(iconData, size: iconSize, color: const Color(0xFF9D5C7D))
        : (() {
      final isSvg = iconPath.toLowerCase().endsWith('.svg');
      final double iconSizeFinal = isSvg ? iconSize : iconSize * 2.0;
      return isSvg
          ? SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(
          Color(0xFF9D5C7D),
          BlendMode.srcIn,
        ),
        width: iconSizeFinal,
        height: iconSizeFinal,
      )
          : Image.asset(
        iconPath,
        width: iconSizeFinal,
        height: iconSizeFinal,
        fit: BoxFit.contain,
      );
    })();

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
            iconWidget,
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
