import 'package:flutter/material.dart';
import 'package:nulis_aksara_jawa/data/models/aksara_model.dart';

class AksaraDetailPanel extends StatelessWidget {
  final AksaraModel aksara;
  final VoidCallback onPlay;

  const AksaraDetailPanel({
    super.key,
    required this.aksara,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1D6BD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF693C27),
                      size: 22,
                    ),
                  ),
                ),
              ),
              Text('Detail Aksara',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade700,
                  )),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.transparent,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            height: 130,
            width: 130,
            aksara.image,
            fit: BoxFit.contain,
          ),
          Text(
            aksara.deskripsi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.brown.shade700,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.volume_up),
            label: const Text("Dengarkan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
