import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management_informasi_sayur_petani/login_page.dart';
import 'package:management_informasi_sayur_petani/riwayat_tab.dart'; // Tab Riwayat

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAccountTabActive = true;
  String username = "Loading...";
  String role = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_name') ?? "User";
      role = prefs.getString('user_role') ?? "User";
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  final Color headerBlue = const Color(0xFF86B0D1);
  final Color activeTabColor = const Color(0xFF567B94);
  final Color inactiveTabColor = const Color(0xFFA9C6D9);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.20;
    final double profileSize = 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Container(
              color: headerBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: headerHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                SizedBox(height: (profileSize / 2) + 20),

                // TAB TOGGLE
                Container(
                  width: 300,
                  height: 45,
                  decoration: BoxDecoration(
                    color: inactiveTabColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => isAccountTabActive = true),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isAccountTabActive
                                  ? activeTabColor
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(30),
                                right: Radius.circular(30),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Akun",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => isAccountTabActive = false),
                          child: Container(
                            decoration: BoxDecoration(
                              color: !isAccountTabActive
                                  ? activeTabColor
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(30),
                                right: Radius.circular(30),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Riwayat",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: isAccountTabActive
                        ? _buildAccountContent()
                        : const RiwayatTab(),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: headerHeight - (profileSize / 2),
            left: (screenWidth / 2) - (profileSize / 2),
            child: Container(
              width: profileSize,
              height: profileSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                image: const DecorationImage(
                  image: AssetImage('assets/images/avatar_profile.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountContent() {
    return Column(
      children: [
        _buildProfileItem(Icons.person, "Username", username),
        _buildProfileItem(Icons.work, "Role", role),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _logout,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF86B0D1)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
