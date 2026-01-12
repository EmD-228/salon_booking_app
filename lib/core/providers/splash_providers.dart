import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/owner/presentation/providers/owner_providers.dart';
import '../storage/local_storage.dart';
import 'core_providers.dart';

/// État de connexion au démarrage
enum SplashConnectionState {
  checking,
  connected,
  disconnected,
}

/// État de l'utilisateur au démarrage
enum SplashUserState {
  checking,
  customerLoggedIn,
  ownerLoggedIn,
  notLoggedIn,
}

/// Notifier pour gérer l'état du splash screen
class SplashNotifier extends Notifier<AsyncValue<SplashUserState>> {
  @override
  AsyncValue<SplashUserState> build() {
    _checkInitialState();
    return const AsyncValue.loading();
  }

  /// Vérifie l'état initial de l'application (connexion et authentification)
  Future<void> _checkInitialState() async {
    state = const AsyncValue.loading();

    try {
      // Vérifier la connexion internet
      final hasConnection = await _checkInternetConnection();
      if (!hasConnection) {
        state = AsyncValue.error(
          Exception('No internet connection'),
          StackTrace.current,
        );
        return;
      }

      // Vérifier si un utilisateur client est connecté
      final sharedPrefs = await ref.read(sharedPreferencesProvider.future);
      final localStorage = LocalStorage(sharedPrefs);
      final customerEmail = localStorage.getString('register') ?? 
                           localStorage.getString('Login');
      
      if (customerEmail != null && customerEmail.isNotEmpty) {
        // Charger les données du salon si nécessaire
        await _loadSalonData();
        state = AsyncValue.data(SplashUserState.customerLoggedIn);
        return;
      }

      // Vérifier si un propriétaire est connecté
      final ownerId = localStorage.getString('id');
      final ownerEmail = localStorage.getString('email_owner');
      final ownerPhone = localStorage.getString('num');

      if (ownerId != null && ownerEmail != null && ownerPhone != null) {
        // Tenter de se reconnecter automatiquement
        final success = await ref.read(ownerNotifierProvider.notifier).loginOwner(
              id: ownerId,
              email: ownerEmail,
              phoneNumber: ownerPhone,
            );
        
        if (success) {
          await _loadOwnerData(ownerId);
          state = AsyncValue.data(SplashUserState.ownerLoggedIn);
          return;
        }
      }

      // Aucun utilisateur connecté
      state = AsyncValue.data(SplashUserState.notLoggedIn);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Vérifie la connexion internet
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  /// Charge les données des salons
  Future<void> _loadSalonData() async {
    try {
      // Les données des salons seront chargées automatiquement par le provider
      // lors de l'accès à l'écran d'accueil
    } catch (e) {
      // Ignorer les erreurs silencieusement
    }
  }

  /// Charge les données du propriétaire
  Future<void> _loadOwnerData(String ownerId) async {
    try {
      await ref.read(todayBookingsNotifierProvider.notifier).loadTodayBookings(ownerId);
    } catch (e) {
      // Ignorer les erreurs silencieusement
    }
  }

  /// Rafraîchit l'état
  Future<void> refresh() async {
    await _checkInitialState();
  }
}

/// Provider pour le notifier du splash screen
final splashNotifierProvider =
    NotifierProvider<SplashNotifier, AsyncValue<SplashUserState>>(() {
  return SplashNotifier();
});

