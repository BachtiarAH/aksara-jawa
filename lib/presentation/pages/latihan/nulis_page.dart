import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/menu_button.dart';
import 'package:nulis_aksara_jawa/router/app_router.dart';

class LatihanNulisPage extends StatelessWidget {
  const LatihanNulisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Nulis')),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Center(
          child: Row(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                label: 'Latihan Maca Huruf',
                isActive: false,
                onPressed: () {Navigator.pushNamed(context, AppRoutes.latihanNulisHuruf);},
              ),
              SizedBox(height: 20),
              MenuButton(
                label: 'Latihan Maca Tembung',
                isActive: false,
                onPressed: () {Navigator.pushNamed(context, AppRoutes.latihanNulisTembung);},
              ),
            ],
          ),
        ),
      ),
    );
  }
}