import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:signature/signature.dart';

class LatihanTulisAksaraWidget extends StatefulWidget {
  const LatihanTulisAksaraWidget({super.key});

  @override
  State<LatihanTulisAksaraWidget> createState() =>
      _LatihanTulisAksaraWidgetState();
}

class _LatihanTulisAksaraWidgetState extends State<LatihanTulisAksaraWidget> {
  final SignatureController _controller =
      SignatureController(penStrokeWidth: 4, penColor: Colors.black);
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  genereateSoal() {
    final random = Random();
    soalList = List.generate(10, (index) {
      return poolSoal[random.nextInt(poolSoal.length)];
    });
  }

  Future<void> _cekJawaban() async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan tulis dulu jawabannya.")));
      return;
    }

    final image = await _controller.toImage();
    final pngBytes = await image!.toByteData(format: ui.ImageByteFormat.png);

    final imgBytes = pngBytes!.buffer.asUint8List();
    final img.Image convertedImage = img.decodeImage(imgBytes)!;

    final model = await YOLOv8TFLite.create(
      metadataPath: "assets/metadata.yaml",
    );

    final rectangleImage = model.letterBox(convertedImage, 640, 640);

    final output = model.detect(rectangleImage.image, true);

    // Simulasi hasil Computer Vision (acak)
    bool isBenar = false;

    // get highest score
    if (output.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak ada hasil deteksi.")));
      return;
    }

    final detected = output.reduce((a, b) => a.score > b.score ? a : b);

    
    if (detected.className == soalList[indexSoal]) {
      isBenar = true;
    }
    

    if (isBenar) jumlahBenar++;

    // Tampilkan dialog hasil
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBenar ? "Benar!" : "Salah"),
        content: Text(
            "Jawaban kamu ${isBenar ? 'benar' : 'salah'} untuk '${soalList[indexSoal]}'"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Lanjut"),
          ),
        ],
      ),
    );

    _controller.clear();

    setState(() {
      if (indexSoal < soalList.length - 1) {
        indexSoal++;
      } else {
        _tampilkanHasilAkhir();
      }
    });
  }

  void _tampilkanHasilAkhir() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Selesai!"),
        content: Text(
            "Kamu menjawab benar sebanyak $jumlahBenar dari ${soalList.length} soal."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                indexSoal = 0;
                jumlahBenar = 0;
                _controller.clear();
              });
            },
            child: const Text("Ulangi"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    genereateSoal();
  }

  @override
  Widget build(BuildContext context) {
    final currentSoal = soalList[indexSoal];

    return Scaffold(
      appBar:
          AppBar(title: Text("Soal ${indexSoal + 1} dari ${soalList.length}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text("Tulislah aksara dari kata berikut:",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(currentSoal,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              height: 200,
              child: Signature(
                  controller: _controller, backgroundColor: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Cek Jawaban"),
                  onPressed: _cekJawaban,
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Bersihkan"),
                  onPressed: () => _controller.clear(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
