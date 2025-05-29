import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:nulis_aksara_jawa/core/utils/Detections.dart';
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LetterboxTestPage extends StatefulWidget {
  const LetterboxTestPage({Key? key}) : super(key: key);

  @override
  State<LetterboxTestPage> createState() => _LetterboxTestPageState();
}

class _LetterboxTestPageState extends State<LetterboxTestPage> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    processImage();
  }

  Future<void> processImage() async {
    // Load image from assets
    final byteData = await rootBundle.load('assets/cropedCaDaCa.JPG');
    final originalImage = img.decodeImage(byteData.buffer.asUint8List());

    if (originalImage == null) return;

    // Create a dummy YOLOv8TFLite instance just to access letterBox
    final dummyModel = await YOLOv8TFLite.create(metadataPath: "assets/metadata.yaml");

    final result = dummyModel.letterBox(originalImage, 640, 640,0,0);

    final input = dummyModel.preprocessImage(originalImage, 640, 640);
    final paddedImageBytes = img.encodeJpg(result.image);
    final output = dummyModel.detect(result.image, true);

    output.forEach((element) {
      print(element);
    });
    setState(() {
      imageBytes = Uint8List.fromList(paddedImageBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Letterbox Visual Test')),
      body: Center(
        child: imageBytes != null
            ? Image.memory(imageBytes!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
