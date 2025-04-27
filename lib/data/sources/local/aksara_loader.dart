import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';

class AksaraLoader {
  static Future<List<AksaraModel>> loadAksaraFromAsset(String jenis) async {
    final String jsonString = await rootBundle.loadString('assets/data/$jenis.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> data = jsonMap['data'];

    return data.map((e) => AksaraModel.fromJson(e)).toList();
  }
}
