import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_informasi_sayur_petani/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      resizeToAvoidBottomInset: false,

      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // --- BACKGROUND ATAS ---
            Positioned(
              top: 0,
              left: -10,
              right: 0,
              child: ClipPath(
                clipper: BackgroundClipper(),
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.75,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Image.asset(
                    'assets/images/welcome_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // --- TEKS JUDUL ---
            Positioned(
              top: screenHeight * 0.17,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'SELAMAT\nDATANG',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F3C4A),
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bersama Mis-Pet!\nMulai perjalanan hijau\nAnda!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF5A6C7C),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // --- GAMBAR KARAKTER ---
            Positioned(
              bottom: 90,
              left: -30,
              child: Image.asset(
                'assets/images/petani_cewek.png',
                height: screenHeight * 0.55,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              right: -10,
              child: Image.asset(
                'assets/images/petani_cowok.png',
                height: screenHeight * 0.45,
                fit: BoxFit.contain,
              ),
            ),

            // --- TOMBOL LANJUT (NAVIGASI KE LOGIN) ---
            Positioned(
              bottom: 30,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  // Pindah ke Login Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      const Text(
                        "Lanjut",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF90BAD6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.65, 0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
