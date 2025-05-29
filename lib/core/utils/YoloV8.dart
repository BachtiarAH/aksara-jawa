import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as ImageLibe;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yaml/yaml.dart';

class YOLOv8TFLite {
  late double conf;
  late double iou;
  late List<String> classes;
  late Interpreter model;
  late int inWidth;
  late int inHeight;
  late int inIndex;
  late double inScale;
  late int inZeroPoint;

  late bool isInt8;

  late int outIndex;
  late double outScale;
  late int outZeroPoint;

  YOLOv8TFLite._internal({
    required this.conf,
    required this.iou,
    required this.classes,
    required this.model,
    required this.inWidth,
    required this.inHeight,
    required this.inIndex,
    required this.inScale,
    required this.inZeroPoint,
    required this.isInt8,
    required this.outIndex,
    required this.outScale,
    required this.outZeroPoint,
  });

  static Future<YOLOv8TFLite> create({
    String? modelPath,
    double? conf,
    double? iou,
    String? metadataPath,
  }) async {
    final confidence = conf ?? 0.5;
    final iouThreshold = iou ?? 0.45;

    List<String> classNames = [];
    if (metadataPath == null) {
      classNames = List.generate(100, (i) => (i + 1).toString());
    } else {
      final yamlString = await rootBundle.loadString(metadataPath);
      final metadataContent = loadYaml(yamlString);
      print(metadataContent["names"]);
      final names = metadataContent['names'];
      names.forEach((key, value) {
        print("key: $key, value: $value");
        classNames.add(value.toString());
      });
    }

    final interpreter =
        await Interpreter.fromAsset(modelPath ?? 'assets/best_float32.tflite');
    interpreter.allocateTensors();

    // Get input and output tensor information
    final inputDetails = interpreter.getInputTensors()[0];
    var inShape = inputDetails.shape;
    int inWidth = inShape[1];
    int inHeight = inShape[2];
    int inIndex = interpreter.getInputIndex(inputDetails.name);
    double inScale = inputDetails.params.scale;
    int inZeroPoint = inputDetails.params.zeroPoint;
    bool isInt8 = inputDetails.type == TensorType.uint8;

    // Get output tensor information
    final outputDetails = interpreter.getOutputTensors()[0];
    int outIndex = interpreter.getOutputIndex(outputDetails.name);
    double outScale = outputDetails.params.scale;
    int outZeroPoint = outputDetails.params.zeroPoint;

    return YOLOv8TFLite._internal(
      conf: confidence,
      iou: iouThreshold,
      classes: classNames,
      model: interpreter,
      inWidth: inWidth,
      inHeight: inHeight,
      inIndex: inIndex,
      inScale: inScale,
      inZeroPoint: inZeroPoint,
      isInt8: isInt8,
      outIndex: outIndex,
      outScale: outScale,
      outZeroPoint: outZeroPoint,
    );
  }

  LetterBox letterBox(
    ImageLibe.Image image,
    int targetWidth,
    int targetHeight,
    double? percenthorizontalPadding,
    double? percentverticalPadding,
  ) {

    if (percenthorizontalPadding != null || percentverticalPadding != null) {
    final padW = ((image.width * (percenthorizontalPadding ?? 0))).toInt();
    final padH = ((image.height * (percentverticalPadding ?? 0))).toInt();

    image = ImageLibe.copyExpandCanvas(
      image,
      newWidth: image.width + 2 * padW,
      newHeight: image.height + 2 * padH,
      backgroundColor: ImageLibe.ColorFloat16.rgb(225, 225, 224),
    );
  }

    var scaleWidt = targetWidth / image.width;
    var scaleHeight = targetHeight / image.height;

    var resizewid;
    var resizeHeight;

    if (targetWidth > image.width) {
      if (image.width > image.height) {
        resizewid = targetWidth;
        resizeHeight = image.height * scaleWidt;
      } else {
        resizewid = image.width * scaleHeight;
        resizeHeight = targetHeight;
      }
    } else {
      if (image.width > image.height) {
        resizewid = targetWidth;
        resizeHeight = image.height * scaleWidt;
      } else {
        resizewid = image.width * scaleHeight;
        resizeHeight = targetHeight;
      }
    }

    print("resizewid: $resizewid, resizeHeight: $resizeHeight");

    var imageResized = ImageLibe.copyResize(
      image,
      width: resizewid.toInt(),
      height: resizeHeight.toInt(),
    );

    var color = ImageLibe.ColorFloat16.rgb(225, 225, 224);
    var imagePadded = ImageLibe.copyExpandCanvas(
      imageResized,
      newWidth: targetWidth,
      newHeight: targetHeight,
      backgroundColor: color,
    );

    // print("minimum pixel value: ${imagePadded.toList().ma}");

    var topWidt = (targetWidth - resizewid) / 2;
    var leftHeight = (targetHeight - resizeHeight) / 2;

    return LetterBox(
      image: imagePadded,
      topWidth: topWidt.toInt(),
      leftHeight: leftHeight.toInt(),
    );
  }

