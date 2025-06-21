import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return setState(() => _isSigningIn = false);

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() => _isSigningIn = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sign In Failed'),
          content: Text(e.toString()),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  Future<void> _continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🔷 Corner Background Decorations
          Positioned(top: 0, left: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(top: 0, right: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(bottom: 0, left: 0, child: _cornerBox(Colors.lightBlue.shade100)),
          Positioned(bottom: 0, right: 0, child: _cornerBox(Colors.lightBlue.shade100)),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🟦 Highlighted App Heading Box
                  Card(
                    elevation: 3,
                    color: Colors.deepPurple.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text(
                        'A Product By Swecha',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🖼 Swecha Logo
                  Image.asset(
                    'assets/logo.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100),
                  ),
                  const SizedBox(height: 40),

                  // 🔘 Google Sign-In Button
                  ElevatedButton.icon(
                    icon: Image.asset('assets/google_logo.png', height: 24),
                    label: const Text('Sign in with Google'),
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔘 Continue as Guest
                  OutlinedButton(
                    onPressed: _continueAsGuest,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: const Text('Continue as Guest'),
                  ),
                ],
              ),
            ),
          ),

          if (_isSigningIn)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // 🟦 Decorative Corner Box
  Widget _cornerBox(Color color) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(100),
        ),
      ),
    );
  }
}
