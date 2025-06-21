import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQs'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🟦 Fixed Overflow: Wrap in Column instead of Row
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.help_outline, size: 28, color: Colors.teal),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'App Overview & Instructions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '📖 How to Use the OCR App',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('• Select your preferred language from the Dashboard.'),
          const Text("• Upload or capture an image/PDF containing printed text."),
          const Text('• Tap "Extract Text" to extract using OCR.'),
          const Text("• Optionally translate the text to any supported Indic language."),
          const Text("• Copy, download, or save the text to your profile."),
          const SizedBox(height: 24),

          const Text(
            '❓ Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const Text('• Q: What image formats are supported?'),
          const Text('  A: JPG, PNG, BMP and PDF files are supported.'),

          const SizedBox(height: 10),
          const Text('• Q: Does the app work offline?'),
          const Text('  A: No. An internet connection is required for OCR and translation.'),

          const SizedBox(height: 10),
          const Text('• Q: How can I change the theme or language?'),
          const Text('  A: Open the Settings screen from the Dashboard.'),

          const SizedBox(height: 10),
          const Text('• Q: Can I translate to all Indian languages?'),
          const Text('  A: Yes! You can translate to 16+ Indian languages after extracting text.'),

          const SizedBox(height: 10),
          const Text('• Q: Can I save extracted text for later?'),
          const Text('  A: Yes, log in via Google and save it to your "My Docs".'),

          const SizedBox(height: 10),
          const Text('• Q: Who built this app?'),
          const Text('  A: Built by Charitesh, Varun & Shashank for Swecha Tech ML + Flutter Project.'),

          const SizedBox(height: 10),
          const Text('• Q: What happens to my uploaded documents?'),
          const Text('  A: Uploaded documents are only processed temporarily and not stored permanently.'),
        ],
      ),
    );
  }
}
