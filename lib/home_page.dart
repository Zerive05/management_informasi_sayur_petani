import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:management_informasi_sayur_petani/api_config.dart';
import 'package:management_informasi_sayur_petani/tambah_artikel_page.dart';
import 'package:management_informasi_sayur_petani/profile_page.dart'; // Navigasi ke Profil
import 'package:management_informasi_sayur_petani/article_page.dart'; // Navigasi ke Detail

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fetch Artikel
  Future<List<dynamic>> _fetchArticles() async {
    try {
      var response = await http.get(Uri.parse(ApiConfig.getArticles));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success']) {
          return json['data'];
        }
      }
    } catch (e) {
      print("Error fetching articles: $e");
    }
    return [];
  }

  final Color headerBlue = const Color(0xFF90BAD6);
  final Color bodyColor = const Color(0xFFF8F9FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahArtikelPage()),
          );
        },
        backgroundColor: headerBlue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER AREA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 15,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: headerBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MIS-PET',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade800,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // MENU NAVIGATION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => setState(() {}), // Refresh Home
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white.withOpacity(0.9),
                          size: 30,
                        ),
                        onPressed: () {
                          // NAVIGASI KE PROFIL
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'ARTIKEL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6DA0C0),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            // LIST ARTIKEL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<dynamic>>(
                future: _fetchArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada artikel.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var article = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // NAVIGASI KE DETAIL ARTIKEL (KIRIM DATA)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticlePage(
                                title: article['title'],
                                content: article['content'],
                                imageUrl: article['image_url'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: _buildArticleCard(
                          imagePath: article['image_url'] ?? '',
                          title: article['title'],
                          description: article['content'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Baca Selengkapnya",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_circle_right,
                      color: Color(0xFF90BAD6),
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
