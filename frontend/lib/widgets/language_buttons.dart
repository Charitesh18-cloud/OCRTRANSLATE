import 'package:flutter/material.dart';

class LanguageButtons extends StatelessWidget {
  final List<String> languages;
  final void Function(String) onLanguageSelected;

  const LanguageButtons({
    super.key,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: languages.map((lang) {
        return SizedBox(
          width: 140,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent, // Sky blue
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Curved edges
              ),
              elevation: 4,
            ),
            onPressed: () => onLanguageSelected(lang),
            child: Text(
              lang,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }
}
