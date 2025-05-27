import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_detail_panel.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_grid_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca/nglegena_page.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/aksara_item_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("testing sinau maca displayed", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SinauMacaNgelegenaPage(jenis: "ngelegena"),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (widget) => widget is Text && widget.data!.contains("Sinau Maca")),
        findsAny,
        reason: "title not displyed");
  });
}
