import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:signature/signature.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LatihanTulisAksaraWidget extends StatefulWidget {
  const LatihanTulisAksaraWidget({super.key});

  @override
  State<LatihanTulisAksaraWidget> createState() =>
      _LatihanTulisAksaraWidgetState();
}

class _LatihanTulisAksaraWidgetState extends State<LatihanTulisAksaraWidget> {
  final SignatureController _controller =
      SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  final List<String> poolSoal = [
    'ha',
    'na',
    'ca',
    'ra',
    'ka',
    'da',
    'ta',
    'sa',
    'wa',
    'la'
  ];
  late List<String> soalList;
  int indexSoal = 0;
  int jumlahBenar = 0;
  bool isLoading = false;

  // Warna tema
  final Color primaryColor = const Color(0xFF5C3D2E); // Deep Purple
  final Color accentColor = const Color(0xFFFF9800);
  final Color backgroundColor = const Color(0xFFFBE8D3); // Light Grey

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void genereateSoal() {
    final random = Random();
    soalList = List.generate(10, (index) {
      return poolSoal[random.nextInt(poolSoal.length)];
    });
  }

  Future<void> _cekJawaban() async {
    if (_controller.isEmpty) {
      _showSnackBar("Silakan tulis dulu jawabannya.", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final image = await _controller.toImage();
      final pngBytes = await image!.toByteData(format: ui.ImageByteFormat.png);

      final imgBytes = pngBytes!.buffer.asUint8List();
      final img.Image convertedImage = img.decodeImage(imgBytes)!;

      final supabase = Supabase.instance.client;
      // create random name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fullPath = await supabase.storage
          .from('in-app')
          .uploadBinary(
            'latihan/huruf/processed_image${timestamp}.png',
            imgBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      print('File uploaded to: $fullPath');

      final model = await YOLOv8TFLite.create(
        metadataPath: "assets/metadata.yaml",
      );

      final rectangleImage = model.letterBox(convertedImage, 640, 640);

      final output = model.detect(rectangleImage.image, true);

      // Cek hasil Computer Vision
      bool isBenar = false;

      if (output.isEmpty) {
        _showSnackBar("Tidak ada hasil deteksi. Coba tulis lebih jelas.",
            isError: true);
        setState(() {
          isLoading = false;
        });
        return;
      }

      final detected = output.reduce((a, b) => a.score > b.score ? a : b);

      if (detected.className == soalList[indexSoal]) {
        isBenar = true;
      }

      if (isBenar) jumlahBenar++;

      // Tampilkan dialog hasil
      await _showResultDialog(isBenar);

      _controller.clear();

      setState(() {
        if (indexSoal < soalList.length - 1) {
          indexSoal++;
        } else {
          _tampilkanHasilAkhir();
        }
      });
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", isError: true);
      if (e is StorageException) {
        print('❌ Storage error: ${e.message}');
      } else {
        print('❌ Unknown error: $e');
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _showResultDialog(bool isBenar) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor:
            // isBenar ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
            backgroundColor,
        title: Row(
          children: [
            Icon(
              isBenar ? Icons.check_circle : Icons.cancel,
              color: isBenar ? Colors.green : Colors.red,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              isBenar ? "Benar!" : "Salah",
              style: TextStyle(
                color: isBenar ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Jawaban kamu ${isBenar ? 'benar' : 'salah'} untuk '${soalList[indexSoal]}'",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            if (!isBenar)
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF1D6BD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Coba perhatikan bentuk aksaranya dan coba lagi pada soal berikutnya.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );
  }

  void _tampilkanHasilAkhir() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFFE3F2FD),
        title: Row(
          children: [
            Icon(
              jumlahBenar >= 7 ? Icons.stars : Icons.emoji_events,
              color: jumlahBenar >= 7 ? Colors.amber : primaryColor,
              size: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              "Selesai!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kamu menjawab benar sebanyak $jumlahBenar dari ${soalList.length} soal.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildScoreWidget(jumlahBenar),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                indexSoal = 0;
                jumlahBenar = 0;
                _controller.clear();
                genereateSoal(); // Generate soal baru
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Ulangi Latihan"),
          )
        ],
      ),
    );
  }

  Widget _buildScoreWidget(int score) {
    String message;
    Color color;
    IconData icon;

    if (score >= 9) {
      message = "Hebat! Kamu sangat mahir menulis aksara!";
      color = Colors.green;
      icon = Icons.sentiment_very_satisfied;
    } else if (score >= 7) {
      message = "Bagus! Kamu sudah cukup menguasai!";
      color = Colors.blue;
      icon = Icons.sentiment_satisfied;
    } else if (score >= 5) {
      message = "Lumayan! Terus berlatih ya!";
      color = Colors.orange;
      icon = Icons.sentiment_neutral;
    } else {
      message = "Jangan menyerah! Teruslah berlatih!";
      color = Colors.red;
      icon = Icons.sentiment_dissatisfied;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    genereateSoal();
  }

  Widget _buildProgressIndicator() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      margin: EdgeInsets.only(
        left: isLandscape ? 40 : 20,
        right: isLandscape ? 70 : 20,
        top: 5,
        bottom: 5,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (indexSoal + 1) / soalList.length,
          minHeight: 10,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSoal = soalList[indexSoal];
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   title: Text(
      //     "Latihan Menulis Aksara",
      //     style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   actions: [
      //     Container(
      //       margin: const EdgeInsets.only(right: 16),
      //       child: Center(
      //         child: Container(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //           decoration: BoxDecoration(
      //             color: primaryColor.withOpacity(0.1),
      //             borderRadius: BorderRadius.circular(15),
      //           ),
      //           child: Text(
      //             "$jumlahBenar Benar",
      //             style: TextStyle(
      //               color: primaryColor,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: isLandscape ? 40 : 20,
                  right: isLandscape ? 70 : 20,
                  top: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFFE5CEB9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/exercise.png', // Sesuaikan dengan path icon buku
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ꦭꦠꦶꦲꦤ꧀ꦩꦕꦲꦸꦫꦸꦥ꦳꧀',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: isLandscape ? 16 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '( Latihan Maca huruf )',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: isLandscape ? 10 : 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isLandscape
                        ? ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Cek Jawaban"),
                            onPressed: isLoading ? null : _cekJawaban,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          )
                        : SizedBox(
                            width: 0,
                          )
                  ],
                ),
              ),
              _buildProgressIndicator(),
              Expanded(
                child: isLandscape
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildQuestionCard(currentSoal),
                          ),
                          Expanded(
                            child: _buildAnswerCard(),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildQuestionCard(currentSoal),
                            SizedBox(
                              height: 10,
                            ),
                            _buildAnswerCard(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text(
                          "Memeriksa jawaban...",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String currentSoal) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.only(
        left: isLandscape ? 40 : 20,
        right: isLandscape ? 40 : 20,
      ),
      child: Card(
        color: Color(0xFFF1D6BD),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: isLandscape ? 0 : 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "Soal ${indexSoal + 1}/${soalList.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? 13 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Skor: $jumlahBenar",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: isLandscape ? 13 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Tulislah aksara dari kata berikut:",
                style: TextStyle(fontSize: isLandscape ? 13 : 16),
              ).animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  currentSoal,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ).animate().scale(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard() {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.only(
        left: isLandscape ? 0 : 20,
        right: isLandscape ? 70 : 20,
      ),
      child: Card(
        color: Color(0xFFF1D6BD),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Tuliskan jawaban kamu di sini:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  isLandscape
                      ? GestureDetector(
                          onTap: () => _controller.clear(),
                          child: Icon(Icons.refresh))
                      : SizedBox()
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: isLandscape
                    ? MediaQuery.of(context).size.height * 0.4
                    : MediaQuery.of(context).size.height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Signature(
                    controller: _controller,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: isLandscape ? 0 : 16),
              isLandscape
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("Bersihkan"),
                          onPressed: () => _controller.clear(),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: backgroundColor,
                            foregroundColor: primaryColor,
                            side: BorderSide(
                              color: primaryColor,
                              width: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Cek Jawaban"),
                          onPressed: isLoading ? null : _cekJawaban,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
