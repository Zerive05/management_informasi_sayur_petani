import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:management_informasi_sayur_petani/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // UBAH: Jadi Email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color primaryBlue = const Color(0xFF7CA4C6);
  final Color textBlue = const Color(0xFF4A8BAD);

  // FUNGSI REGISTER KE API
  Future<void> _register() async {
    // 1. Validasi Input
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua kolom wajib diisi!")));
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password tidak sama!")));
      return;
    }

    // 2. Kirim Request
    try {
      var response = await http.post(
        Uri.parse(ApiConfig.register),
        body: {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      var data = jsonDecode(response.body);

      if (data['success']) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: Text(data['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke Login
                },
                child: const Text("OK"),
              ),
            ],
          ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Daftar Akun",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/images/mispet_logo.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 30),

              _buildLabeledInput(
                label: "Username",
                hintText: "Username",
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              // UBAH LABEL & KEYBOARD TYPE
              _buildLabeledInput(
                label: "Email",
                hintText: "contoh@email.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              _buildLabeledInput(
                label: "Password",
                hintText: "******",
                controller: _passwordController,
                isPassword: true,
                isObscured: !_isPasswordVisible,
                onIconTap: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              const SizedBox(height: 20),

              _buildLabeledInput(
                label: "Verifikasi Password",
                hintText: "******",
                controller: _confirmPasswordController,
                isPassword: true,
                isObscured: !_isConfirmPasswordVisible,
                onIconTap: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                  onPressed: _register, // PANGGIL FUNGSI
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onIconTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: textBlue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscured,
          keyboardType: keyboardType,
          style: TextStyle(color: textBlue),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: textBlue.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: textBlue.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: textBlue, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                      color: textBlue.withOpacity(0.7),
                    ),
                    onPressed: onIconTap,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
