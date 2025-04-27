import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_detail_panel.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/aksara_item_tile.dart';

class AksaraGridWidget extends StatefulWidget {
  final List<AksaraModel> data;

  const AksaraGridWidget({super.key, required this.data});

  @override
  State<AksaraGridWidget> createState() => _AksaraGridWidgetState();
}

class _AksaraGridWidgetState extends State<AksaraGridWidget> {
  int? selectedIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playAudio(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedIndex != null ? widget.data[selectedIndex!] : null;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: widget.data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final item = widget.data[index];
              return AksaraItemTile(
                aksara: item,
                isSelected: index == selectedIndex,
                onTap: () {
                  setState(() => selectedIndex = index);
                  _playAudio(item.audio);
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: selected == null
              ? const Center(child: Text("Pilih huruf untuk melihat detail"))
              : AksaraDetailPanel(
                  aksara: selected,
                  onPlay: () => _playAudio(selected.audio),
                ),
        )
      ],
    );
  }
}
