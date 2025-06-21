import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final Color outerColor;
  final Color innerColor;
  final String nativeText;
  final String englishText;
  final VoidCallback onTap;
  final bool isSelected; // 🔹 Highlight active card

  const LanguageCard({
    super.key,
    required this.outerColor,
    required this.innerColor,
    required this.nativeText,
    required this.englishText,
    required this.onTap,
    this.isSelected = false, // 🔹 Default: not selected
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveOuterColor =
        isSelected ? outerColor.withOpacity(0.8) : outerColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 100,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: effectiveOuterColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: effectiveOuterColor.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Inner native text box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: innerColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                nativeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              englishText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
