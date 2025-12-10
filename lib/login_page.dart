import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management_informasi_sayur_petani/api_config.dart';
import 'package:management_informasi_sayur_petani/home_page.dart';
import 'package:management_informasi_sayur_petani/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final Color mainBlueColor = const Color(0xFF7BA4C4);
  final Color darkBlueTextColor = const Color(0xFF1F4E79);

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password harus diisi")),
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(ApiConfig.login),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      var data = jsonDecode(response.body);

      if (data['success']) {
        // 1. Simpan Sesi
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', data['data']['id'].toString());
        await prefs.setString('user_name', data['data']['username']);
        await prefs.setString('user_role', data['data']['role']);

        if (!mounted) return;
        // 2. Pindah ke Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainBlueColor,
      body: Stack(
        children: [
          Positioned(
            top: -90,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login_bg_top.png',
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/mispet_logo.png',
                          height: screenHeight * 0.15,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'MIS-PET',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkBlueTextColor,
                          ),
                        ),
                        Text(
                          'Manajemen Informasi Sayur dan Petani',
                          style: TextStyle(
                            fontSize: 12,
                            color: darkBlueTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: darkBlueTextColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.10),

                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hintText: 'contoh@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Password',
                    obscureText: !_isPasswordVisible,
                    isPasswordField: true,
                    onVisibilityToggle: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: mainBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Klik disini',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    bool isPasswordField = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Icon(icon, color: mainBlueColor, size: 28),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                  suffixIcon: isPasswordField
                      ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: onVisibilityToggle,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
