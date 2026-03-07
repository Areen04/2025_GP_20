import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  final Set<String> _dismissed = {};
  static const int _reminderWindowDays = 7;

  DateTime _scheduledDate(DateTime birthDate, int months) {
    return DateTime(birthDate.year, birthDate.month + months, birthDate.day);
  }

  final Map<String, int> _vaccineScheduleMonth = {
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

  final Map<int, String> _vaccineSectionLabels = {
    0: "Newborn vaccination",
    2: "2-month vaccination",
    4: "4-month vaccination",
    6: "6-month vaccination",
    9: "9-month vaccination",
    12: "12-month vaccination",
    18: "18-month vaccination",
    24: "24-month vaccination",
    60: "School-age vaccination",
  };

  final Map<int, String> _milestoneLabels = {
    2: "2-month milestone check-up",
    4: "4-month milestone check-up",
    6: "6-month milestone check-up",
    9: "9-month milestone check-up",
    12: "1-year milestone check-up",
    15: "15-month milestone check-up",
    18: "18-month milestone check-up",
    24: "2-year milestone check-up",
    30: "30-month milestone check-up",
    36: "3-year milestone check-up",
    48: "4-year milestone check-up",
    60: "5-year milestone check-up",
  };

  List<_ReminderItem> _buildReminders(
      QuerySnapshot snapshot, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final items = <_ReminderItem>[];

    for (final doc in snapshot.docs) {
      final data = (doc.data() as Map<String, dynamic>?) ?? {};
      final childName =
          (data['name'] ?? data['childName'] ?? 'Child').toString();

      DateTime? birthDate;
      if (data['birthDate'] is Timestamp) {
        birthDate = (data['birthDate'] as Timestamp).toDate();
      } else if (data['birthDate'] is String) {
        birthDate = DateTime.tryParse(data['birthDate']);
      }
      if (birthDate == null) continue;

      final taken = data['takenVaccines'] != null
          ? Map<String, dynamic>.from(data['takenVaccines'])
          : <String, dynamic>{};

      final Map<int, List<String>> sectionToKeys = {};
      _vaccineScheduleMonth.forEach((key, months) {
        sectionToKeys.putIfAbsent(months, () => []).add(key);
      });

      sectionToKeys.forEach((sectionMonth, keys) {
        final hasPending = keys.any((k) => !taken.containsKey(k));
        if (!hasPending) return;

        final dueDate = _scheduledDate(birthDate!, sectionMonth);
        final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
        final daysUntil = dueDay.difference(today).inDays;
        if (daysUntil < 0 || daysUntil > _reminderWindowDays) return;

        final label = _vaccineSectionLabel(l10n, sectionMonth);
        final text = daysUntil == 0
            ? l10n.remindersDueToday(childName, label)
            : daysUntil == 1
                ? l10n.remindersDueInOneDay(childName, label)
                : l10n.remindersDueInDays(childName, label, daysUntil);

        final id = "${doc.id}_vax_$sectionMonth";
        if (_dismissed.contains(id)) return;

        items.add(_ReminderItem(
          id: id,
          text: text,
          dueDate: dueDay,
        ));
      });

      _milestoneLabels.forEach((months, _) {
        final dueDate = _scheduledDate(birthDate!, months);
        final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
        final daysUntil = dueDay.difference(today).inDays;
        if (daysUntil < 0 || daysUntil > _reminderWindowDays) return;

        final label = _milestoneLabel(l10n, months);
        final text = daysUntil == 0
            ? l10n.remindersDueToday(childName, label)
            : daysUntil == 1
                ? l10n.remindersDueInOneDay(childName, label)
                : l10n.remindersDueInDays(childName, label, daysUntil);

        final id = "${doc.id}_ms_$months";
        if (_dismissed.contains(id)) return;

        items.add(_ReminderItem(
          id: id,
          text: text,
          dueDate: dueDay,
        ));
      });
    }

    items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
          body: Center(child: Text(l10n.remindersPleaseLogin)));
    }
    final uid = user.uid;

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
            l10n.remindersTitle,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('parents')
            .doc(uid)
            .collection('children')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF9D5C7D)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                  l10n.remindersNoneForDays(_reminderWindowDays),
                  style: const TextStyle(color: Colors.grey)),
            );
          }

          final reminders = _buildReminders(snapshot.data!, l10n);
          if (reminders.isEmpty) {
            return Center(
              child: Text(
                  l10n.remindersNoneForDays(_reminderWindowDays),
                  style: const TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final item = reminders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_none,
                        color: Color(0xFF9D5C7D), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Color(0xFF9D5C7D), size: 18),
                      onPressed: () {
                        setState(() => _dismissed.add(item.id));
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ReminderItem {
  final String id;
  final String text;
  final DateTime dueDate;

  _ReminderItem({
    required this.id,
    required this.text,
    required this.dueDate,
  });
}

String _vaccineSectionLabel(AppLocalizations l10n, int month) {
  switch (month) {
    case 0:
      return l10n.remindersVaccineNewborn;
    case 2:
      return l10n.remindersVaccine2Months;
    case 4:
      return l10n.remindersVaccine4Months;
    case 6:
      return l10n.remindersVaccine6Months;
    case 9:
      return l10n.remindersVaccine9Months;
    case 12:
      return l10n.remindersVaccine12Months;
    case 18:
      return l10n.remindersVaccine18Months;
    case 24:
      return l10n.remindersVaccine24Months;
    case 60:
      return l10n.remindersVaccineSchoolAge;
    default:
      return l10n.remindersMonthVaccination(month);
  }
}

String _milestoneLabel(AppLocalizations l10n, int month) {
  switch (month) {
    case 2:
      return l10n.remindersMilestone2Months;
    case 4:
      return l10n.remindersMilestone4Months;
    case 6:
      return l10n.remindersMilestone6Months;
    case 9:
      return l10n.remindersMilestone9Months;
    case 12:
      return l10n.remindersMilestone12Months;
    case 15:
      return l10n.remindersMilestone15Months;
    case 18:
      return l10n.remindersMilestone18Months;
    case 24:
      return l10n.remindersMilestone24Months;
    case 30:
      return l10n.remindersMilestone30Months;
    case 36:
      return l10n.remindersMilestone36Months;
    case 48:
      return l10n.remindersMilestone48Months;
    case 60:
      return l10n.remindersMilestone60Months;
    default:
      return l10n.remindersMilestone60Months;
  }
}
