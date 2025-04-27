import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/data/sources/local/aksara_loader.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_grid_widget.dart';

class SinauMacaNgelegenaPage extends StatelessWidget {
  const SinauMacaNgelegenaPage({super.key,required this.jenis});

  final String jenis;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$jenis | aksara jawa'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: FutureBuilder<List<AksaraModel>>(
        future: AksaraLoader.loadAksaraFromAsset(jenis),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data.'));
          }

          return AksaraGridWidget(data: snapshot.data!);
        },
      ),
    );
  }
}