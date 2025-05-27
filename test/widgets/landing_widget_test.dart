import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nulis_aksara_jawa/presentation/pages/home/home_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/maca_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/latihan/nulis_page.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_nulis_widget.dart';
import 'package:nulis_aksara_jawa/presentation/pages/sinau/maca/nglegena_page.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("testing menu widget all displayed", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    ));

    final button = find.byType(GestureDetector);
    // Verify that the button is present
    expect(button, findsAtLeast(4), reason: "Button not found");
    expect(find.text("Sinau Maca"), findsOne, reason: "Sinau Maca not found");
    expect(find.text("Sinau Nulis"), findsOne);
    expect(find.text("Latihan Maca"), findsOne);
    expect(find.text("Latihan Nulis"), findsOne);
  });

  testWidgets("test sinau maca navigation", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: HomePage()),
        routes: {
          AppRoutes.sinauMacaNgelegena: (context) =>
              const SinauMacaNgelegenaPage(jenis: "ngelegena"),
        },
      ),
    );

    final button = find.text("Sinau Maca");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text("( Sinau Maca )"), findsAny,
        reason: "Sinau Maca not found");
  });

  testWidgets("test sinau nulis navigation", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: HomePage()),
        routes: {
          AppRoutes.sinauNulisNgelegena: (context) =>
              const SinauNulisWidget(jenis: "nglegena"),
        },
      ),
    );

    final button = find.text("Sinau Nulis");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((widget) =>
            widget is Text && widget.data!.toLowerCase().contains("sinau nulis")), findsAny,
        reason: "Sinau Nulis not found");
  });

  testWidgets("test latihan maca navigation", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: HomePage()),
        routes: {
          AppRoutes.latihanMaca: (context) => const LatihanMacaPage(),
        },
      ),
    );

    final button = find.text("Latihan Maca");
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((widget) =>
            widget is Text && widget.data!.contains("latihan maca")), findsAny,
        reason: "Latihan Maca not found");
  });

  testWidgets("test latian nulis navigation", (train) async {
    await train.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: HomePage()),
        routes: {
          AppRoutes.latihanNulis: (context) => const LatihanNulisPage(),
        },
      ),
    );

    final button = find.text("Latihan Nulis");
    await train.tap(button);
    await train.pumpAndSettle();

    expect(
        find.byWidgetPredicate((widget) =>
            widget is Text && widget.data!.contains("latihan nulis")),
        findsAny,
        reason: "Latihan Nulis not found");
  });
}
