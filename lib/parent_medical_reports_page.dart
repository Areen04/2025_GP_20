import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

class ParentMedicalReportsPage extends StatefulWidget {
  final String childId;
  final String childName;

  const ParentMedicalReportsPage({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  State<ParentMedicalReportsPage> createState() =>
      _ParentMedicalReportsPageState();
}

class _ParentMedicalReportsPageState extends State<ParentMedicalReportsPage> {
  static const _pink = Color(0xFF9D5C7D);
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final Set<String> _expandedConditions = <String>{};

  CollectionReference<Map<String, dynamic>> get _reportsCol =>
      FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .collection('medical_reports');

  Stream<QuerySnapshot<Map<String, dynamic>>> _reportsStream() {
    return _reportsCol.orderBy("uploadedAt", descending: true).snapshots();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _toast(l10n.medicalReportsInvalidUrl);
      return;
    }

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) _toast(l10n.medicalReportsOpenFailed);
  }

  List<String> _uniqueConditions(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final set = <String>{};

    for (final d in docs) {
      final data = d.data();
      final conditions = data["conditions"];
      if (conditions is List) {
        for (final c in conditions) {
          final s = (c ?? "").toString().trim();
          if (s.isNotEmpty) set.add(s);
        }
      }
    }

    final list = set.toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<_ConditionReportText> _textsForCondition(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      String condition,
      ) {
    final out = <_ConditionReportText>[];

    for (final d in docs) {
      final data = d.data();
      final conds = data["conditions"];
      if (conds is! List) continue;

      final hasCondition =
      conds.any((x) => (x ?? "").toString().trim() == condition);
      if (!hasCondition) continue;

      final extractedText = (data["extractedText"] ?? "").toString().trim();
      if (extractedText.isEmpty) continue;

      DateTime? dt;
      final ts = data["uploadedAt"];
      if (ts is Timestamp) dt = ts.toDate();

      out.add(
        _ConditionReportText(
          whenText: dt != null ? DateFormat("yyyy-MM-dd • HH:mm").format(dt) : "",
          text: extractedText,
        ),
      );
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
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
            l10n.childDashboardMedicalConditionsTitle,
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
              color: _pink,
              size: 23,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _reportsStream(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];
          final conditions = _uniqueConditions(docs);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (conditions.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5F6),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      l10n.medicalReportsNoConditions,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                  )
                else
                  Column(
                    children: conditions.map((c) {
                      final isOpen = _expandedConditions.contains(c);
                      final texts = _textsForCondition(docs, c);

                      return _ConditionTileChevron(
                        title: c,
                        isExpanded: isOpen,
                        onToggle: () {
                          setState(() {
                            if (isOpen) {
                              _expandedConditions.remove(c);
                            } else {
                              _expandedConditions.add(c);
                            }
                          });
                        },
                        texts: texts,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),

                Text(
                  l10n.medicalReportsPreviousReports,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                if (docs.isEmpty)
                  Text(
                    l10n.medicalReportsNoReports,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFF6F6F6F),
                    ),
                  )
                else
                  Column(
                    children: docs.map((d) {
                      final data = d.data();

                      final fileName =
                          (data["fileName"] ?? l10n.medicalReportsReport)
                              .toString();
                      final type = (data["fileType"] ?? "").toString();
                      final url = (data["fileUrl"] ?? "").toString();
                      final status = (data["status"] ?? "").toString();

                      DateTime? dt;
                      final ts = data["uploadedAt"];
                      if (ts is Timestamp) dt = ts.toDate();

                      final dateText = dt != null
                          ? DateFormat("yyyy-MM-dd • HH:mm").format(dt)
                          : "";

                      final sub = [
                        type,
                        dateText,
                        if (status.isNotEmpty) "• $status",
                      ].join(" ");

                      return _ReportTile(
                        title: fileName,
                        subtitle: sub,
                        onTap: url.isEmpty ? null : () => _openUrl(url),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------- Widgets (نفس ستايل الدكتور) ----------------

class _ConditionReportText {
  final String whenText;
  final String text;

  _ConditionReportText({required this.whenText, required this.text});
}

class _ConditionTileChevron extends StatelessWidget {
  static const _pink = Color(0xFF9D5C7D);

  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<_ConditionReportText> texts;

  const _ConditionTileChevron({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey("$title-$isExpanded"),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (_) => onToggle(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          collapsedIconColor: _pink,
          iconColor: _pink,
          trailing: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 32,
              color: _pink,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          children: [
            _ReportTextBox(texts: texts),
          ],
        ),
      ),
    );
  }
}

class _ReportTextBox extends StatelessWidget {
  final List<_ConditionReportText> texts;

  const _ReportTextBox({required this.texts});

  @override
  Widget build(BuildContext context) {
    if (texts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F6),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          AppLocalizations.of(context)!.medicalReportsNoExtractedText,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Color(0xFF6F6F6F),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: texts.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F5F6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (t.whenText.isNotEmpty)
                Text(
                  t.whenText,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6F6F6F),
                  ),
                ),
              if (t.whenText.isNotEmpty) const SizedBox(height: 8),
              SelectableText(
                t.text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ReportTile({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFF9D5C7D)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new_rounded, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
