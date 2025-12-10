import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:management_informasi_sayur_petani/home_page.dart';
import 'package:management_informasi_sayur_petani/welcome_screen.dart';

void main() async {
  // 1. Wajib ada jika main() menjadi async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Cek apakah ada data user yang tersimpan
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('user_id');

  // 3. Tentukan halaman awal: Home (jika login) atau Welcome (jika belum)
  Widget startScreen = (userId != null)
      ? const HomePage()
      : const WelcomePage();

  runApp(MyApp(startScreen: startScreen));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mispet App',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      home: startScreen, // Halaman awal dinamis
    );
  }
}
