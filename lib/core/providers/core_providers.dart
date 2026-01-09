import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

/// Provider pour ApiClient (singleton)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider pour SharedPreferences
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider pour LocalStorage
final localStorageProvider = FutureProvider<LocalStorage>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return LocalStorage(prefs);
});
