import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale? locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void setArabic() => setLocale(const Locale('ar'));
  void setEnglish() => setLocale(const Locale('en'));

  void toggle() {
    final code = _locale?.languageCode ?? 'en';
    if (code == 'ar') {
      setEnglish();
    } else {
      setArabic();
    }
  }
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found in context');
    return scope!.notifier!;
  }
}
