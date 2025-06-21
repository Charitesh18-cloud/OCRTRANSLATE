import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '2_uploadextract.dart';
import 'widgets/language_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isMenuOpen = false;

  final Map<String, Map<String, dynamic>> languages = {
    'English': {'native': 'English', 'color': Colors.blueGrey},
    'Hindi': {'native': 'हिन्दी', 'color': Colors.redAccent},
    'Telugu': {'native': 'తెలుగు', 'color': Colors.deepPurple},
    'Tamil': {'native': 'தமிழ்', 'color': Colors.pink},
    'Kannada': {'native': 'ಕನ್ನಡ', 'color': Colors.indigo},
    'Malayalam': {'native': 'മലയാളം', 'color': Colors.teal},
    'Bengali': {'native': 'বাংলা', 'color': Colors.orange},
    'Marathi': {'native': 'मराठी', 'color': Colors.green},
    'Gujarati': {'native': 'ગુજરાતી', 'color': Colors.brown},
    'Punjabi': {'native': 'ਪੰਜਾਬੀ', 'color': Colors.cyan},
    'Odia': {'native': 'ଓଡ଼ିଆ', 'color': Colors.lightBlue},
    'Assamese': {'native': 'অসমীয়া', 'color': Colors.deepOrange},
    'Urdu': {'native': 'اردو', 'color': Colors.blueGrey},
    'Sanskrit': {'native': 'संस्कृतम्', 'color': Colors.lime},
    'Konkani': {'native': 'कोंकणी', 'color': Colors.purpleAccent},
    'Bodo': {'native': 'बरʼ', 'color': Colors.amber},
    'Maithili': {'native': 'मैथिली', 'color': Colors.lightGreen},
  };

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('guest_mode');
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _navigateToUpload(BuildContext context, String selectedLang) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, _) =>
          UploadExtractScreen(preselectedOcrLanguage: selectedLang),
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(opacity: curved, child: child);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Dashboard Content
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.dashboard, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // What does app do
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What does this app do?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Upload an image or PDF, extract text and translate into any of the 16 Indian languages using OCR & AI translation.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Language Grid
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Choose a language to extract',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.4,
                            children: languages.entries.map((entry) {
                              final lang = entry.key;
                              final data = entry.value;
                              return LanguageCard(
                                outerColor: data['color'],
                                innerColor: data['color'].withOpacity(0.2),
                                nativeText: data['native'],
                                englishText: lang,
                                onTap: () => _navigateToUpload(context, lang),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Toggle Menu Button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => setState(() => isMenuOpen = !isMenuOpen),
                child: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ),

            // Sidebar Menu
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 0,
              right: isMenuOpen ? 0 : -240,
              bottom: 0,
              child: Container(
                width: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dashboard Menu',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => isMenuOpen = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        setState(() => isMenuOpen = false);
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        setState(() => isMenuOpen = false);
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    const Spacer(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Sign Out'),
                      onTap: () => _logout(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
