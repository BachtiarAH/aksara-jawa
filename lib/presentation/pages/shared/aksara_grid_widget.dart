import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';
import 'package:nulis_aksara_jawa/presentation/pages/shared/aksara_detail_panel.dart';
import 'package:nulis_aksara_jawa/presentation/widgets/aksara_item_tile.dart';

// class AksaraGridWidget extends StatefulWidget {
//   final List<AksaraModel> data;

//   const AksaraGridWidget({super.key, required this.data});

//   @override
//   State<AksaraGridWidget> createState() => _AksaraGridWidgetState();
// }

// class _AksaraGridWidgetState extends State<AksaraGridWidget> {
//   int? selectedIndex;

//   void _playAudio(String path) async {
//     print(path);
//     path = "assets/$path";
//     try {
//       final sound = await SoLoud.instance.loadAsset(path);
//       sound.allInstancesFinished.first.then((_) {
//         SoLoud.instance.disposeSource(sound);
//       });
//       await SoLoud.instance.play(sound);
//     } catch (e) {
//       // Handle errors, such as the audio file not being found.
//       print("Error playing audio $path: $e");
//       // Show a user-friendly message (optional)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to play audio $path: $e'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selected = selectedIndex != null ? widget.data[selectedIndex!] : null;
//     // Use LayoutBuilder to get the available width.
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Determine the crossAxisCount based on the width.
//         int crossAxisCount = 5;
//         if (constraints.maxWidth < 600) {
//           crossAxisCount = 3; // For small screens, use 3 columns.
//         } else if (constraints.maxWidth < 900) {
//           crossAxisCount = 4; // For medium screens, use 4 columns.
//         }

//         return Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8),
//                 itemCount: widget.data.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemBuilder: (context, index) {
//                   final item = widget.data[index];
//                   return AksaraItemTile(
//                     aksara: item,
//                     isSelected: index == selectedIndex,
//                     onTap: () {
//                       setState(() => selectedIndex = index);
//                       _playAudio(item.audio);
//                     },
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               flex: 2,
//               child: selected == null
//                   ? const Center(
//                       child: Text("Pilih huruf untuk melihat detail"))
//                   : AksaraDetailPanel(
//                       aksara: selected,
//                       onPlay: () => _playAudio(selected.audio),
//                     ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }

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
          duration: const Duration(seconds: 2),
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

    return MediaQuery.of(context).size.width < 600
        ? _buildMobileLayout()
        : _buildDesktopLayout(selected);
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          return InkWell(
            onTap: () {
              setState(() => selectedIndex = index);
              _playAudio(item.audio);

              // Tampilkan detail dalam dialog
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: const Color(0xFFFFF4E6),
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              //   ),
              //   builder: (context) => DraggableScrollableSheet(
              //     initialChildSize: 0.6,
              //     minChildSize: 0.4,
              //     maxChildSize: 0.9,
              //     expand: false,
              //     builder: (_, scrollController) {
              //       return SingleChildScrollView(
              //         controller: scrollController,
              //         child: AksaraDetailPanel(
              //           aksara: item,
              //           onPlay: () => _playAudio(item.audio),
              //         ),
              //       );
              //     },
              //   ),
              // );
            },
            child: AksaraItemTile(
              aksara: item,
              isSelected: index == selectedIndex,
              onTap: () {
                setState(() => selectedIndex = index);
                _playAudio(item.audio);
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: const Color(0xFFFFF4E6),
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        constraints: BoxConstraints(
                          maxWidth: 500,
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AksaraDetailPanel(
                            aksara: widget.data[index],
                            onPlay: () => _playAudio(widget.data[index].audio),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(AksaraModel? selected) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     // Determine the crossAxisCount based on the width
    //     int crossAxisCount = 5;
    //     if (constraints.maxWidth < 600) {
    //       crossAxisCount = 3; // For small screens, use 3 columns
    //     } else if (constraints.maxWidth < 900) {
    //       crossAxisCount = 4; // For medium screens, use 4 columns
    //     }

    //     return Row(
    //       children: [
    //         Expanded(
    //           flex: 2,
    //           child: GridView.builder(
    //             padding: const EdgeInsets.all(8),
    //             itemCount: widget.data.length,
    //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: crossAxisCount,
    //               crossAxisSpacing: 8,
    //               mainAxisSpacing: 8,
    //             ),
    //             itemBuilder: (context, index) {
    //               final item = widget.data[index];
    //               return AksaraItemTile(
    //                 aksara: item,
    //                 isSelected: index == selectedIndex,
    //                 onTap: () {
    //                   setState(() => selectedIndex = index);
    //                   _playAudio(item.audio);
    //                 },
    //               );
    //             },
    //           ),
    //         ),
    //         Expanded(
    //           flex: 2,
    //           child: selected == null
    //               ? const Center(
    //                   child: Text("Pilih huruf untuk melihat detail"))
    //               : AksaraDetailPanel(
    //                   aksara: selected,
    //                   onPlay: () => _playAudio(selected.audio),
    //                 ),
    //         )
    //       ],
    //     );
    //   },
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          return InkWell(
            onTap: () {
              setState(() => selectedIndex = index);
              _playAudio(item.audio);
            },
            child: AksaraItemTile(
              aksara: item,
              isSelected: index == selectedIndex,
              onTap: () {
                setState(() => selectedIndex = index);
                _playAudio(item.audio);
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: const Color(0xFFFFF4E6),
                    insetPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        constraints: BoxConstraints(
                          maxWidth: 500,
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AksaraDetailPanel(
                            aksara: widget.data[index],
                            onPlay: () => _playAudio(widget.data[index].audio),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
