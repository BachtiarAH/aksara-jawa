import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';

class LatihanNulisHuruf extends StatefulWidget {
  const LatihanNulisHuruf({super.key});

  @override
  State<LatihanNulisHuruf> createState() => _LatihanNulisHurufState();
}

class _LatihanNulisHurufState extends State<LatihanNulisHuruf> {
  int _currentSoalIndex = 0;
  int _counterBenar = 0;
  List<AksaraModel> soalList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSoal();
  }

  Future<void> loadSoal() async {
    List<AksaraModel> allAksara = await AksaraLoader.loadAksaraFromAsset("nglegena");
    allAksara.shuffle(Random());
    setState(() {
      soalList = allAksara.take(10).toList(); // Ambil 10 soal acak
    });
  }

  void _cekJawaban(String jawaban) {
    if (soalList[_currentSoalIndex].huruf.toLowerCase() == jawaban.toLowerCase()) {
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
              Navigator.of(context).pop(); // kembali ke halaman sebelumnya
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
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Aksara apa iki?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  soal.image,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Tulisen aksara iki',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _cekJawaban(_controller.text.trim());
                    }
                  },
                  child: const Text('Nulis'),
                ),
              ],
            ),
          ),
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
