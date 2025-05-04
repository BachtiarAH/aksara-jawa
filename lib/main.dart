import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:nulis_aksara_jawa/presentation/pages/home/home_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca/maca_huruf.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca/maca_tembung.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis/nulis_huruf.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis/nulis_tambung.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_nulis_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca/nglegena_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/nulis_page.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';
import 'package:nulis_aksara_jawa/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  await SoLoud.instance.init(
    sampleRate: 44100, // Audio quality
    bufferSize: 2048, // Buffer size affects latency
    channels: Channels.stereo,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aksara Jawa',
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.test: (context) => const LetterboxTestPage(),

        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.sinauMaca: (context) => const SinauMacaPage(),
        AppRoutes.sinauNulis: (context) => const SinauNulisPage(),
        AppRoutes.latihanMaca: (context) => const LatihanMacaPage(),
        AppRoutes.latihanNulis: (context) => const LatihanNulisPage(),
        

        AppRoutes.sinauMacaSwara: (context) => const Placeholder(),
        AppRoutes.sinauMacaMurdha: (context) => const Placeholder(),
        AppRoutes.sinauMacaSandangan: (context) => const Placeholder(),
        AppRoutes.sinauMacaRekan: (context) => const Placeholder(),
        AppRoutes.sinauMacaAngka: (context) => const Placeholder(),
        AppRoutes.sinauMacaPasangan: (context) => const Placeholder(),
        AppRoutes.sinauMacaNgelegena: (context) => const SinauMacaNgelegenaPage(
              jenis: "nglegena",
            ),

        AppRoutes.sinauNulisAngka: (context) => const Placeholder(),
        AppRoutes.sinauNulisPasangan: (context) => const SinauNulisWidget(jenis: 'pasangan'),
        AppRoutes.sinauNulisSwara: (context) => const SinauNulisWidget(jenis: 'swara'),
        AppRoutes.sinauNulisMurdha: (context) => const SinauNulisWidget(jenis: 'murdha'),
        AppRoutes.sinauNulisSandangan: (context) => const SinauNulisWidget(jenis: 'sandangan'),
        AppRoutes.sinauNulisRekan: (context) => const SinauNulisWidget(jenis: 'rekan'),
        AppRoutes.sinauNulisNgelegena: (context) => const SinauNulisWidget(jenis: 'nglegena'),
        
        AppRoutes.latihanMacaHuruf: (context) => const LatihanNulisHuruf(),
        AppRoutes.latihanMacaTembung: (context) => const LatihanGabunganHuruf(),

        AppRoutes.latihanNulisHuruf: (context) => const LatihanTulisAksaraWidget(),
        AppRoutes.latihanNulisTembung: (context) => const LatihanNulisNglegenaGabunganWidget(),
      },
    );
  }
}
