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
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              aksara.image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(aksara.deskripsi, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.volume_up),
            label: const Text("Dengarkan"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
