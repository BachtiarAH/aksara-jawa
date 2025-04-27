import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/menu_button.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 16,
          children: [
            MenuButton(
              label: 'sinau maca',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMaca),
            ),
            MenuButton(
              label: 'sinau nulis',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauNulis),
            ),
            MenuButton(
              label: 'latihan maca',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.latihanMaca),
            ),
            MenuButton(
              label: 'latihan nulis',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.latihanNulis),
            ),
          ],
        ),
      ),
    );
  }
}

