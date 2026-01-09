import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../storage/local_storage.dart';

part 'core_providers.g.dart';

/// Provider pour ApiClient (singleton)
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
}

/// Provider pour SharedPreferences
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

/// Provider pour LocalStorage
@riverpod
Future<LocalStorage> localStorage(LocalStorageRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return LocalStorage(prefs);
}

