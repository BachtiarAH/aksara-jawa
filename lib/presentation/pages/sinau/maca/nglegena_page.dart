import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_grid_widget.dart';

// class SinauMacaNgelegenaPage extends StatelessWidget {
//   const SinauMacaNgelegenaPage({super.key, required this.jenis});

//   final String jenis;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$jenis | aksara jawa'),
//         leading: BackButton(onPressed: () => Navigator.pop(context)),
//       ),
//       body: FutureBuilder<List<AksaraModel>>(
//         future: AksaraLoader.loadAksaraFromAsset(jenis),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Tidak ada data.'));
//           }

//           return AksaraGridWidget(data: snapshot.data!);
//         },
//       ),
//     );
//   }
// }

class SinauMacaNgelegenaPage extends StatelessWidget {
  const SinauMacaNgelegenaPage({super.key, required this.jenis});

  final String jenis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEE6CE),
      body: SafeArea(
        child: Column(
          children: [
            // Header section with book icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
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
                  Container(
                    color: const Color(0xFFFEE6CE),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Learning.png',
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ꦱꦶꦤꦲꦸꦩꦕ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              '( Sinau Maca )',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
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
            ),

            // Kamus Aksara text
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  'Kamus Aksara',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
              ),
            ),

            // Main content with FutureBuilder
            Expanded(
              child: FutureBuilder<List<AksaraModel>>(
                future: AksaraLoader.loadAksaraFromAsset(jenis),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.brown));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Gagal memuat data: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data.'));
                  }

                  return AksaraGridWidget(data: snapshot.data!);
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFFFEE6CE),
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Copyright @2025 Baktiar. All Right Reserved',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
