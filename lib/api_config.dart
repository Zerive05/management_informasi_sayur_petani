class ApiConfig {
  // Ganti IP ini jika IP Laptop berubah
  static const String baseUrl = "http://192.168.1.19/api_mispet";

  static const String register = "$baseUrl/register.php";
  static const String login = "$baseUrl/login.php";
  static const String getArticles = "$baseUrl/get_articles.php";

  // Endpoint untuk Upload Artikel
  static const String createArticle = "$baseUrl/create_article.php";
}
