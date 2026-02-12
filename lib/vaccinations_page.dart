import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

enum VaccineStatus { upcoming, completed, overdue, hidden }

class VaccinationsPage extends StatefulWidget {
  final String childId;
  final String childName;
  final String? parentId;
  final bool canConfirm;
  final bool showConfirmSection;

  const VaccinationsPage({
    super.key,
    required this.childId,
    required this.childName,
    this.parentId,
    this.canConfirm = false,
    this.showConfirmSection = true,
  });

  @override
  State<VaccinationsPage> createState() => _VaccinationsPageState();
}

class _VaccinationsPageState extends State<VaccinationsPage> {
  DateTime? _birthDate;
  Map<String, dynamic> _takenVaccines = {};
  bool _isLoading = true;
  String? _resolvedParentId;
  String? _expandedSectionTitle;
  bool _didInitExpanded = false;

  // 1️⃣ جدول اللقاحات الشامل (MOH Saudi Schedule)
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

  final Map<String, int> vaccineDeadlines = {
    "BCG_0": 12,
    "HIB_FINAL": 60,
    "PCV_FINAL": 60,
    "ROTA_1": 4,
    "ROTA_2": 8,
  };

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  // --------------------------------------------------------------------------
  // 2) DATA HANDLING (Firestore)
  // --------------------------------------------------------------------------
  Future<void> _loadChildData() async {
    try {
      String? uid = _resolveOwnerId();

      DocumentSnapshot<Map<String, dynamic>>? doc;
      if (uid != null) {
        doc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(uid)
            .collection('children')
            .doc(widget.childId)
            .get();
      }

      if (doc == null || !doc.exists) {
        final foundParentId = await _findParentIdByChildId();
        if (foundParentId != null) {
          _resolvedParentId = foundParentId;
          uid = foundParentId;
          doc = await FirebaseFirestore.instance
              .collection('parents')
              .doc(uid)
              .collection('children')
              .doc(widget.childId)
              .get();
        }
      }

      if (doc != null && doc.exists) {
        final data = doc.data()!;
        _takenVaccines = data['takenVaccines'] != null
            ? Map<String, dynamic>.from(data['takenVaccines'])
            : {};
        if (data['birthDate'] is Timestamp) {
          _birthDate = (data['birthDate'] as Timestamp).toDate();
        } else if (data['birthDate'] is String) {
          _birthDate = DateTime.tryParse(data['birthDate']);
        }
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _resolveOwnerId() {
    return widget.parentId ??
        _resolvedParentId ??
        FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String?> _findParentIdByChildId() async {
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
          return parent.id;
        }
      }
    } catch (e) {
      debugPrint("Error finding parentId: $e");
    }
    return null;
  }

  Future<void> _confirmVaccine(String key) async {
    final uid = _resolveOwnerId();
    if (uid == null) return;

    final nowIso = DateTime.now().toIso8601String();
    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(uid)
          .collection('children')
          .doc(widget.childId)
          .set({
        'takenVaccines': {
          key: {'takenOn': nowIso}
        }
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() {
        _takenVaccines[key] = {'takenOn': nowIso};
      });
    } catch (e) {
      debugPrint("Error confirming vaccine: $e");
    }
  }

  // --------------------------------------------------------------------------
  // 3) LOGIC HELPERS (تمت إضافة المنطق الذكي هنا)
  // --------------------------------------------------------------------------
  int getAgeInMonths(DateTime birthDate) {
    final now = DateTime.now();
    int months =
        (now.year - birthDate.year) * 12 + (now.month - birthDate.month);
    if (now.day < birthDate.day) months--;
    return months;
  }

  bool isExpired(String key) {
    if (_birthDate == null || _takenVaccines.containsKey(key)) return false;
    final deadlineMonths = vaccineDeadlines[key];
    if (deadlineMonths == null) return false;
    return getAgeInMonths(_birthDate!) >= deadlineMonths;
  }

  bool isLate(String key, DateTime? scheduledDate) {
    if (_takenVaccines[key] == null || scheduledDate == null) return false;
    final takenOn = DateTime.parse(_takenVaccines[key]['takenOn']);
    return takenOn.isAfter(scheduledDate.add(const Duration(days: 28)));
  }

  // ⭐ تاريخ بداية السكشن (الخطوة 1 المضافة)
  DateTime getSectionStartDate(int sectionMonth) {
    if (_birthDate == null) return DateTime.now();
    if (sectionMonth == 0) return _birthDate!;
    return DateTime(
        _birthDate!.year, _birthDate!.month + sectionMonth, _birthDate!.day);
  }

  bool shouldShowInSection(
      {required bool isCurrent,
      required VaccineStatus status,
      required bool isLate,
      required bool expired}) {
    if (expired) return false;
    if (isCurrent) return status != VaccineStatus.hidden;
    return status == VaccineStatus.completed && !isLate;
  }

  int getOpenSectionMonth() {
    if (_birthDate == null) return 0;
    final age = getAgeInMonths(_birthDate!);
    final sectionMonths = {
      0,
      2,
      4,
      6,
      9,
      12,
      18,
      24,
      60,
    }.toList()
      ..sort();

    for (int i = sectionMonths.length - 1; i >= 0; i--) {
      if (age >= sectionMonths[i]) return sectionMonths[i];
    }
    return sectionMonths.first;
  }

  String _sectionTitleForMonth(int month) {
    switch (month) {
      case 0:
        return "At Birth";
      case 2:
        return "2 Months";
      case 4:
        return "4 Months";
      case 6:
        return "6 Months";
      case 9:
        return "9 Months";
      case 12:
        return "12 Months";
      case 18:
        return "18 Months";
      case 24:
        return "24 Months";
      case 60:
        return "School Age";
      default:
        return "At Birth";
    }
  }

  // --------------------------------------------------------------------------
  // 4) VACCINE STATUS ENGINE (النسخة الذكية المحدثة - الخطوة 2)
  // --------------------------------------------------------------------------
  VaccineStatus getVaccineStatus(String key,
      {DateTime? earliestDate, required int sectionMonth}) {
    if (_takenVaccines[key] != null) return VaccineStatus.completed;
    if (earliestDate == null) return VaccineStatus.hidden;
    if (isExpired(key)) return VaccineStatus.hidden;

    final now = DateTime.now();

    // ⭐ تاريخ بداية السكشن الفعلي
    final sectionStart = getSectionStartDate(sectionMonth);

    // ⭐ تاريخ العرض (الأذكى): يعرض الجرعة بناءً على أيهما أبعد (الموعد الطبي أو فتح السكشن)
    final displayDate =
        earliestDate.isAfter(sectionStart) ? earliestDate : sectionStart;

    if (now.isBefore(displayDate)) {
      return VaccineStatus.hidden;
    }

    if (now.isBefore(displayDate.add(const Duration(days: 28)))) {
      return VaccineStatus.upcoming;
    }

    return VaccineStatus.overdue;
  }

  // --------------------------------------------------------------------------
  // 5) DATE CALCULATIONS
  // --------------------------------------------------------------------------
  DateTime addWeeks(DateTime date, int weeks) =>
      date.add(Duration(days: weeks * 7));

  DateTime? getDTaP1Earliest() =>
      _birthDate == null ? null : addWeeks(_birthDate!, 6);
  DateTime? getDTaP2Earliest() => _takenVaccines["DTAP_1"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["DTAP_1"]["takenOn"]), 4);
  DateTime? getDTaP3Earliest() => _takenVaccines["DTAP_2"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["DTAP_2"]["takenOn"]), 4);
  DateTime? getDTaP4Earliest() => _takenVaccines["DTAP_3"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["DTAP_3"]["takenOn"]), 24);
  DateTime? getDTaP5Earliest() => _takenVaccines["DTAP_4"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["DTAP_4"]["takenOn"]), 24);

  DateTime? getHib1Earliest() =>
      _birthDate == null ? null : addWeeks(_birthDate!, 6);
  DateTime? getHib2Earliest() => _takenVaccines["HIB_1"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["HIB_1"]["takenOn"]), 4);
  DateTime? getHib3Earliest() => _takenVaccines["HIB_2"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["HIB_2"]["takenOn"]), 4);

  DateTime? getHibFinalEarliest() {
    if (_birthDate == null) return null;
    final age = getAgeInMonths(_birthDate!);
    if (age < 12 || age > 59) return null;
    if (!(_takenVaccines.containsKey("HIB_1") &&
        _takenVaccines.containsKey("HIB_2") &&
        _takenVaccines.containsKey("HIB_3"))) {
      return null;
    }
    final hib3Date = DateTime.parse(_takenVaccines["HIB_3"]["takenOn"]);
    return addWeeks(hib3Date, 8);
  }

  DateTime? getHepB1() => _birthDate == null ? null : addWeeks(_birthDate!, 8);
  DateTime? getHepB2() => _takenVaccines["HEPB_1"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["HEPB_1"]["takenOn"]), 8);
  DateTime? getHepB3() => _takenVaccines["HEPB_2"] == null
      ? null
      : addWeeks(DateTime.parse(_takenVaccines["HEPB_2"]["takenOn"]), 8);

  DateTime? _getScheduledDate(String key) {
    if (_birthDate == null) return null;
    switch (key) {
      case "BCG_0":
      case "HEPB_BIRTH":
        return _birthDate;
      case "HEPB_1":
        return getHepB1();
      case "HEPB_2":
        return getHepB2();
      case "HEPB_3":
        return getHepB3();
      case "DTAP_1":
        return getDTaP1Earliest();
      case "DTAP_2":
        return getDTaP2Earliest();
      case "DTAP_3":
        return getDTaP3Earliest();
      case "DTAP_4":
        return getDTaP4Earliest();
      case "DTAP_5":
        return getDTaP5Earliest();
      case "HIB_1":
        return getHib1Earliest();
      case "HIB_2":
        return getHib2Earliest();
      case "HIB_3":
        return getHib3Earliest();
      case "HIB_FINAL":
        return getHibFinalEarliest();
      case "PCV_1":
        return addWeeks(_birthDate!, 6);
      case "PCV_2":
        return _takenVaccines["PCV_1"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["PCV_1"]["takenOn"]), 4);
      case "PCV_3":
        return _takenVaccines["PCV_2"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["PCV_2"]["takenOn"]), 4);
      case "IPV_1":
        return addWeeks(_birthDate!, 6);
      case "IPV_2":
        return _takenVaccines["IPV_1"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["IPV_1"]["takenOn"]), 4);
      case "IPV_3":
        return _takenVaccines["IPV_2"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["IPV_2"]["takenOn"]), 4);
      case "OPV_1":
        return _birthDate!
            .add(Duration(days: (vaccineScheduleMonth[key] ?? 0) * 30));
      case "OPV_2":
        return _takenVaccines["OPV_1"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["OPV_1"]["takenOn"]), 4);
      case "OPV_3":
        return _takenVaccines["OPV_2"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["OPV_2"]["takenOn"]), 4);
      case "OPV_4":
        return _takenVaccines["OPV_3"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["OPV_3"]["takenOn"]), 4);
      case "ROTA_1":
        return addWeeks(_birthDate!, 6);
      case "ROTA_2":
        return _takenVaccines["ROTA_1"] == null
            ? null
            : addWeeks(DateTime.parse(_takenVaccines["ROTA_1"]["takenOn"]), 4);
      default:
        return _birthDate!
            .add(Duration(days: (vaccineScheduleMonth[key] ?? 0) * 30));
    }
  }

  // --------------------------------------------------------------------------
  // 6) BUILD UI
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_birthDate == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Birth date not found for this child.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      );
    }
    final currentSection = getOpenSectionMonth();
    if (!_didInitExpanded) {
      _expandedSectionTitle = _sectionTitleForMonth(currentSection);
      _didInitExpanded = true;
    }

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
          title: const Text(
            "Vaccinations",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        children: [
          _visitSection(
              title: "At Birth",
              isExpanded: currentSection == 0,
              vaccines: [
                _buildVaccineRow("BCG_0", 0),
                _buildVaccineRow("HEPB_BIRTH", 0),
                if (currentSection == 0) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "2 Months",
              isExpanded: currentSection == 2,
              vaccines: [
                _buildVaccineRow("DTAP_1", 2),
                _buildVaccineRow("HIB_1", 2),
                _buildVaccineRow("HEPB_1", 2),
                _buildVaccineRow("PCV_1", 2),
                _buildVaccineRow("IPV_1", 2),
                _buildVaccineRow("ROTA_1", 2),
                if (currentSection == 2) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "4 Months",
              isExpanded: currentSection == 4,
              vaccines: [
                _buildVaccineRow("DTAP_2", 4),
                _buildVaccineRow("HIB_2", 4),
                _buildVaccineRow("HEPB_2", 4),
                _buildVaccineRow("PCV_2", 4),
                _buildVaccineRow("IPV_2", 4),
                _buildVaccineRow("ROTA_2", 4),
                if (currentSection == 4) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "6 Months",
              isExpanded: currentSection == 6,
              vaccines: [
                _buildVaccineRow("DTAP_3", 6),
                _buildVaccineRow("HIB_3", 6),
                _buildVaccineRow("HEPB_3", 6),
                _buildVaccineRow("PCV_3", 6),
                _buildVaccineRow("IPV_3", 6),
                _buildVaccineRow("OPV_1", 6),
                if (currentSection == 6) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "9 Months",
              isExpanded: currentSection == 9,
              vaccines: [
                _buildVaccineRow("MCV4_1", 9),
                _buildVaccineRow("MEASLES_1", 9),
                if (currentSection == 9) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "12 Months",
              isExpanded: currentSection == 12,
              vaccines: [
                _buildVaccineRow("PCV_FINAL", 12),
                _buildVaccineRow("MMR_1", 12),
                _buildVaccineRow("VARICELLA_1", 12),
                _buildVaccineRow("MCV4_2", 12),
                _buildVaccineRow("OPV_2", 12),
                if (currentSection == 12) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "18 Months",
              isExpanded: currentSection == 18,
              vaccines: [
                _buildVaccineRow("DTAP_4", 18),
                _buildVaccineRow("MMR_2", 18),
                _buildVaccineRow("VARICELLA_2", 18),
                _buildVaccineRow("HEPA_1", 18),
                _buildVaccineRow("OPV_3", 18),
                _buildVaccineRow("HIB_FINAL", 18),
                if (currentSection == 18) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "24 Months",
              isExpanded: currentSection == 24,
              vaccines: [
                _buildVaccineRow("HEPA_2", 24),
                if (currentSection == 24) ..._buildLateComponents(),
              ]),
          _visitSection(
              title: "School Age",
              isExpanded: currentSection == 60,
              vaccines: [
                _buildVaccineRow("DTAP_5", 60),
                _buildVaccineRow("OPV_4", 60),
                _buildVaccineRow("MMR_SCHOOL", 60),
                _buildVaccineRow("VARICELLA_SCHOOL", 60),
                if (currentSection == 60) ..._buildLateComponents(),
              ]),
          if (widget.showConfirmSection) _confirmSection(),
        ],
      ),
    );
  }

  // ⭐ تعديل buildVaccineRow (الخطوة 3)
  Widget _buildVaccineRow(String key, int sectionMonth) {
    final schedDate = _getScheduledDate(key);
    final status = getVaccineStatus(key,
        earliestDate: schedDate, sectionMonth: sectionMonth);
    final expired = isExpired(key);
    final late = isLate(key, schedDate);
    final displayStatus =
        (getOpenSectionMonth() == sectionMonth &&
                status == VaccineStatus.overdue)
            ? VaccineStatus.upcoming
            : status;

    if (shouldShowInSection(
        isCurrent: getOpenSectionMonth() == sectionMonth,
        status: displayStatus,
        isLate: late,
        expired: expired)) {
      return _vaccineItem(key, _getVaccineName(key), displayStatus,
          subtitle: _getTakenSubtitle(key) ?? _getDeadlineText(key));
    }
    return const SizedBox.shrink();
  }

  String? _getTakenSubtitle(String key) {
    if (_takenVaccines[key] == null) return null;
    return "Taken on ${DateFormat('d MMM yyyy').format(DateTime.parse(_takenVaccines[key]['takenOn']))}";
  }

  String? _getDeadlineText(String key) {
    if (vaccineDeadlines.containsKey(key)) {
      final months = vaccineDeadlines[key];
      final useAvailableUntil =
          key == "BCG_0" || key == "ROTA_1" || key == "ROTA_2";
      if (useAvailableUntil) {
        return "Available until $months months";
      }
      return "Must be taken before $months months";
    }
    return null;
  }

  List<Widget> _buildLateComponents() {
    final currentSection = getOpenSectionMonth();
    List<Widget> lateWidgets = [];
    vaccineScheduleMonth.forEach((key, scheduledMonth) {
      if (scheduledMonth >= currentSection) return;
      final schedDate = _getScheduledDate(key);
      // استخدام النسخة الذكية هنا أيضاً لضمان الاتساق
      final status = getVaccineStatus(key,
          earliestDate: schedDate, sectionMonth: scheduledMonth);
      if (!isExpired(key) &&
          (status == VaccineStatus.overdue || isLate(key, schedDate))) {
        lateWidgets.add(_vaccineItem(key, _getVaccineName(key), status,
            subtitle: status == VaccineStatus.completed
                ? "Taken late • ${_getTakenSubtitle(key)}"
                : "Overdue from ${scheduledMonth}m"));
      }
    });
    return lateWidgets.isEmpty
        ? []
        : [
            const Divider(),
            const Text("Late Vaccinations",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ...lateWidgets
          ];
  }

  Widget _visitSection(
      {required String title,
      required List<Widget> vaccines,
      bool isExpanded = false}) {
    if (vaccines.where((v) => v is! SizedBox).isEmpty && !isExpanded) {
      return const SizedBox.shrink();
    }
    final isOpen = _expandedSectionTitle == title;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey("$title-$isOpen"),
          initiallyExpanded: isOpen,
          onExpansionChanged: (open) {
            setState(() {
              if (open) {
                _expandedSectionTitle = title;
              } else if (_expandedSectionTitle == title) {
                _expandedSectionTitle = null;
              }
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          iconColor: const Color(0xFF9D5C7D),
          collapsedIconColor: const Color(0xFF9D5C7D),
          trailing: AnimatedRotation(
            turns: isOpen ? 0.5 : 0.0,
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
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
          ),
          children: vaccines,
        ),
      ),
    );
  }

  String _getVaccineName(String key) {
    Map<String, String> names = {
      "BCG_0": "BCG (Tuberculosis)",
      "HEPB_BIRTH": "Hepatitis B (Birth Dose)",
      "HEPB_1": "Hepatitis B (Dose 1)",
      "HEPB_2": "Hepatitis B (Dose 2)",
      "HEPB_3": "Hepatitis B (Dose 3)",
      "DTAP_1": "DTaP (Dose 1)",
      "DTAP_2": "DTaP (Dose 2)",
      "DTAP_3": "DTaP (Dose 3)",
      "DTAP_4": "DTaP (Dose 4)",
      "DTAP_5": "DTaP/Td (School Age)",
      "HIB_1": "Hib (Dose 1)",
      "HIB_2": "Hib (Dose 2)",
      "HIB_3": "Hib (Dose 3)",
      "HIB_FINAL": "Hib (Final Dose)",
      "PCV_1": "PCV (Dose 1)",
      "PCV_2": "PCV (Dose 2)",
      "PCV_3": "PCV (Dose 3)",
      "PCV_FINAL": "PCV (Final)",
      "IPV_1": "IPV (Dose 1)",
      "IPV_2": "IPV (Dose 2)",
      "IPV_3": "IPV (Dose 3)",
      "OPV_1": "OPV (Dose 1)",
      "OPV_2": "OPV (Dose 2)",
      "OPV_3": "OPV (Dose 3)",
      "OPV_4": "OPV (Dose 4)",
      "ROTA_1": "Rotavirus (Dose 1)",
      "ROTA_2": "Rotavirus (Dose 2)",
      "MEASLES_1": "Measles (Dose 1)",
      "MMR_1": "MMR (Dose 1)",
      "MMR_2": "MMR (Dose 2)",
      "MMR_SCHOOL": "MMR (School Age)",
      "VARICELLA_1": "Varicella (Dose 1)",
      "VARICELLA_2": "Varicella (Dose 2)",
      "VARICELLA_SCHOOL": "Varicella (School Age)",
      "MCV4_1": "MCV4 (Dose 1)",
      "MCV4_2": "MCV4 (Dose 2)",
      "HEPA_1": "Hepatitis A (Dose 1)",
      "HEPA_2": "Hepatitis A (Dose 2)",
    };
    return names[key] ?? key;
  }

  Widget _vaccineItem(String key, String name, VaccineStatus status,
      {String? subtitle}) {
    return ListTile(
      leading: const Icon(Icons.vaccines_outlined, color: Color(0xFFC9A2B8)),
      title: Text(name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.grey))
          : null,
      trailing: _statusChip(status),
    );
  }

  Widget _statusChip(VaccineStatus status) {
    const double chipWidth = 80;
    const double chipHeight = 26;

    if (status == VaccineStatus.upcoming) {
      return SizedBox(
        width: chipWidth,
        height: chipHeight,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDADADA)),
          ),
          child: const Text("Upcoming",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }

    if (status == VaccineStatus.completed) {
      return SizedBox(
        width: chipWidth,
        height: chipHeight,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF9D5C7D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Completed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }

    return SizedBox(
      width: chipWidth,
      height: chipHeight,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent),
        ),
        child: const Text("Overdue",
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  List<_ConfirmableVaccine> _getConfirmableVaccines() {
    final items = <_ConfirmableVaccine>[];
    vaccineScheduleMonth.forEach((key, sectionMonth) {
      final schedDate = _getScheduledDate(key);
      final status = getVaccineStatus(key,
          earliestDate: schedDate, sectionMonth: sectionMonth);
      if (status == VaccineStatus.upcoming || status == VaccineStatus.overdue) {
        if (!isExpired(key)) {
          items.add(_ConfirmableVaccine(
              key: key,
              name: _getVaccineName(key),
              sectionMonth: sectionMonth,
              scheduledDate: schedDate));
        }
      }
    });
    items.sort((a, b) {
      final c = a.sectionMonth.compareTo(b.sectionMonth);
      if (c != 0) return c;
      return a.name.compareTo(b.name);
    });
    return items;
  }

  Widget _confirmSection() {
    final items = _getConfirmableVaccines();
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 25),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Confirm Vaccinations",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Text("No vaccinations available for confirmation.",
                style: TextStyle(fontSize: 12, color: Colors.grey))
          else
            ...items.map((item) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Color(0xFFF1F1F1)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            if (item.scheduledDate != null)
                              Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(item.scheduledDate!),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 34,
                        child: ElevatedButton.icon(
                          onPressed: widget.canConfirm
                              ? () => _confirmVaccine(item.key)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D5C7D),
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check,
                              size: 14, color: Colors.white),
                          label: const Text("Confirm",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

class _ConfirmableVaccine {
  final String key;
  final String name;
  final int sectionMonth;
  final DateTime? scheduledDate;

  _ConfirmableVaccine({
    required this.key,
    required this.name,
    required this.sectionMonth,
    required this.scheduledDate,
  });
}
