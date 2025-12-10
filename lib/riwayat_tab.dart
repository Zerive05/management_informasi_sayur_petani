import 'package:flutter/material.dart';
import 'package:management_informasi_sayur_petani/tambah_artikel_page.dart';

class RiwayatTab extends StatelessWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahArtikelPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6572),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 3,
            ),
            child: const Text(
              "Tambah Artikel +",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        const Center(
          child: Text(
            "Riwayat postingan akan muncul di sini (Segera Hadir)",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
