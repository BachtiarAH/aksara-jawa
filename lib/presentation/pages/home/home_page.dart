import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/menu_button.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void setPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE9D5), // Light cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isPortrait
                  ? const SizedBox(height: 50)
                  : const SizedBox(height: 0),
              // Javanese title text
              Expanded(
                  flex: isPortrait ? 2 : 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              'ꦧꦼꦭꦗꦂꦄꦏ꧀ꦱꦫꦗꦮ',
                              style: TextStyle(
                                fontSize: isPortrait ? 32 : 24,
                                color: Colors.brown[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Latin subtitle
                          Text(
                            '( belajar aksara jawa )',
                            style: TextStyle(
                              fontSize: isPortrait ? 16 : 12,
                              color: Colors.brown[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.setting),
                        child: Icon(Icons.settings,
                            color: Colors.brown[800],
                            size: isPortrait ? 30 : 25),
                      ),
                    ],
                  )),

              // Pembelajaran (Learning) section
              Text(
                'Pembelajaran',
                style: TextStyle(
                  fontSize: isPortrait ? 20 : 16,
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                ),
              ),

              isPortrait
                  ? const SizedBox(height: 20)
                  : const SizedBox(height: 7),

              // Learning modules in a row
              Expanded(
                flex: 3,
                child: Padding(
                  padding: isPortrait
                      ? const EdgeInsets.only(bottom: 20)
                      : const EdgeInsets.only(bottom: 0),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) {
                      final cards = [
                        BuildLearningCard(
                          imagePath: "assets/Learning_new.png",
                          title: 'Sinau Maca',
                          subtitle: 'Mengenal dan Memahami\nAksara Jawa',
                          isPortrait: isPortrait,
                          onTap: () =>
                              // Navigator.pushNamed(context, AppRoutes.sinauMaca),
                              Navigator.pushNamed(
                                  context, AppRoutes.sinauMacaNgelegena),
                        ),
                        BuildLearningCard(
                          imagePath: "assets/exercise_new.png",
                          title: 'Sinau Nulis',
                          subtitle: 'Latihan Jawa dengan\nAksara Jawa',
                          isPortrait: isPortrait,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.sinauNulisNgelegena),
                        ),
                        BuildLearningCard(
                          imagePath: "assets/latihan_maca.png",
                          title: 'Latihan Maca',
                          subtitle: 'Mengenal dan Memahami\nAksara Jawa',
                          isPortrait: isPortrait,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.latihanMaca),
                        ),
                        BuildLearningCard(
                          imagePath: "assets/latihan_nulis.png",
                          title: 'Latihan Nulis',
                          subtitle: 'Latihan Jawa dengan\nAksara Jawa',
                          isPortrait: isPortrait,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.latihanNulis),
                        ),
                      ];
                      return SizedBox(
                        width: isPortrait ? 180 : 140,
                        child: cards[index],
                      );
                    },
                  ),
                ),
              ),

              // Footer
              Expanded(
                  flex: 1,
                  child: Container(
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
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildLearningCard({
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
          color: Color(0xFFF1D6BD),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPortrait ? const SizedBox(height: 15) : const SizedBox(height: 0),
            Image.asset(
              imagePath,
              width: isPortrait ? 140 : 100,
              height: isPortrait ? 140 : 100,
              fit: BoxFit.contain,
            ),
            isPortrait ? const SizedBox(height: 15) : const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: isPortrait ? 18 : 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            isPortrait ? const SizedBox(height: 8) : const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isPortrait ? 12 : 10,
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
