import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_nulis_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("testing sinau nulis displayed", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: LatihanMacaPage(),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data!.contains("Latihan Maca")),
        findsAny,
        reason: "title not displyed");
  });
}