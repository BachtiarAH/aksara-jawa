import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/pages/home/home_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca/maca_huruf.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca/maca_tembung.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis/nulis_huruf.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis/nulis_tambung.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/setting/setting.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_nulis_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca/nglegena_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/nulis_page.dart';
import 'package:nulis_aksara_jawa/test.dart';

class AppRoutes {
  static const String home = '/';
  static const String sinauMaca = '/sinau/maca';
  static const String sinauNulis = '/sinau/nulis';
  static const String latihanMaca = '/latihan/maca';
  static const String latihanNulis = '/latihan/nulis';

  static const String sinauMacaPasangan = '/sinau/pasangan';
  static const String sinauMacaSwara = '/sinau/swara';
  static const String sinauMacaMurdha = '/sinau/murdha';
  static const String sinauMacaSandangan = '/sinau/sandangan';
  static const String sinauMacaRekan = '/sinau/rekan';
  static const String sinauMacaAngka = '/sinau/angka';
  static const String sinauMacaNgelegena = '/sinau/ngelegena';

  static const String sinauNulisPasangan = '/sinau/pasangan/nulis';
  static const String sinauNulisSwara = '/sinau/swara/nulis';
  static const String sinauNulisMurdha = '/sinau/murdha/nulis';
  static const String sinauNulisSandangan = '/sinau/sandangan/nulis';
  static const String sinauNulisRekan = '/sinau/rekan/nulis';
  static const String sinauNulisAngka = '/sinau/angka/nulis';
  static const String sinauNulisNgelegena = '/sinau/ngelegena/nulis';

  static const String latihanMacaHuruf = '/latihan/maca/huruf';
  static const String latihanMacaTembung = '/latihan/maca/tembung';

  static const String latihanNulisHuruf = '/latihan/nulis/huruf';
  static const String latihanNulisTembung = '/latihan/nulis/tembung';

  static const String setting = '/setting';

  static const String test = '/test';

  static Map<String, WidgetBuilder> routes = {
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
      AppRoutes.sinauNulisPasangan: (context) =>
          const SinauNulisWidget(jenis: 'pasangan'),
      AppRoutes.sinauNulisSwara: (context) =>
          const SinauNulisWidget(jenis: 'swara'),
      AppRoutes.sinauNulisMurdha: (context) =>
          const SinauNulisWidget(jenis: 'murdha'),
      AppRoutes.sinauNulisSandangan: (context) =>
          const SinauNulisWidget(jenis: 'sandangan'),
      AppRoutes.sinauNulisRekan: (context) =>
          const SinauNulisWidget(jenis: 'rekan'),
      AppRoutes.sinauNulisNgelegena: (context) =>
          const SinauNulisWidget(jenis: 'nglegena'),
      AppRoutes.latihanMacaHuruf: (context) => const LatihanNulisHuruf(),
      AppRoutes.latihanMacaTembung: (context) => const LatihanGabunganHuruf(),
      AppRoutes.latihanNulisHuruf: (context) =>
          const LatihanTulisAksaraWidget(),
      AppRoutes.latihanNulisTembung: (context) =>
          const LatihanNulisNglegenaGabunganWidget(),
      AppRoutes.setting: (context) => const Setting(),
    };
}
