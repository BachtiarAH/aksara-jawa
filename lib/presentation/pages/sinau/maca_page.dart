import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/menu_button.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

class SinauMacaPage extends StatelessWidget {
  const SinauMacaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sinau Maca')),
      body: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            MenuButton(
              label: 'aksara pasangan',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaPasangan),
            ),
            MenuButton(
              label: 'aksara swara',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaSwara),
            ),
            MenuButton(
              label: 'aksara murdha',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaMurdha),
            ),
            MenuButton(
              label: 'aksara sandangan',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaSandangan),
            ),
            MenuButton(
              label: 'aksara rekan',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaRekan),
            ),
            MenuButton(
              label: 'aksara Angka',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaAngka),
            ),
            MenuButton(
              label: 'aksara Ngelege­na',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.sinauMacaNgelegena),
            ),
          ],
        ),
      ),
    );
  }
}