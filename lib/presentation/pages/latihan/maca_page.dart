import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/menu_button.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

// class LatihanMacaPage extends StatelessWidget {
//   const LatihanMacaPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Latihan Maca')),
//       body: Container(
//         color: Colors.white,
//         width: double.infinity,
//         child: Center(
//           child: Row(
//             spacing: 16,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               MenuButton(
//                 label: 'Latihan Maca Huruf',
//                 isActive: false,
//                 onPressed: () {Navigator.pushNamed(context, AppRoutes.latihanMacaHuruf);},
//               ),
//               SizedBox(height: 20),
//               MenuButton(
//                 label: 'Latihan Maca Tembung',
//                 isActive: false,
//                 onPressed: () {Navigator.pushNamed(context, AppRoutes.latihanMacaTembung);},
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class LatihanMacaPage extends StatelessWidget {
  const LatihanMacaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE9D5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isPortrait
                  ? const SizedBox(height: 30)
                  : const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: isPortrait
                            ? MediaQuery.of(context).size.width * 0.49
                            : MediaQuery.of(context).size.width * 0.17,
                        child: Text(
                          'ꦭꦠꦶꦲꦤ꧀ꦩꦕ',
                          style: TextStyle(
                            fontSize: isPortrait ? 32 : 24,
                            color: Colors.brown[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Latin subtitle
                      Text(
                        '( latihan maca )',
                        style: TextStyle(
                          fontSize: isPortrait ? 16 : 12,
                          color: Colors.brown[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isPortrait
                  ? const SizedBox(height: 30)
                  : const SizedBox(height: 10),
              // Section Title
              Text(
                'Pilih Latihan',
                style: TextStyle(
                  fontSize: isPortrait ? 20 : 16,
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                ),
              ),

              isPortrait
                  ? const SizedBox(height: 20)
                  : const SizedBox(height: 10),

              // Grid Layout for Menu Options
              Expanded(
                child: GridView.count(
                  crossAxisCount: isPortrait ? 2 : 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: isPortrait ? 0.7 : 1.2,
                  children: [
                    _buildMenuCard(
                      context: context,
                      imagePath: "assets/latihan_maca_huruf.png",
                      title: 'Latihan Maca Huruf',
                      subtitle: 'Latihan membaca\naksara dasar',
                      isPortrait: isPortrait,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.latihanMacaHuruf),
                    ),
                    _buildMenuCard(
                      context: context,
                      imagePath: "assets/latihan_maca.png",
                      title: 'Latihan Maca Tembung',
                      subtitle: 'Latihan membaca\nkata dalam aksara Jawa',
                      isPortrait: isPortrait,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.latihanMacaTembung),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Copyright @2025 Baktiar',
                      style: TextStyle(
                        fontSize: isPortrait ? 12 : 10,
                        color: Colors.brown[700],
                      ),
                    ),
                    Text(
                      'All Right Reserved',
                      style: TextStyle(
                        fontSize: isPortrait ? 12 : 10,
                        color: Colors.brown[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required bool isPortrait,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1D6BD),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: isPortrait ? 90 : 60,
              height: isPortrait ? 90 : 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isPortrait ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isPortrait ? 10 : 10,
                  color: Colors.brown[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
