import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/core/utils/YoloV8.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:signature/signature.dart';
import 'package:image/image.dart' as img;

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
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  List<AksaraModel> allNglegena = [];
  List<String> soalList = [];
  int _counterSoal = 0;
  int _counterBenar = 0;

  @override
  void initState() {
    super.initState();
    _loadSoal();
  }

  Future<void> _loadSoal() async {
    allNglegena = await AksaraLoader.loadAksaraFromAsset(
        "nglegena"); // pastikan ini jalan
    final random = Random();

    List<String> generated = [];
    for (int i = 0; i < jumlahSoal; i++) {
      int jumlahHuruf = random.nextInt(3) + 2; // 2 - 4 huruf
      String kata = '';
      for (int j = 0; j < jumlahHuruf; j++) {
        final aksara = allNglegena[random.nextInt(allNglegena.length)];
        kata += aksara.huruf;
      }
      generated.add(kata);
    }

    setState(() {
      soalList = generated;
    });
  }

  void _cekJawaban() async {
    if (_controller.isNotEmpty) {
      Uint8List? image = await _controller.toPngBytes();

      if (image != null) {
        final imgBytes = image!.buffer.asUint8List();
        final img.Image convertedImage = img.decodeImage(imgBytes)!;

        final model = await YOLOv8TFLite.create(
          metadataPath: "assets/metadata.yaml",
        );

        final rectangleImage = model.letterBox(convertedImage, 640, 640);

        final output = model.detect(rectangleImage.image, true);

        var isCorrect = false;

        if (output.length == soalList.length) {
          for (int i = 0; i < output.length; i++) {
            if (output[i].className == allNglegena[i].huruf) {
              isCorrect = true;
            }else {
              isCorrect = false;
              break;
            }
          }
        }

        setState(() {
          if (isCorrect) _counterBenar++;
          _counterSoal++;
          _controller.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            isCorrect ? 'Benar!' : 'Belum tepat!',
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: isCorrect ? Colors.green : Colors.red,
          duration: const Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (soalList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_counterSoal >= jumlahSoal) {
      return Scaffold(
        appBar: AppBar(title: const Text("Selesai")),
        body: Center(
          child: Text(
            "Latihan selesai!\nBenar: $_counterBenar dari $jumlahSoal",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    final currentSoal = soalList[_counterSoal];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soal ke ${_counterSoal + 1} dari $jumlahSoal"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text("Tulislah aksara Jawa dari kata berikut:"),
              const SizedBox(height: 8),
              Text(
                currentSoal,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Signature(
                    controller: _controller, backgroundColor: Colors.white),
              ),
              const SizedBox(height: 16),
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
      ),
    );
  }
}
