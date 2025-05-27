import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';

class AksaraLoader {
  static Future<List<AksaraModel>> loadAksaraFromAsset(String jenis) async {
    final String jsonString =
        await rootBundle.loadString('assets/data/$jenis.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> data = jsonMap['data'];

    return data.map((e) => AksaraModel.fromJson(e)).toList();
  }

  static Future<List> GenerateSoalMacaHuruf(int count, String jenis) async {
    List allAksara = await AksaraLoader.loadAksaraFromAsset("nglegena");
    allAksara.shuffle(Random());
    List soalList = allAksara.take(10).toList();
    return soalList;
  }

  static Future<List> generateSoalGabungan({
    required int jumlahSoal,
    required int minHuruf,
    required int maxHuruf,
    String jenis = "nglegena",
  }) async {
    List<AksaraModel> allAksara = await loadAksaraFromAsset(jenis);
    allAksara.shuffle();
    List soalList = [];

    for (int i = 0; i < jumlahSoal; i++) {
      int jumlahHuruf = Random().nextInt(maxHuruf - minHuruf + 1) + minHuruf;

      if (allAksara.length < jumlahHuruf) break;

      int startIndex = Random().nextInt(allAksara.length - jumlahHuruf + 1);
      List<AksaraModel> kombinasi =
          allAksara.sublist(startIndex, startIndex + jumlahHuruf);

      soalList.add(kombinasi);
    }

    return soalList;
  }
}
