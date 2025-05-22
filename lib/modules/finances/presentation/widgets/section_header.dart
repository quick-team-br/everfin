import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const SectionHeader({
    super.key,
    required this.title,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        OutlinedButton(
          onPressed: onButtonPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
