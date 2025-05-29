import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class LatihanNulisNglegenaGabunganWidget extends StatefulWidget {
//   const LatihanNulisNglegenaGabunganWidget({super.key});

//   @override
//   State<LatihanNulisNglegenaGabunganWidget> createState() =>
//       _LatihanNulisNglegenaGabunganWidgetState();
// }

// class _LatihanNulisNglegenaGabunganWidgetState
//     extends State<LatihanNulisNglegenaGabunganWidget> {
//   final int jumlahSoal = 10;
//   final SignatureController _controller = SignatureController(
//     penStrokeWidth: 4,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.white,
//   );

//   List<AksaraModel> allNglegena = [];
//   List<String> soalList = [];
//   int _counterSoal = 0;
//   int _counterBenar = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadSoal();
//   }

//   Future<void> _loadSoal() async {
//     allNglegena = await AksaraLoader.loadAksaraFromAsset(
//         "nglegena"); // pastikan ini jalan
//     final random = Random();

//     List<String> generated = [];
//     for (int i = 0; i < jumlahSoal; i++) {
//       int jumlahHuruf = random.nextInt(3) + 2; // 2 - 4 huruf
//       String kata = '';
//       for (int j = 0; j < jumlahHuruf; j++) {
//         final aksara = allNglegena[random.nextInt(allNglegena.length)];
//         kata += aksara.huruf;
//       }
//       generated.add(kata);
//     }

//     setState(() {
//       soalList = generated;
//     });
//   }

//   void _cekJawaban() async {
//     if (_controller.isNotEmpty) {
//       Uint8List? image = await _controller.toPngBytes();

//       if (image != null) {
//         final imgBytes = image!.buffer.asUint8List();
//         final img.Image convertedImage = img.decodeImage(imgBytes)!;

//         final model = await YOLOv8TFLite.create(
//           metadataPath: "assets/metadata.yaml",
//         );

//         final rectangleImage = model.letterBox(convertedImage, 640, 640);

//         final output = model.detect(rectangleImage.image, true);

//         var isCorrect = false;

//         if (output.length == soalList.length) {
//           for (int i = 0; i < output.length; i++) {
//             if (output[i].className == allNglegena[i].huruf) {
//               isCorrect = true;
//             } else {
//               isCorrect = false;
//               break;
//             }
//           }
//         }

//         setState(() {
//           if (isCorrect) _counterBenar++;
//           _counterSoal++;
//           _controller.clear();
//         });

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//             isCorrect ? 'Benar!' : 'Belum tepat!',
//             style: const TextStyle(fontSize: 16),
//           ),
//           backgroundColor: isCorrect ? Colors.green : Colors.red,
//           duration: const Duration(seconds: 1),
//         ));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (soalList.isEmpty) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (_counterSoal >= jumlahSoal) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Selesai")),
//         body: Center(
//           child: Text(
//             "Latihan selesai!\nBenar: $_counterBenar dari $jumlahSoal",
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 20),
//           ),
//         ),
//       );
//     }

//     final currentSoal = soalList[_counterSoal];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Soal ke ${_counterSoal + 1} dari $jumlahSoal"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               const Text("Tulislah aksara Jawa dari kata berikut:"),
//               const SizedBox(height: 8),
//               Text(
//                 currentSoal,
//                 style:
//                     const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 height: 200,
//                 decoration:
//                     BoxDecoration(border: Border.all(color: Colors.grey)),
//                 child: Signature(
//                     controller: _controller, backgroundColor: Colors.white),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.check),
//                     label: const Text("Cek Jawaban"),
//                     onPressed: _cekJawaban,
//                   ),
//                   const SizedBox(width: 16),
//                   OutlinedButton.icon(
//                     icon: const Icon(Icons.refresh),
//                     label: const Text("Bersihkan"),
//                     onPressed: () => _controller.clear(),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class LatihanNulisNglegenaGabunganWidget extends StatefulWidget {
  const LatihanNulisNglegenaGabunganWidget({super.key});

  @override
  State<LatihanNulisNglegenaGabunganWidget> createState() =>
      _LatihanNulisNglegenaGabunganWidgetState();
}

