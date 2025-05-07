import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';

import 'dart:math';
import 'package:flutter/material.dart';

class LatihanNulisHuruf extends StatefulWidget {
  const LatihanNulisHuruf({super.key});

  @override
  State createState() => _LatihanNulisHurufState();
}

class _LatihanNulisHurufState extends State<LatihanNulisHuruf> {
  int _currentSoalIndex = 0;
  int _counterBenar = 0;
  List soalList = [];
  final TextEditingController _controller = TextEditingController();

  // Warna tema dari design
  final Color backgroundColor =
      const Color(0xFFFBE8D3); // Warna latar belakang beige
  final Color primaryColor =
      const Color(0xFF5C3D2E); // Warna coklat tua untuk tombol dan aksara
  final Color textColor = const Color(0xFF5C3D2E); // Warna untuk teks
  final Color inputColor = const Color(0xFFE5CEB9); // Warna untuk input field

  @override
  void initState() {
    super.initState();
    loadSoal();
  }

  Future loadSoal() async {
    List allAksara = await AksaraLoader.loadAksaraFromAsset("nglegena");
    allAksara.shuffle(Random());
    setState(() {
      soalList = allAksara.take(10).toList(); // Ambil 10 soal acak
    });
  }

  void _cekJawaban() {
    String jawaban = _controller.text.trim();
    if (jawaban.isNotEmpty &&
        soalList[_currentSoalIndex].huruf.toLowerCase() ==
            jawaban.toLowerCase()) {
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
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: backgroundColor,
        title: Text(
          "Latihan Selesai",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Jawaban benar:",
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "$_counterBenar dari ${soalList.length}",
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // kembali ke halaman sebelumnya
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(120, 45),
              ),
              child: const Text("Tutup", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (soalList.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    final soal = soalList[_currentSoalIndex];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: isPortrait
              ? Column(
                  children: [
                    // Header with logo and title
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
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '( Latihan Maca Huruf )',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: inputColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: textColor,
                                size: 22,
                              ),
                            ),
                          ),
                        ),

                        // Progress indicator
                        Row(
                          children: [
                            Text(
                              'Soal : ${_currentSoalIndex + 1}/10',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.hourglass_empty,
                              color: textColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Navigation and progress

                    // Aksara display (main content)
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            // child: Text(
                            //   // Menampilkan aksara Jawa, diganti dengan Image jika menggunakan gambar
                            //   'ꦥ', // Placeholder, gunakan soal.aksara atau yang sesuai
                            //   style: TextStyle(
                            //     color: primaryColor,
                            //     fontSize:
                            //         250, // Ukuran besar agar tampil maksimal dengan FittedBox
                            //     height: 1.2,
                            //   ),
                            // ),
                            // Jika menggunakan image, ganti dengan:
                            child: Image.asset(
                              soal.image,
                              height: 250,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Input field
                    Container(
                      width: double.infinity,
                      height: 56,
                      margin: const EdgeInsets.only(bottom: 40),
                      decoration: BoxDecoration(
                        color: inputColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controller,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Lebokne Jawaban mu',
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.6),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),

                    // Next button
                    Container(
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.only(bottom: 40),
                      child: ElevatedButton(
                        onPressed: _cekJawaban,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Selanjutnya',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    // Header with logo and title
                    Row(
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
                                color: inputColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: textColor,
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
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '( Latihan Maca Huruf )',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                // child: Text(
                                //   // Menampilkan aksara Jawa, diganti dengan Image jika menggunakan gambar
                                //   'ꦥ', // Placeholder, gunakan soal.aksara atau yang sesuai
                                //   style: TextStyle(
                                //     color: primaryColor,
                                //     fontSize:
                                //         250, // Ukuran besar agar tampil maksimal dengan FittedBox
                                //     height: 1.2,
                                //   ),
                                // ),
                                // Jika menggunakan image, ganti dengan:
                                child: Image.asset(
                                  soal.image,
                                  height: 250,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Soal : ${_currentSoalIndex + 1}/10',
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.hourglass_empty,
                                        color: textColor,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: inputColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 18,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Lebokne Jawaban mu',
                                        hintStyle: TextStyle(
                                          color: Color.fromRGBO(
                                            textColor.red,
                                            textColor.green,
                                            textColor.blue,
                                            0.6,
                                          ),
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: _cekJawaban,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 93, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Selanjutnya',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Expanded(
                    //   child: Center(
                    //     child: Container(
                    //       margin: const EdgeInsets.symmetric(vertical: 20),
                    //       width: double.infinity,
                    //       child: FittedBox(
                    //         fit: BoxFit.contain,
                    //         // child: Text(
                    //         //   // Menampilkan aksara Jawa, diganti dengan Image jika menggunakan gambar
                    //         //   'ꦥ', // Placeholder, gunakan soal.aksara atau yang sesuai
                    //         //   style: TextStyle(
                    //         //     color: primaryColor,
                    //         //     fontSize:
                    //         //         250, // Ukuran besar agar tampil maksimal dengan FittedBox
                    //         //     height: 1.2,
                    //         //   ),
                    //         // ),
                    //         // Jika menggunakan image, ganti dengan:
                    //         child: Image.asset(
                    //           soal.image,
                    //           height: 250,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Column(
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Text(
                    //           'Soal : ${_currentSoalIndex + 1}/10',
                    //           style: TextStyle(
                    //             color: textColor,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 5),
                    //         Icon(
                    //           Icons.hourglass_empty,
                    //           color: textColor,
                    //           size: 18,
                    //         ),
                    //       ],
                    //     ),

                    //     const SizedBox(height: 15),

                    //     // Input field
                    //     Container(
                    //       width: double.infinity,
                    //       height: 56,
                    //       margin: const EdgeInsets.only(bottom: 40),
                    //       decoration: BoxDecoration(
                    //         color: inputColor,
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: TextField(
                    //         controller: _controller,
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //           color: textColor,
                    //           fontSize: 18,
                    //         ),
                    //         decoration: InputDecoration(
                    //           hintText: 'Lebokne Jawaban mu',
                    //           hintStyle: TextStyle(
                    //             color: textColor.withOpacity(0.6),
                    //             fontSize: 16,
                    //           ),
                    //           border: InputBorder.none,
                    //           contentPadding:
                    //               const EdgeInsets.symmetric(horizontal: 16),
                    //         ),
                    //       ),
                    //     ),

                    //     // Next button
                    //     Container(
                    //       width: double.infinity,
                    //       height: 40,
                    //       margin: const EdgeInsets.only(bottom: 40),
                    //       child: ElevatedButton(
                    //         onPressed: _cekJawaban,
                    //         style: ElevatedButton.styleFrom(
                    //           backgroundColor: primaryColor,
                    //           foregroundColor: Colors.white,
                    //           elevation: 0,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //         ),
                    //         child: const Text(
                    //           'Selanjutnya',
                    //           style: TextStyle(
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
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
