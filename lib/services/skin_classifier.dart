// lib/services/skin_classifier.dart
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:onnxruntime/onnxruntime.dart';
import 'package:image/image.dart' as img;

class SkinClassifier {
  SkinClassifier._();
  static final SkinClassifier instance = SkinClassifier._();

  OrtSession? _session;

  // 🔹 أسماء ممكنة لمدخل الموديل
  final List<String> _candidateInputNames = const [
    'input',
    'images',
    'input_0',
    'x',
    'data'
  ];
  String _inputName = 'input';

  late final List<String> _labels;

  final int imgSize = 224;
  final List<double> mean = const [0.485, 0.456, 0.406];
  final List<double> std = const [0.229, 0.224, 0.225];

  /// تحميل الموديل والليبلات مرة واحدة
  Future<void> init() async {
    if (_session != null) return;

    // 🧠 حمّل الموديل من داخل lib
    final onnxBytes =
        await rootBundle.load('lib/models_RafiqSkinModel_idx.onnx');

    _session = OrtSession.fromBuffer(
      onnxBytes.buffer.asUint8List(),
      OrtSessionOptions(),
    );

    // 🏷️ تحميل labels
    final labelsStr = await rootBundle.loadString('lib/labels.txt');
    _labels = labelsStr
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (_labels.isEmpty) {
      throw Exception('Labels file is empty — check lib/labels.txt');
    }
  }

  /// 🔍 تحليل الصورة باستخدام الموديل
  Future<Map<String, dynamic>> predict(Uint8List imageBytes) async {
    final session = _session;
    if (session == null) {
      throw Exception('Model not ready yet. Call init() first.');
    }

    // 🖼️ فك ترميز الصورة وتغيير الحجم
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) throw Exception('Failed to decode image');
    final resized = img.copyResize(decoded, width: imgSize, height: imgSize);

    // 🔢 تحويل الصورة إلى Float32 مع normalization
    final floatData = _toNCHWFloat(resized);
    final input = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(floatData),
      [1, 3, imgSize, imgSize],
    );

    // 🚀 تنفيذ الموديل
    int? idx;
    Object? lastErr;

    for (final name in [_inputName, ..._candidateInputNames]) {
      try {
        final outs = session.run(OrtRunOptions(), {name: input});
        if (outs.isEmpty || outs.first == null) {
          throw Exception('ONNX returned empty output');
        }

        final raw = outs.first!.value;
        idx = _extractIndex(raw);
        _inputName = name;
        break;
      } catch (e) {
        lastErr = e;
      }
    }

    if (idx == null) {
      throw Exception(
          'Failed to run model with any known input name. Last error: $lastErr');
    }

    final label = (idx >= 0 && idx < _labels.length) ? _labels[idx] : 'Unknown';
    return {'label': label, 'index': idx};
  }

  /// تحويل الصورة إلى Float32 [1,3,H,W]
  List<double> _toNCHWFloat(img.Image im) {
    final w = im.width, h = im.height;
    final data = List<double>.filled(3 * h * w, 0.0, growable: false);
    var k = 0;

    for (int ch = 0; ch < 3; ch++) {
      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          final p = im.getPixel(x, y);
          double r, g, b;

          r = p.r / 255.0;
          g = p.g / 255.0;
          b = p.b / 255.0;

          final v = (ch == 0 ? r : (ch == 1 ? g : b));
          data[k++] = (v - mean[ch]) / std[ch];
        }
      }
    }
    return data;
  }

  /// استخراج الفهرس من مخرجات الموديل
  int _extractIndex(dynamic raw) {
    if (raw is int) return raw;
    if (raw is Float32List && raw.length == 1) return raw[0].round();
    if (raw is List) {
      dynamic cur = raw;
      while (cur is List && cur.isNotEmpty) {
        cur = cur.first;
      }
      if (cur is int) return cur;
      if (cur is num) return cur.round();
    }
    throw Exception('Unexpected output type: ${raw.runtimeType}');
  }
}
