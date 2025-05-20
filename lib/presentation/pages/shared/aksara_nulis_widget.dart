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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class SinauNulisWidget extends StatefulWidget {
  final String jenis;

  const SinauNulisWidget({super.key, required this.jenis});

  @override
  State<SinauNulisWidget> createState() => _SinauNulisWidgetState();
}

class _SinauNulisWidgetState extends State<SinauNulisWidget> {
  List<AksaraModel> aksaraList = [];
  int? selectedIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      aksaraList = await AksaraLoader.loadAksaraFromAsset(widget.jenis);
    } catch (e) {
      print("Error loading data: $e");
      // Mockup data jika gagal memuat data asli
      aksaraList = List.generate(
        8,
        (index) => AksaraModel(
          huruf: String.fromCharCode(0x0A95 + index), // Karakter Jawa dummy
          image: 'assets/images/aksara_${index + 1}.png',
          audio: 'audio/aksara_${index + 1}.mp3',
          deskripsi: 'Deskripsi untuk Aksara ${index + 1}',
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showWritingBottomSheet(AksaraModel aksara, Orientation orientation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF4E6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return WritingPanel(
            aksara: aksara,
            orientation: orientation,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEE6CE),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              children: [
                // Header section with book icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1D6BD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF693C27),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 4),
                      color: const Color(0xFFFEE6CE),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/exercise.png',
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ꦱꦶꦤꦲꦸꦤꦸꦭꦶꦱ꧀',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(
                                '( Sinau Nulis )',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Instruction text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 16),
                    child: Text(
                      'Pilih aksara yang ingin kamu latih menulis',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Main content - Aksara Grid
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.brown))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 4,
                            childAspectRatio:
                                orientation == Orientation.portrait ? 0.9 : 0.9,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: aksaraList.length,
                          itemBuilder: (context, index) {
                            return AksaraWritingTile(
                              aksara: aksaraList[index],
                              isSelected: index == selectedIndex,
                              onTap: () {
                                setState(() => selectedIndex = index);
                                _showWritingBottomSheet(
                                    aksaraList[index], orientation);
                              },
                            );
                          },
                        ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color(0xFFFEE6CE),
                  width: double.infinity,
                  child: const Text(
                    'Copyright @2025 Baktiar. All Right Reserved',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AksaraWritingTile extends StatelessWidget {
  final AksaraModel aksara;
  final bool isSelected;
  final VoidCallback onTap;

  const AksaraWritingTile({
    super.key,
    required this.aksara,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF1D6BD),
          border: isSelected ? Border.all(color: Colors.brown, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFE9D5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    aksara.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                aksara.huruf,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WritingPanel extends StatefulWidget {
  final AksaraModel aksara;
  final Orientation orientation;

  const WritingPanel({
    super.key,
    required this.aksara,
    required this.orientation,
  });

  @override
  State<WritingPanel> createState() => _WritingPanelState();
}

class _WritingPanelState extends State<WritingPanel> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );
  ui.Image? _backgroundImage;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadImage(widget.aksara.image);
  }

  Future<void> _loadImage(String assetPath) async {
    try {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      setState(() {
        _backgroundImage = frame.image;
      });
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  Future<void> _checkAnswer() async {
    setState(() {
      isProcessing = true;
    });

    try {
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

      try {
        final supabase = Supabase.instance.client;
        // create random name
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final String fullPath =
            await supabase.storage.from('in-app').uploadBinary(
                  'sinau/processed_image${timestamp}.png',
                  imgBytes,
                  fileOptions:
                      const FileOptions(cacheControl: '3600', upsert: false),
                );
        print('File uploaded to: $fullPath');
      } catch (e) {
        if (e is StorageException) {
          print('❌ Storage error: ${e.message}');
        } else {
          print('❌ Unknown error: $e');
        }
      }

      final output = model.detect(rectangleImage.image, true);

      // Simulate processing delay for demonstration
      await Future.delayed(const Duration(seconds: 1));

      // Show result in dialog
      if (!mounted) return;

      // Generate result message
      String resultMessage = "";
      bool isCorrect = false;

      // In a real implementation, you would compare the detected character
      // with the expected one from widget.aksara.huruf

      // For demo purposes, assume there's an 80% chance it's correct
      isCorrect = true; // Simulate correct answer

      String result = "Hasil deteksi: \n";
      for (var element in output) {
        result += "${element.className} (${element.score})\n";
      }

      print("result: $result");

      _showResultDialog(isCorrect, result);
    } catch (e) {
      print("Error during processing: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Terjadi kesalahan saat memproses tulisan."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _showResultDialog(bool isCorrect, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF4E6),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.error,
              // color: isCorrect ? Colors.green : Colors.orange,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              // isCorrect ? "Bagus!" : "Coba Lagi",
              "Hasil Dari Model",
              style: TextStyle(
                color: Colors.brown.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.brown.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isCorrect) {
                Navigator.of(context).pop(); // Close bottom sheet if correct
              } else {
                _controller.clear();
              }
            },
            child: Text(
              // isCorrect ? "Lanjutkan" : "Coba Lagi",
              "Tutup",
              style: const TextStyle(color: Colors.brown),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orientation == Orientation.landscape) {
      // Landscape layout
      return Row(
        children: [
          // Writing area - Left side
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: Stack(
                children: [
                  if (_backgroundImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BackgroundPainter(image: _backgroundImage!),
                      ),
                    ),
                  Signature(
                    controller: _controller,
                    backgroundColor: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),

          // Info and controls - Right side
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                // Title and instructions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Tulis Aksara ${widget.aksara.huruf}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ikuti pola dan tulis di area yang disediakan",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Reference image
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _backgroundImage != null
                      ? Image.asset(
                          widget.aksara.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.brown,
                            );
                          },
                        )
                      : const Center(
                          child:
                              CircularProgressIndicator(color: Colors.brown)),
                ),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _controller.clear(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Hapus"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown,
                        side: BorderSide(color: Colors.brown.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: isProcessing ? null : _checkAnswer,
                      icon: isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ))
                          : const Icon(Icons.check),
                      label:
                          Text(isProcessing ? "Memeriksa..." : "Cek Jawaban"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Portrait layout (original)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ... (existing portrait layout code)
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.brown.shade300,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Tulis Aksara ${widget.aksara.huruf}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ikuti pola dan tulis di area yang disediakan",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _backgroundImage != null
                ? Image.asset(
                    widget.aksara.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.brown,
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.brown)),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.brown.shade300),
              ),
              child: Stack(
                children: [
                  if (_backgroundImage != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BackgroundPainter(image: _backgroundImage!),
                      ),
                    ),
                  Signature(
                    controller: _controller,
                    backgroundColor: Colors.transparent,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 70, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _controller.clear(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Hapus"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.brown,
                    side: BorderSide(color: Colors.brown.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isProcessing ? null : _checkAnswer,
                  icon: isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))
                      : const Icon(Icons.check),
                  label: Text(isProcessing ? "Memeriksa..." : "Cek Jawaban"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
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
