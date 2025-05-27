import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:test/test.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  test("test loading aksara from asset", () async {
    final aksaraList = await AksaraLoader.loadAksaraFromAsset("nglegena");
    flutter_test.expect(aksaraList, flutter_test.isA<List<AksaraModel>>(),reason: "aksaraList should be a list of AksaraModel");
    flutter_test.expect(aksaraList.length, 20, reason: "aksaraList should have 20 items");
  });

  test("test loading soal moca aksara jawa", () async {
    final aksaraList = await AksaraLoader.GenerateSoalMacaHuruf(10, "nglegena");
    flutter_test.expect(aksaraList, flutter_test.isA<List<AksaraModel>>(),reason: "aksaraList should be a list of AksaraModel");
    flutter_test.expect(aksaraList.length, 10, reason: "aksaraList should have 10 items");
  });

  test("test loading soal gabungan aksara jawa", () async {
    final aksaraList = await AksaraLoader.generateSoalGabungan(
      jumlahSoal: 10,
      minHuruf: 2,
      maxHuruf: 5,
      jenis: "nglegena",
    );
    flutter_test.expect(aksaraList, flutter_test.isA<List<dynamic>>(),reason: "aksaraList should be a list of List<AksaraModel>");
    flutter_test.expect(aksaraList.length, 10, reason: "aksaraList should have 10 items");
  });
}