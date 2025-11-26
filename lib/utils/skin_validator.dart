import 'dart:typed_data';
import 'package:image/image.dart' as img;

class SkinValidator {
  // 🔹 تفحص إذا الصورة مظلمة جدًا
  static bool isMostlyDark(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return true;

    int darkPixels = 0;
    for (var y = 0; y < decoded.height; y++) {
      for (var x = 0; x < decoded.width; x++) {
        final pixel = decoded.getPixel(x, y);
        final brightness = (pixel.r + pixel.g + pixel.b) / 3;
        if (brightness < 25) darkPixels++;
      }
    }

    final total = decoded.width * decoded.height;
    return (darkPixels / total) > 0.95;
  }

  // 🔹 تتحقق إذا الصورة فيها جلد مصاب فعلاً (احمرار / طفح)
  static bool containsInfectedSkin(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return false;

    int infectedPixels = 0;
    int totalPixels = decoded.width * decoded.height;

    for (var y = 0; y < decoded.height; y += 4) {
      for (var x = 0; x < decoded.width; x += 4) {
        final pixel = decoded.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        // 🔸 احمرار واضح (جلد متهيج)
        final redDominant = (r > 110 && (r - g) > 25 && (r - b) > 25);

        // 🔸 أو بني محمر (طفح أو بقع)
        final reddishTone = (r > 90 && g > 50 && b > 40 && (r - g) > 15);

        if (redDominant || reddishTone) infectedPixels++;
      }
    }

    final ratio = infectedPixels / (totalPixels / 16);
    print("🩸 Infected skin ratio: ${(ratio * 100).toStringAsFixed(1)}%");
    return ratio > 0.05; // لازم على الأقل 5٪ جلد مصاب
  }

  // 🔹 تحسب نسبة لون الجلد العامة (عشان شرط 45%)
  static double skinColorRatio(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return 0.0;

    int skinPixels = 0;
    for (var y = 0; y < decoded.height; y++) {
      for (var x = 0; x < decoded.width; x++) {
        final pixel = decoded.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        // نطاق لوني تقريبي للبشرة (فاتح إلى متوسط)
        final isSkin = (r > 95 && g > 40 && b > 20) &&
            (r - g).abs() > 15 &&
            (r > g && r > b) &&
            (r / g < 1.5) &&
            (r / b < 2.5);

        if (isSkin) skinPixels++;
      }
    }

    final totalPixels = decoded.width * decoded.height;
    final ratio = skinPixels / totalPixels;
    print("🎨 Skin color ratio: ${(ratio * 100).toStringAsFixed(2)}%");
    return ratio;
  }
}
