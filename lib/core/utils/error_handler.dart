import 'package:dio/dio.dart';

/// Gestion centralisée des erreurs de l'application
class ErrorHandler {
  ErrorHandler._(); // Private constructor

  /// Convertit une exception en message d'erreur lisible
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is FormatException) {
      return 'Erreur de format des données';
    } else if (error is Exception) {
      return error.toString();
    } else {
      return 'Une erreur inattendue s\'est produite';
    }
  }

  /// Gère les erreurs Dio spécifiques
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout de connexion. Vérifiez votre connexion internet.';
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Ressource non trouvée';
        } else if (statusCode == 401) {
          return 'Non autorisé. Veuillez vous reconnecter.';
        } else if (statusCode == 403) {
          return 'Accès interdit';
        } else if (statusCode == 500) {
          return 'Erreur serveur. Veuillez réessayer plus tard.';
        } else {
          return 'Erreur serveur (${statusCode ?? 'inconnu'})';
        }
      
      case DioExceptionType.cancel:
        return 'Requête annulée';
      
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return 'Pas de connexion internet. Vérifiez votre connexion.';
        }
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
      
      default:
        return 'Erreur réseau inconnue';
    }
  }

  /// Vérifie si l'erreur est due à une connexion réseau
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.unknown;
    }
    return false;
  }

  /// Vérifie si l'erreur est une erreur serveur
  static bool isServerError(dynamic error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      return statusCode != null && statusCode >= 500 && statusCode < 600;
    }
    return false;
  }
}

/// Exceptions personnalisées de l'application
class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException(super.message, [super.code]);
}

class NetworkException extends AppException {
  NetworkException(super.message, [super.code]);
}

class ServerException extends AppException {
  ServerException(super.message, [super.code]);
}

