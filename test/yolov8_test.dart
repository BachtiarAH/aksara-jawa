import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Test create YOLOv8TFLite instance", () async {
    const modelPath = "assets/best_float32.tflite";
    const metadataPath = "assets/metadata.yaml";
    const conf = 0.25;
    const iou = 0.45;

    final yoloV8 = await YOLOv8TFLite.create(
      modelPath: modelPath,
      conf: conf,
      iou: iou,
      metadataPath: metadataPath,
    );

    expect(yoloV8, isA<YOLOv8TFLite>());
    expect(yoloV8.model, isNotNull);
    expect(yoloV8.conf, conf);
    expect(yoloV8.iou, iou);
    expect(yoloV8.classes.length, 100);
  });
}
