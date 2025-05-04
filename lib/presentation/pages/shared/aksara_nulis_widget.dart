import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/core/utils/Detections.dart';
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:flutter/services.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SinauNulisWidget extends StatefulWidget {
  final String jenis;

  const SinauNulisWidget({super.key, required this.jenis});

  @override
  State<SinauNulisWidget> createState() => _SinauNulisWidgetState();
}

class _SinauNulisWidgetState extends State<SinauNulisWidget> {
  List<AksaraModel> aksaraList = [];
  int selectedIndex = 0;
  final SignatureController _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.black);
  ui.Image? _backgroundImage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<File> saveSignatureToTempFile(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/signature.png';

    final file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return file;
  }

  Future<void> loadData() async {
    aksaraList = await AksaraLoader.loadAksaraFromAsset(widget.jenis);
    setState(() {});
    _loadImage(aksaraList[selectedIndex].image);
  }

  Future<void> _loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    print(assetPath);
    setState(() {
      _backgroundImage = frame.image;
    });
  }

  Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  img.Image preprocessImage(Uint8List bytes, int targetSize) {
    img.Image original = img.decodeImage(bytes)!;

    // Resize
    img.Image resized =
        img.copyResize(original, width: targetSize, height: targetSize);

    // Grayscale
    return img.grayscale(resized);
  }

  Float32List imageToFloat32List(img.Image image) {
    final input = Float32List(image.width * image.height);
    int index = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final grayscale = img.getLuminance(pixel);
        input[index++] = grayscale / 255.0;
      }
    }

    return input;
  }

  void printModelShapes(Interpreter interpreter) {
    // Get input tensor
    final inputTensor = interpreter.getInputTensor(0);
    print("Input shape: ${inputTensor.shape}");
    print("Input type: ${inputTensor.type}");

    // Get output tensor
    final outputTensor = interpreter.getOutputTensor(0);
    print("Output shape: ${outputTensor.shape}");
    print("Output type: ${outputTensor.type}");
  }

  Future<void> runModel() async {
    // 1. Convert to ui.Image
    final uiImage = await _controller.toImage(width: 640, height: 640);

    if (uiImage == null) {
      print("Failed to convert signature to image.");
      return;
    }

    final model = await YOLOv8TFLite.create(
      metadataPath: "assets/metadata.yaml",
    );

    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final imgBytes = byteData!.buffer.asUint8List();
    final img.Image convertedImage = img.decodeImage(imgBytes)!;

    final rectangleImage = model.letterBox(convertedImage, 640, 640);

    final output = model.detect(rectangleImage.image, true);

    print(output);

    // show result in snackbar
    String result = "Hasil deteksi: \n";
    for (var element in output) {
      result += "${element.className} (${element.score})\n";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
      _controller.clear();
    });
    _loadImage(aksaraList[index].image);
  }

  void onCheckJawaban() async {
    runModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Ngelegena | aksara jawa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: aksaraList.length,
                itemBuilder: (context, index) {
                  final item = aksaraList[index];
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () => onSelect(index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.orange[200]
                            : Colors.transparent,
                        border: Border.all(color: Colors.brown),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.huruf.toUpperCase()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 16),
                  //   color: Colors.white.withOpacity(1.0),
                  //   width: double.infinity,
                  //   child: _backgroundImage != null
                  //       ? CustomPaint(
                  //           painter: BackgroundPainter(image: _backgroundImage!),
                  //         )
                  //       : null,
                  // ),
                  Positioned.fill(
                    // Ini akan memberi ukuran ke CustomPaint
                    child: _backgroundImage != null
                        ? CustomPaint(
                            painter:
                                BackgroundPainter(image: _backgroundImage!),
                          )
                        : Container(),
                  ),
                  Signature(
                    height: 200,
                    controller: _controller,
                    backgroundColor: Colors.transparent,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.brown),
                    ),
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('cek jawaban'),
                  onPressed: onCheckJawaban,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final ui.Image image;

  BackgroundPainter({required this.image});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..color = Colors.white.withOpacity(0.2);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
