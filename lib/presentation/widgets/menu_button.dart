import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.orange.shade300 : Colors.transparent,
        foregroundColor: Colors.brown,
        side: const BorderSide(color: Colors.brown),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