class _LatihanNulisNglegenaGabunganWidgetState
    extends State<LatihanNulisNglegenaGabunganWidget> {
  final int jumlahSoal = 10;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  List<AksaraModel> allNglegena = [];
  List<String> soalList = [];
  int _counterSoal = 0;
  int _counterBenar = 0;
  bool isLoading = false;

  // Warna tema (menggunakan warna dari LatihanTulisAksaraWidget)
  final Color primaryColor = const Color(0xFF5C3D2E);
  final Color accentColor = const Color(0xFFFF9800);
  final Color backgroundColor = const Color(0xFFFBE8D3);
  final Color cardColor = const Color(0xFFF1D6BD);

  @override
  void initState() {
    super.initState();
    _loadSoal();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSoal() async {
    setState(() {
      isLoading = true;
    });

    try {
      allNglegena = await AksaraLoader.loadAksaraFromAsset("nglegena");
      final random = Random();

      List<String> generated = [];
      for (int i = 0; i < jumlahSoal; i++) {
        int jumlahHuruf = random.nextInt(2) + 1; // 2 - 4 huruf
        String kata = '';
        for (int j = 0; j < jumlahHuruf; j++) {
          final aksara = allNglegena[random.nextInt(allNglegena.length)];
          kata += aksara.huruf;
        }
        generated.add(kata);
      }

      setState(() {
        soalList = generated;
        isLoading = false;
      });
    } catch (e) {
      _showSnackBar("Terjadi kesalahan saat memuat soal: $e", isError: true);
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

  Future<void> _cekJawaban() async {
    if (_controller.isEmpty) {
      _showSnackBar("Silakan tulis dulu jawabannya.", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uint8List? image = await _controller.toPngBytes();

      final supabase = Supabase.instance.client;
      // create random name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fullPath = await supabase.storage
          .from('in-app')
          .uploadBinary(
            'latihan/tembung/processed_image${timestamp}.png',
            image!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      print('File uploaded to: $fullPath');

      if (image != null) {
        final img.Image convertedImage = img.decodeImage(image)!;

        final model = await YOLOv8TFLite.create(
          metadataPath: "assets/metadata.yaml",
        );

        final rectangleImage = model.letterBox(convertedImage, 640, 640,0.5,0.5);

        final output = model.detect(rectangleImage.image, true);

        var isCorrect = false;

        if (output.isNotEmpty) {
          // if (output.length == soalList[_counterSoal].length) {
          //   isCorrect = true;
          //   for (int i = 0; i < output.length; i++) {
          //     if (!output[i].className!.contains(soalList[_counterSoal][i])) {
          //       isCorrect = false;
          //       break;
          //     }
          //   }
          // }
          String outputString = output.map((e) => e.className).join('');
          isCorrect = outputString == soalList[_counterSoal].toLowerCase();
        }

        if (isCorrect) _counterBenar++;

        print(output);
        // Tampilkan dialog hasil
        await _showResultDialog(isCorrect, img.encodeJpg(rectangleImage.image));

        _controller.clear();

        setState(() {
          _counterSoal++;
        });
      }
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

  Future<void> _showResultDialog(bool isBenar, Uint8List? imageByte) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: backgroundColor,
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
            if (imageByte != null)
              const SizedBox(width: 10),
            if (imageByte != null)
              Image.memory(
                imageByte,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Jawaban kamu ${isBenar ? 'benar' : 'salah'} untuk '${soalList[_counterSoal]}'",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            if (!isBenar)
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor,
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
          value: (_counterSoal + 1) / jumlahSoal,
          minHeight: 10,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
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
        color: cardColor,
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
                      "Soal ${_counterSoal + 1}/$jumlahSoal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? 13 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Skor: $_counterBenar",
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
                "Tulislah aksara Jawa dari kata berikut:",
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
        color: cardColor,
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
              _counterBenar >= 7 ? Icons.stars : Icons.emoji_events,
              color: _counterBenar >= 7 ? Colors.amber : primaryColor,
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
              "Kamu menjawab benar sebanyak $_counterBenar dari $jumlahSoal soal.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildScoreWidget(_counterBenar),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _counterSoal = 0;
                _counterBenar = 0;
                _controller.clear();
                _loadSoal(); // Generate soal baru
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

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLoading && soalList.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 20),
              Text(
                "Memuat soal...",
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_counterSoal >= jumlahSoal) {
      // Tampilkan hasil akhir
      return Scaffold(
        backgroundColor: backgroundColor,
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
                            'assets/exercise.png',
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
                      SizedBox(width: isLandscape ? 150 : 0),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Card(
                      color: cardColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            (isLandscape ? 0.5 : 0.8),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _counterBenar >= 7
                                  ? Icons.stars
                                  : Icons.emoji_events,
                              color: _counterBenar >= 7
                                  ? Colors.amber
                                  : primaryColor,
                              size: 50,
                            ).animate().scale(duration: 600.ms),
                            const SizedBox(height: 20),
                            Text(
                              "Latihan Selesai!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Kamu menjawab benar sebanyak $_counterBenar dari $jumlahSoal soal.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 30),
                            _buildScoreWidget(_counterBenar),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text("Ulangi Latihan"),
                              onPressed: () {
                                setState(() {
                                  _counterSoal = 0;
                                  _counterBenar = 0;
                                  _controller.clear();
                                  _loadSoal();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final currentSoal = soalList[_counterSoal];

    return Scaffold(
      backgroundColor: backgroundColor,
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
                          'assets/exercise.png',
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
                        : SizedBox(width: 0),
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
                            SizedBox(height: 10),
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
                        CircularProgressIndicator(color: primaryColor),
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
}
