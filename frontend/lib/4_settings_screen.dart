import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../7_theme_provider.dart'; // ✅ Adjust the path if needed

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // 🌐 Launch Google Form in external browser
  void _launchFeedbackForm() async {
    final Uri url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSdRmN77rQEGDzncJ0RCupaGEGjwzbGJQq0dGHc4koxOn2dCOg/viewform',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('❌ Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.lightBlue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  Icon(Icons.settings, size: 28, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    'App Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🌙 Dark Mode Toggle
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),

          const Divider(height: 32),

          // 📝 Feedback Form
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text("Send Feedback"),
            subtitle: const Text("Opens Google Form"),
            onTap: _launchFeedbackForm,
          ),
        ],
      ),
    );
  }
}
