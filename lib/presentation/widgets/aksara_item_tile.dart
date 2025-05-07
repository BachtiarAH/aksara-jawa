import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';

// class AksaraItemTile extends StatelessWidget {
//   final AksaraModel aksara;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const AksaraItemTile({
//     super.key,
//     required this.aksara,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange.shade200 : Colors.transparent,
//           border: Border.all(color: Colors.brown),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   aksara.image,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               aksara.huruf,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AksaraItemTile extends StatelessWidget {
  final AksaraModel aksara;
  final bool isSelected;
  final VoidCallback onTap;

  const AksaraItemTile({
    super.key,
    required this.aksara,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF1D6BD),
          border: isSelected ? Border.all(color: Colors.brown, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFE9D5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    aksara.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                aksara.huruf,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
