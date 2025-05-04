import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';

class LatihanGabunganHuruf extends StatefulWidget {
  const LatihanGabunganHuruf({super.key});

  @override
  State<LatihanGabunganHuruf> createState() => _LatihanGabunganHurufState();
}

class _LatihanGabunganHurufState extends State<LatihanGabunganHuruf> {
  int _currentSoalIndex = 0;
  int _counterBenar = 0;
  final List<_SoalGabunganModel> soalList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSoal();
  }

  Future<void> loadSoal() async {
    List<AksaraModel> allAksara =
        await AksaraLoader.loadAksaraFromAsset("nglegena");
    allAksara.shuffle();

    int maxSoal = 10;

    for (int i = 0; i < maxSoal; i++) {
      int jumlahHuruf = Random().nextInt(3) + 2; // 2 sampai 4 huruf

      if (allAksara.length < jumlahHuruf) break; // jika tidak cukup data

      // Ambil indeks random di dalam batas aman
      int startIndex = Random().nextInt(allAksara.length - jumlahHuruf + 1);
      List<AksaraModel> kombinasi =
          allAksara.sublist(startIndex, startIndex + jumlahHuruf);
      // DEBUG: print jawaban gabungan
      final jawaban = kombinasi.map((e) => e.huruf).join('');
      print('Soal $i: $jawaban');
      soalList.add(_SoalGabunganModel(kombinasi));
    }

    setState(() {});
  }

  void _cekJawaban(String jawaban) {
    final soal = soalList[_currentSoalIndex];
    if (soal.jawaban == jawaban.toLowerCase().trim()) {
      _counterBenar++;
    }

    if (_currentSoalIndex < soalList.length - 1) {
      setState(() {
        _currentSoalIndex++;
        _controller.clear();
      });
    } else {
      _tampilkanHasil();
    }
  }

  void _tampilkanHasil() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Latihan Selesai"),
        content: Text("Jawaban benar: $_counterBenar dari ${soalList.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (soalList.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final soal = soalList[_currentSoalIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ke ${_currentSoalIndex + 1} dari ${soalList.length}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tebak gabungan aksara ini',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: soal.aksara.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Image.asset(
                    e.image,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 60),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Tuliskan hurufnya (contoh: nalu)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _cekJawaban(_controller.text);
                }
              },
              child: const Text('Cek Jawaban'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SoalGabunganModel {
  final List<AksaraModel> aksara;
  final String jawaban;

  _SoalGabunganModel(this.aksara)
      : jawaban = aksara.map((e) => e.huruf.toLowerCase()).join('');
}
