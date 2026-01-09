import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/local_storage.dart' as storage;
import '../models/user_model.dart';

/// Data source pour les opérations d'authentification locales (cache)
abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getSavedUser();
  Future<void> clearUser();
  Future<bool> isUserLoggedIn();
  Future<String?> getSavedEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage localStorage;

  AuthLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> saveUser(UserModel user) async {
    // Sauvegarder l'email (utilisé pour identifier l'utilisateur)
    await localStorage.setString(storage.StorageKeys.userEmail, user.email);
    
    // Sauvegarder le nom si disponible
    if (user.name.isNotEmpty) {
      await localStorage.setString(storage.StorageKeys.customerName, user.name);
    }
    
    // Sauvegarder le numéro de téléphone si disponible
    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
      // On peut stocker dans un champ personnalisé si nécessaire
    }
    
    // Marquer comme connecté (via email sauvegardé)
    await localStorage.setString(storage.StorageKeys.userLogin, user.email);
  }

  @override
  Future<UserModel?> getSavedUser() async {
    final email = await getSavedEmail();
    if (email == null) return null;

    final name = localStorage.getString(storage.StorageKeys.customerName) ?? '';
    
    return UserModel(
      email: email,
      name: name,
      phoneNumber: null, // Pas stocké actuellement
    );
  }

  @override
  Future<void> clearUser() async {
    await localStorage.remove(storage.StorageKeys.userEmail);
    await localStorage.remove(storage.StorageKeys.userLogin);
    await localStorage.remove(storage.StorageKeys.userRegister);
    await localStorage.remove(storage.StorageKeys.customerName);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final email = await getSavedEmail();
    return email != null && email.isNotEmpty;
  }

  @override
  Future<String?> getSavedEmail() async {
    // Vérifier d'abord dans 'Login', puis dans 'register'
    final loginEmail = localStorage.getString(storage.StorageKeys.userLogin);
    if (loginEmail != null && loginEmail.isNotEmpty) {
      return loginEmail;
    }
    
    final registerEmail = localStorage.getString(storage.StorageKeys.userRegister);
    if (registerEmail != null && registerEmail.isNotEmpty) {
      return registerEmail;
    }
    
    return localStorage.getString(storage.StorageKeys.userEmail);
  }
}

