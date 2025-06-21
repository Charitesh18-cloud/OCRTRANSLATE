import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import '1_dashboard_screen.dart';
import '2_uploadextract.dart';
import '3_profile_screen.dart';
import '4_settings_screen.dart';
import '5_help_screen.dart';
import '6_login_screen.dart';
import '7_theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'OCR Digitization Platform',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.currentTheme,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const AuthWrapper(),
      routes: {
        '/dashboard': (_) => const DashboardScreen(),
        '/uploadextract': (_) => const UploadExtractScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/help': (_) => const HelpScreen(),
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<(bool, User?)> _getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('guest_mode') ?? false;
    final user = FirebaseAuth.instance.currentUser;
    return (isGuest, user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(bool, User?)>(
      future: _getAuthState(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final (isGuest, user) = snapshot.data!;
        if (user != null || isGuest) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🟦 Corner Decorations
          Positioned(top: 0, left: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(top: 0, right: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(bottom: 0, left: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(bottom: 0, right: 0, child: _cornerBox(Colors.lightBlue.shade100)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🟪 Highlighted Title
                  Card(
                    color: Colors.deepPurple.shade50,
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        'OCR DIGITIZATION',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🖼 Logo
                  Image.asset(
                    'assets/logo.png',
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                  ),
                  const SizedBox(height: 40),

                  // 👋 Welcome
                  Text(
                    'Welcome, ${user?.displayName ?? 'Guest'}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 📄 Icon
                  const Icon(
                    Icons.document_scanner,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 60),

                  // 🔘 Try Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue.shade100,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Try Now', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ⚪ Help Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/help');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black12),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Help', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerBox(Color color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(100),
        ),
      ),
    );
  }
}
