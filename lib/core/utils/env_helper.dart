import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_endpoints.dart';

/// Helper pour initialiser les variables d'environnement
class EnvHelper {
  /// Charge les variables d'environnement depuis le fichier .env
  /// 
  /// Le fichier .env doit être à la racine du projet (pas dans assets)
  /// À appeler dans main() avant runApp()
  static Future<void> load() async {
    try {
      // Charger depuis la racine du projet
      await dotenv.load(fileName: '.env');
      
      // Initialiser les endpoints avec la base URL depuis .env
      final baseUrl = dotenv.env['API_BASE_URL'] ?? ApiEndpoints.baseUrl;
      ApiEndpoints.initialize(baseUrl);
    } catch (e) {
      // Si le fichier .env n'existe pas, utiliser les valeurs par défaut
      print('Warning: .env file not found, using default values. Error: $e');
      ApiEndpoints.initialize(ApiEndpoints.baseUrl);
    }
  }

  /// Obtient une variable d'environnement
  static String? get(String key) => dotenv.env[key];

  /// Obtient une variable d'environnement avec une valeur par défaut
  static String getOrDefault(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }
}