  List preprocessImage(
    ImageLibe.Image image,
    int targetWidth,
    int targetHeight,
  ) {
    // Resize the image
    final resized =
        ImageLibe.copyResize(image, width: targetWidth, height: targetHeight);

    final Float32List input = Float32List(1 * targetWidth * targetHeight * 3);
    int index = 0;

    for (int y = 0; y < targetHeight; y++) {
      for (int x = 0; x < targetWidth; x++) {
        final pixel = resized.getPixel(x, y);

        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;

        input[index++] = r / 255.0;
        input[index++] = g / 255.0;
        input[index++] = b / 255.0;
      }
    }

    final inputf = input.reshape([1, targetHeight, targetWidth, 3]);

    return inputf;
  }

  List<Detection> detect(ImageLibe.Image image, bool? isShort) {
    // Preprocess the image
    final input = preprocessImage(image, inWidth, inHeight);

    print(this.model.getOutputTensor(0).shape);

    // Run inference
    final output = create3DList(
        this.model.getOutputTensor(0).shape[0],
        this.model.getOutputTensor(0).shape[1],
        this.model.getOutputTensor(0).shape[2]);

    print("output shape: ${output}");
    model.run(input, output);

    final outputT = transpose1x24x8400to1x8400x24(output);
    final boxes = extractBoxes(outputT[0], conf); // threshold = 0.25
    final detections = nonMaxSuppression(boxes); // IoU = 0.45
    late List<Detection> finalDetections;
    if (isShort != null && isShort) {
      finalDetections = shortByX(detections);
    } else {
      finalDetections = detections;
    }

    return finalDetections;
  }

  List<List<List<double>>> create3DList(int batch, int channels, int values,
      [double fill = 0.0]) {
    return List.generate(
      batch,
      (_) => List.generate(
        channels,
        (_) => List.filled(values, fill),
      ),
    );
  }

  List<List<List<double>>> transpose1x24x8400to1x8400x24(
      List<List<List<double>>> input) {
    int batch = input.length;
    int channels = input[0].length;
    int values = input[0][0].length;

    List<List<List<double>>> output = List.generate(
      batch,
      (_) => List.generate(
        values,
        (_) => List.filled(channels, 0.0),
      ),
    );

    for (int b = 0; b < batch; b++) {
      for (int c = 0; c < channels; c++) {
        for (int v = 0; v < values; v++) {
          output[b][v][c] = input[b][c][v];
        }
      }
    }

    return output;
  }

  String getClassName(int index) {
    if (index < 0 || index >= classes.length) {
      return "Unknown";
    }
    return classes[index];
  }

  List<Detection> extractBoxes(
      List<List<double>> output, double scoreThreshold) {
    List<Detection> boxes = [];

    for (var i = 0; i < output.length; i++) {
      var row = output[i];
      var x = row[0], y = row[1], w = row[2], h = row[3];

      // Class probs
      var classScores = row.sublist(4);
      var maxClassScore = classScores.reduce(max);
      var classIndex = classScores.indexOf(maxClassScore);

      if (maxClassScore > scoreThreshold) {
        var x1 = x - w / 2;
        var y1 = y - h / 2;
        var x2 = x + w / 2;
        var y2 = y + h / 2;
        boxes.add(Detection(x1, y1, x2, y2, maxClassScore, classIndex, x, y, w,
            h, getClassName(classIndex)));
      }
    }
    return boxes;
  }

  double getIou(Detection a, Detection b) {
    final x1 = max(a.x1, b.x1);
    final y1 = max(a.y1, b.y1);
    final x2 = min(a.x2, b.x2);
    final y2 = min(a.y2, b.y2);

    final interArea = max(0.0, x2 - x1) * max(0.0, y2 - y1);
    final areaA = (a.x2 - a.x1) * (a.y2 - a.y1);
    final areaB = (b.x2 - b.x1) * (b.y2 - b.y1);

    return interArea / (areaA + areaB - interArea);
  }

  List<Detection> nonMaxSuppression(List<Detection> detections) {
    detections.sort((a, b) => b.score.compareTo(a.score));
    List<Detection> result = [];

    while (detections.isNotEmpty) {
      final current = detections.removeAt(0);
      result.add(current);
      detections.removeWhere((d) =>
          d.classIndex == current.classIndex && getIou(current, d) > iou);
    }

    return result;
  }

  List<Detection> shortByX(List<Detection> detections) {
    final List<Detection> shorted =
        (detections..sort((a, b) => a.x.compareTo(b.x)));
    return shorted;
  }

  // Post-process the output
}

class LetterBox {
  late ImageLibe.Image image;
  late int topWidth;
  late int leftHeight;

  LetterBox({
    required this.image,
    required this.topWidth,
    required this.leftHeight,
  });
}

class Detection {
  double x1, y1, x2, y2, score, x, y, w, h;
  int classIndex;
  String? className;

  Detection(this.x1, this.y1, this.x2, this.y2, this.score, this.classIndex,
      this.x, this.y, this.w, this.h,
      [this.className]);

  @override
  String toString() {
    // TODO: implement toString
    return "Detection: $className, x1: $x1, y1: $y1, x2: $x2, y2: $y2, score: $score, classIndex: $classIndex, className ${className ?? "null"}, x: $x, y: $y, w: $w, h: $h \n";
  }
}
