import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'parent_dashboard.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';

enum _DobCalendarMode { gregorian, hijriApprox }

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  File? _image;
  final picker = ImagePicker();

  final _nameController = TextEditingController();

  final _nameFocus = FocusNode();
  final _dobFocus = FocusNode();
  final _genderFocus = FocusNode(); // optional

  bool _dobTouched = false;
  bool _genderTouched = false;

  String? _selectedGender;
  DateTime? _selectedDob;

  bool _hasInteracted = false;
  bool _isSaving = false;

  bool _isValidDate() {
    if (_selectedDob == null) {
      return true;
    }
    final selected = _selectedDob!;

    final today = DateTime.now();

    return selected.isBefore(today) || selected.isAtSameMomentAs(today);
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  Color _getNameColor() {
    final text = _nameController.text.trim();

    // Before interacting → grey
    if (!_hasInteracted) return Colors.grey;

    // Focused
    if (_nameFocus.hasFocus) {
      // Focused + empty → purple
      if (text.isEmpty) return const Color(0xFF9D5C7D);
      // Focused + invalid → red
      if (text.length < 2) return Colors.red;
      // Focused + valid → green
      return const Color(0xFF9D5C7D);
    }

    // NOT focused
    if (text.isEmpty) return Colors.grey; // ← THIS IS THE FIX

    if (text.length >= 2) return Colors.grey;

    return Colors.red;
  }

  Color _dropdownColor({
    required String? value,
    required bool touched,
    required FocusNode focusNode,
  }) {
    // Before selection: always grey
    if (value == null) return Colors.grey;

    // Selected: purple when focused, grey otherwise (same feel as text fields)
    if (focusNode.hasFocus) return const Color(0xFF9D5C7D);
    return Colors.grey;
  }

  // ---------------------------------------------------------------------------
  // Date Picker (Gregorian) with Hijri (approx.) display
  // NOTE: This uses a tabular/civil Hijri conversion to assist parents.
  // If you later add an Umm Al-Qura library, you can swap _gregorianToHijri().
  // ---------------------------------------------------------------------------
  String _two(int n) => n.toString().padLeft(2, '0');

  ({int year, int month, int day}) _gregorianToHijri(DateTime date) {
    // Tabular Islamic calendar conversion (approx.)
    // Based on Julian Day conversion; may differ from Umm Al-Qura by 1–2 days.
    final y = date.year;
    final m = date.month;
    final d = date.day;

    int a = ((14 - m) / 12).floor();
    int y2 = y + 4800 - a;
    int m2 = m + 12 * a - 3;

    int jd = d +
        ((153 * m2 + 2) / 5).floor() +
        365 * y2 +
        (y2 / 4).floor() -
        (y2 / 100).floor() +
        (y2 / 400).floor() -
        32045;

    // Islamic (civil/tabular)
    int l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = (((10985 - l) / 5316).floor()) *
            (((50 * l) / 17719).floor()) +
        ((l / 5670).floor()) * (((43 * l) / 15238).floor());
    l = l -
        (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
        ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
        29;
    int mm = ((24 * l) / 709).floor();
    int dd = l - ((709 * mm) / 24).floor();
    int yy = 30 * n + j - 30;

    return (year: yy, month: mm, day: dd);
  }

  bool _isHijriLeapYear(int year) => ((11 * year + 14) % 30) < 11;

  int _hijriMonthLength(int year, int month) {
    if (month == 12) return _isHijriLeapYear(year) ? 30 : 29;
    return month.isOdd ? 30 : 29;
  }

  DateTime _hijriToGregorian(int year, int month, int day) {
    // Civil/tabular Hijri -> Gregorian conversion (approx.)
    // Uses Julian Day conversions and may differ from Umm Al-Qura by 1–2 days.
    final m = month;
    final y = year;
    final d = day;

    final jd = d +
        (((29.5 * (m - 1)).ceil())) +
        (y - 1) * 354 +
        ((3 + 11 * y) / 30).floor() +
        1948440 -
        1;

    int l = jd + 68569;
    int n = (4 * l / 146097).floor();
    l = l - ((146097 * n + 3) / 4).floor();
    int i = (4000 * (l + 1) / 1461001).floor();
    l = l - ((1461 * i) / 4).floor() + 31;
    int j = (80 * l / 2447).floor();
    final dayG = l - ((2447 * j) / 80).floor();
    l = (j / 11).floor();
    final monthG = j + 2 - 12 * l;
    final yearG = 100 * (n - 49) + i + l;

    return DateTime(yearG, monthG, dayG);
  }

  String _formatDob(DateTime d) => "${d.year}-${_two(d.month)}-${_two(d.day)}";

  Future<void> _pickDob() async {
    final l10n = AppLocalizations.of(context);
    final ml10n = MaterialLocalizations.of(context);
    final now = DateTime.now();
    final minDob = DateTime(now.year - 6, now.month, now.day)
        .add(const Duration(days: 1)); // strict: must be < 6 years
    final maxDob = DateTime(now.year, now.month, now.day);

    DateTime tempSelected = _selectedDob ?? maxDob;
    if (tempSelected.isBefore(minDob)) tempSelected = minDob;
    if (tempSelected.isAfter(maxDob)) tempSelected = maxDob;

    final picked = await showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        DateTime localSelected = tempSelected;
        _DobCalendarMode mode = _DobCalendarMode.gregorian;
        int gYear = localSelected.year;
        int gMonth = localSelected.month;
        var hijri = _gregorianToHijri(localSelected);
        int hijriYear = hijri.year;
        int hijriMonth = hijri.month;

        bool gMonthIntersectsRange(int y, int m) {
          final start = DateTime(y, m, 1);
          final end = DateTime(y, m + 1, 0);
          return !end.isBefore(minDob) && !start.isAfter(maxDob);
        }

        void prevGMonth() {
          int y = gYear;
          int m = gMonth - 1;
          if (m < 1) {
            y--;
            m = 12;
          }
          if (gMonthIntersectsRange(y, m)) {
            gYear = y;
            gMonth = m;
          }
        }

        void nextGMonth() {
          int y = gYear;
          int m = gMonth + 1;
          if (m > 12) {
            y++;
            m = 1;
          }
          if (gMonthIntersectsRange(y, m)) {
            gYear = y;
            gMonth = m;
          }
        }

        bool monthIntersectsRange(int y, int m) {
          final start = _hijriToGregorian(y, m, 1);
          final end = _hijriToGregorian(y, m, _hijriMonthLength(y, m));
          return !end.isBefore(minDob) && !start.isAfter(maxDob);
        }

        void prevHijriMonth() {
          int y = hijriYear;
          int m = hijriMonth - 1;
          if (m < 1) {
            y--;
            m = 12;
          }
          if (monthIntersectsRange(y, m)) {
            hijriYear = y;
            hijriMonth = m;
          }
        }

        void nextHijriMonth() {
          int y = hijriYear;
          int m = hijriMonth + 1;
          if (m > 12) {
            y++;
            m = 1;
          }
          if (monthIntersectsRange(y, m)) {
            hijriYear = y;
            hijriMonth = m;
          }
        }

        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final firstDayOfWeekIndex = ml10n.firstDayOfWeekIndex;
            final weekdayLabels = ml10n.narrowWeekdays;

            Future<int?> pickYearDialog({
              required String title,
              required int initialYear,
              required int minYear,
              required int maxYear,
            }) async {
              final picked = await showDialog<int>(
                context: ctx,
                builder: (dctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      height: 360,
                      child: ListView.builder(
                        itemCount: (maxYear - minYear + 1),
                        itemBuilder: (context, index) {
                          final year = minYear + index;
                          final selected = year == initialYear;
                          return ListTile(
                            title: Text(
                              year.toString(),
                              style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? const Color(0xFF9D5C7D)
                                    : Colors.black87,
                              ),
                            ),
                            onTap: () => Navigator.pop(dctx, year),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dctx),
                        child: Text(ml10n.cancelButtonLabel),
                      ),
                    ],
                  );
                },
              );
              return picked;
            }

            List<String> orderedWeekdays() {
              final labels = <String>[];
              for (int i = 0; i < 7; i++) {
                labels.add(weekdayLabels[(firstDayOfWeekIndex + i) % 7]);
              }
              return labels;
            }

            Widget gregorianCalendar() {
              final daysInMonth = DateTime(gYear, gMonth + 1, 0).day;
              final gFirst = DateTime(gYear, gMonth, 1);
              final weekdayIndex = gFirst.weekday % 7; // Sunday=0 ... Saturday=6
              final leadingEmpty =
                  (weekdayIndex - firstDayOfWeekIndex + 7) % 7;
              final totalCells =
                  (((leadingEmpty + daysInMonth) + 6) / 7).floor() * 7;

              bool isSameDay(DateTime a, DateTime b) =>
                  a.year == b.year && a.month == b.month && a.day == b.day;

              final canPrev = () {
                int y = gYear;
                int m = gMonth - 1;
                if (m < 1) {
                  y--;
                  m = 12;
                }
                return gMonthIntersectsRange(y, m);
              }();

              final canNext = () {
                int y = gYear;
                int m = gMonth + 1;
                if (m > 12) {
                  y++;
                  m = 1;
                }
                return gMonthIntersectsRange(y, m);
              }();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed:
                            canPrev ? () => setLocal(() => prevGMonth()) : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              final pickedYear = await pickYearDialog(
                                title: l10n.gregorianCalendarLabel,
                                initialYear: gYear,
                                minYear: minDob.year,
                                maxYear: maxDob.year,
                              );
                              if (pickedYear == null) return;
                              setLocal(() {
                                gYear = pickedYear;
                                if (!gMonthIntersectsRange(gYear, gMonth)) {
                                  // Snap month into an intersecting month.
                                  for (int m = 1; m <= 12; m++) {
                                    if (gMonthIntersectsRange(gYear, m)) {
                                      gMonth = m;
                                      break;
                                    }
                                  }
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: Text(
                                "$gYear-${_two(gMonth)}",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            canNext ? () => setLocal(() => nextGMonth()) : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (final label in orderedWeekdays())
                        Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      final dayNum = index - leadingEmpty + 1;
                      if (dayNum < 1 || dayNum > daysInMonth) {
                        return const SizedBox.shrink();
                      }

                      final gDate = DateTime(gYear, gMonth, dayNum);
                      final enabled =
                          !(gDate.isBefore(minDob) || gDate.isAfter(maxDob));
                      final selected = isSameDay(gDate, localSelected);

                      final fg = !enabled
                          ? Colors.black26
                          : selected
                              ? Colors.white
                              : Colors.black87;

                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: enabled
                            ? () => setLocal(() => localSelected = gDate)
                            : null,
                        child: Center(
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF9D5C7D)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dayNum.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w500,
                                color: fg,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            Widget hijriCalendar() {
              final daysInMonth = _hijriMonthLength(hijriYear, hijriMonth);
              final gFirst = _hijriToGregorian(hijriYear, hijriMonth, 1);
              final weekdayIndex = gFirst.weekday % 7; // Sunday=0 ... Saturday=6
              final leadingEmpty =
                  (weekdayIndex - firstDayOfWeekIndex + 7) % 7;
              final totalCells =
                  (((leadingEmpty + daysInMonth) + 6) / 7).floor() * 7;

              bool isSameDay(DateTime a, DateTime b) =>
                  a.year == b.year && a.month == b.month && a.day == b.day;

              final canPrev = () {
                int y = hijriYear;
                int m = hijriMonth - 1;
                if (m < 1) {
                  y--;
                  m = 12;
                }
                return monthIntersectsRange(y, m);
              }();

              final canNext = () {
                int y = hijriYear;
                int m = hijriMonth + 1;
                if (m > 12) {
                  y++;
                  m = 1;
                }
                return monthIntersectsRange(y, m);
              }();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: canPrev
                            ? () => setLocal(() => prevHijriMonth())
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Center(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              final minH = _gregorianToHijri(minDob).year;
                              final maxH = _gregorianToHijri(maxDob).year;
                              final pickedYear = await pickYearDialog(
                                title: l10n.hijriCalendarLabel,
                                initialYear: hijriYear,
                                minYear: minH,
                                maxYear: maxH,
                              );
                              if (pickedYear == null) return;
                              setLocal(() {
                                hijriYear = pickedYear;
                                if (!monthIntersectsRange(hijriYear, hijriMonth)) {
                                  for (int m = 1; m <= 12; m++) {
                                    if (monthIntersectsRange(hijriYear, m)) {
                                      hijriMonth = m;
                                      break;
                                    }
                                  }
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              child: Text(
                                "$hijriYear-${_two(hijriMonth)}",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: canNext
                            ? () => setLocal(() => nextHijriMonth())
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (final label in orderedWeekdays())
                        Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6F6F6F),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: totalCells,
                    itemBuilder: (context, index) {
                      final dayNum = index - leadingEmpty + 1;
                      if (dayNum < 1 || dayNum > daysInMonth) {
                        return const SizedBox.shrink();
                      }

                      final gDate =
                          _hijriToGregorian(hijriYear, hijriMonth, dayNum);
                      final enabled =
                          !(gDate.isBefore(minDob) || gDate.isAfter(maxDob));
                      final selected = isSameDay(gDate, localSelected);

                      final fg = !enabled
                          ? Colors.black26
                          : selected
                              ? Colors.white
                              : Colors.black87;

                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: enabled
                            ? () => setLocal(() => localSelected = gDate)
                            : null,
                        child: Center(
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF9D5C7D)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dayNum.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    selected ? FontWeight.w700 : FontWeight.w500,
                                color: fg,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              scrollable: true,
              title: Text(
                l10n.dateOfBirthLabel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setLocal(() {
                                mode = _DobCalendarMode.gregorian;
                                gYear = localSelected.year;
                                gMonth = localSelected.month;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mode == _DobCalendarMode.gregorian
                                  ? const Color(0xFF9D5C7D)
                                  : const Color(0xFFE8E6E7),
                              foregroundColor: mode == _DobCalendarMode.gregorian
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(l10n.gregorianCalendarLabel),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setLocal(() {
                                mode = _DobCalendarMode.hijriApprox;
                                final h = _gregorianToHijri(localSelected);
                                hijriYear = h.year;
                                hijriMonth = h.month;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mode == _DobCalendarMode.hijriApprox
                                  ? const Color(0xFF9D5C7D)
                                  : const Color(0xFFE8E6E7),
                              foregroundColor: mode == _DobCalendarMode.hijriApprox
                                  ? Colors.white
                                  : Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(l10n.hijriCalendarLabel),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 360,
                      child: mode == _DobCalendarMode.gregorian
                          ? gregorianCalendar()
                          : hijriCalendar(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(ml10n.cancelButtonLabel),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9D5C7D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx, localSelected),
                  child: Text(ml10n.okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );

    if (picked == null) return;
    setState(() {
      _dobTouched = true;
      _selectedDob = picked;
    });
  }

  // ---------------  Bottom Sheet to choose image source ---------------
  Future<void> _showImagePickerOptions() async {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Color(0xFF9D5C7D)),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF9D5C7D)),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // ------------------------ SAVE CHILD ------------------------
  Future<void> _addChild() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.fullNameMin2Error,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
      return; // ← IMPORTANT to stop adding
    }

    if (name.isEmpty || _selectedDob == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllRequiredFields,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // ❌ Prevent future date of birth
    if (!_isValidDate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.dobFutureError,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in.");

      // حساب العمر
      final birthDate = _selectedDob!;

      final now = DateTime.now();
      int age = now.year - birthDate.year;

      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      if (age >= 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.childMustBeUnderSixError,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            backgroundColor: const Color(0xFF9D5C7D),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      // رفع الصورة
      String? imageUrl;
      if (_image != null) {
        final ref = FirebaseStorage.instance.ref().child(
            'children_images/${name}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      // حفظ البيانات في فايرستور
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .collection('children')
          .add({
        'name': name,
        'gender': _selectedGender,
        'birthDate': _formatDob(birthDate),
        'age': age,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.childAddedSuccess,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF9D5C7D),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ParentDashboard()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorSavingChild(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ------------------------------ UI ------------------------------
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(70), // force same height as EditChild
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          title: Text(
            l10n.addChildTitle,
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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus(); // <-- FORCE unfocus
          setState(() {}); // <-- refresh colors
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ------------------ Upload Photo Circle ------------------
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFFF4E9EF),
                        child: _image == null
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: Color(0xFF9D5C7D),
                              )
                            : ClipOval(
                                child: Image.file(
                                  _image!,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),

                      // زر الـ (+)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF9D5C7D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                l10n.uploadPhoto,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // ------------------ Name ------------------
              _buildRequiredLabel(l10n.childFullNameLabel),
              Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    setState(() {});
                  }
                },
                child: TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  onTap: () {
                    setState(() => _hasInteracted = true);
                  },
                  onChanged: (_) {
                    setState(() {
                      _hasInteracted = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: l10n.enterChildFullNameHint,
                    hintStyle: const TextStyle(color: Colors.black54),
                    border: _border(Colors.grey),
                    enabledBorder: _border(_getNameColor()),
                    focusedBorder: _border(_getNameColor()),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------ DOB ------------------
              _buildRequiredLabel(l10n.dateOfBirthLabel),
              Focus(
                focusNode: _dobFocus,
                onFocusChange: (hasFocus) {
                  if (hasFocus) _dobTouched = true;
                  setState(() {});
                },
                child: InkWell(
                  onTap: () async {
                    _dobTouched = true;
                    setState(() {});
                    await _pickDob();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: l10n.selectDateOfBirthHint,
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: _border(_dropdownColor(
                        value: _selectedDob == null ? null : _formatDob(_selectedDob!),
                        touched: _dobTouched,
                        focusNode: _dobFocus,
                      )),
                      enabledBorder: _border(_dropdownColor(
                        value: _selectedDob == null ? null : _formatDob(_selectedDob!),
                        touched: _dobTouched,
                        focusNode: _dobFocus,
                      )),
                      focusedBorder: _border(const Color(0xFF9D5C7D)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDob == null
                                ? l10n.selectDateOfBirthHint
                                : _formatDob(_selectedDob!),
                            style: TextStyle(
                              color: _selectedDob == null
                                  ? Colors.black54
                                  : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Color(0xFF9D5C7D),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ------------------ Gender ------------------
              _buildRequiredLabel(l10n.genderLabel),
              Focus(
                focusNode: _genderFocus,
                onFocusChange: (hasFocus) {
                  if (hasFocus) _genderTouched = true;
                  setState(() {});
                },
                child: DropdownMenu<String>(
                  width: MediaQuery.of(context).size.width - 48,
                  hintText: l10n.selectGenderHint,
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  menuStyle: const MenuStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFFFF7FB)),
                    surfaceTintColor: WidgetStatePropertyAll(Colors.white),
                    elevation: WidgetStatePropertyAll(3),
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    maximumSize: WidgetStatePropertyAll(Size.fromHeight(120)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: const TextStyle(color: Colors.black54),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: _border(_dropdownColor(
                      value: _selectedGender,
                      touched: _genderTouched,
                      focusNode: _genderFocus,
                    )),
                    enabledBorder: _border(_dropdownColor(
                      value: _selectedGender,
                      touched: _genderTouched,
                      focusNode: _genderFocus,
                    )),
                    focusedBorder: _border(const Color(0xFF9D5C7D)),
                  ),
                  onSelected: (value) =>
                      setState(() => _selectedGender = value),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Male", label: l10n.maleLabel),
                    DropdownMenuEntry(value: "Female", label: l10n.femaleLabel),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ------------------ Button ------------------
              _isSaving
                  ? const CircularProgressIndicator(
                      color: Color(0xFF9D5C7D),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _addChild,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9D5C7D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.addChildButton,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------ Helpers ------------------------
  Widget _buildRequiredLabel(String text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              "*",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
