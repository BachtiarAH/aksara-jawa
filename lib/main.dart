import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/pages/home/home_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_nulis_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca/nglegena_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/nulis_page.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

void main() {
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
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.sinauMaca: (context) => const SinauMacaPage(),
        AppRoutes.sinauNulis: (context) => const SinauNulisPage(),
        AppRoutes.latihanMaca: (context) => const LatihanMacaPage(),
        AppRoutes.latihanNulis: (context) => const LatihanNulisPage(),
        AppRoutes.sinauMacaNgelegena: (context) => const SinauMacaNgelegenaPage(
              jenis: "nglegena",
            ),
        AppRoutes.sinauMacaSwara: (context) => const Placeholder(),
        AppRoutes.sinauMacaMurdha: (context) => const Placeholder(),
        AppRoutes.sinauMacaSandangan: (context) => const Placeholder(),
        AppRoutes.sinauMacaRekan: (context) => const Placeholder(),
        AppRoutes.sinauMacaAngka: (context) => const Placeholder(),
        AppRoutes.sinauMacaPasangan: (context) => const Placeholder(),

        AppRoutes.latihanMacaPasangan: (context) => const Placeholder(),
        AppRoutes.latihanMacaSwara: (context) => const Placeholder(),
        AppRoutes.latihanMacaMurdha: (context) => const Placeholder(),
        AppRoutes.latihanMacaSandangan: (context) => const Placeholder(),
        AppRoutes.latihanMacaRekan: (context) => const Placeholder(),
        AppRoutes.latihanMacaAngka: (context) => const Placeholder(),
        AppRoutes.latihanMacaNgelegena: (context) => const SinauNulisWidget(jenis: 'nglegena'),
      },
    );
  }
}
