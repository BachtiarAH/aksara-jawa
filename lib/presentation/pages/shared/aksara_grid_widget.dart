import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
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

  void _playAudio(String path) async {
    print(path);
    path = "assets/$path";
    try {
      final sound = await SoLoud.instance.loadAsset(path);
      sound.allInstancesFinished.first.then((_) {
        SoLoud.instance.disposeSource(sound);
      });
      await SoLoud.instance.play(sound);
    } catch (e) {
      // Handle errors, such as the audio file not being found.
      print("Error playing audio $path: $e");
      // Show a user-friendly message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to play audio $path: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedIndex != null ? widget.data[selectedIndex!] : null;
    // Use LayoutBuilder to get the available width.
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the crossAxisCount based on the width.
        int crossAxisCount = 5;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 3; // For small screens, use 3 columns.
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 4; // For medium screens, use 4 columns.
        }

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
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
                  ? const Center(
                      child: Text("Pilih huruf untuk melihat detail"))
                  : AksaraDetailPanel(
                      aksara: selected,
                      onPlay: () => _playAudio(selected.audio),
                    ),
            )
          ],
        );
      },
    );
  }
}
