import 'package:flutter/widgets.dart';

String t(BuildContext context, String en, String ar) {
  final code = Localizations.localeOf(context).languageCode;
  return code == 'ar' ? ar : en;
}
