import 'package:flutter/material.dart';
import 'package:rafiq_gp/l10n/app_localizations.dart';
import '../utils/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = LocaleScope.of(context);

    final currentCode = controller.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    final isArabic = currentCode == 'ar';
    final displayLabel = isArabic ? 'English' : 'العربية';

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: controller.toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.public, color: Color(0xFF9D5C7D), size: 16),
            const SizedBox(width: 8),
            Text(
              displayLabel,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
