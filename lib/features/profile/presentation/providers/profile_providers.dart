import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_image_usecase.dart';
import '../../data/providers/profile_data_providers.dart';

/// Provider pour le repository (interface)
final profileRepositoryInterfaceProvider = Provider<ProfileRepository>((ref) {
  return ref.watch(profileRepositoryProvider);
});

/// Provider pour GetProfileUsecase
final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  final repository = ref.watch(profileRepositoryInterfaceProvider);
  return GetProfileUsecase(repository);
});

/// Provider pour UpdateProfileUsecase
final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.watch(profileRepositoryInterfaceProvider);
  return UpdateProfileUsecase(repository);
});

/// Provider pour UploadImageUsecase
final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  final repository = ref.watch(profileRepositoryInterfaceProvider);
  return UploadImageUsecase(repository);
});

/// Notifier pour gérer l'état du profil utilisateur
class ProfileNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  /// Charge le profil de l'utilisateur
  Future<void> loadProfile(String email) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getProfileUsecaseProvider);
      final user = await usecase(email);
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Met à jour le profil de l'utilisateur
  Future<void> updateProfile({
    required String email,
    String? name,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(updateProfileUsecaseProvider);
      final user = await usecase(
        email: email,
        name: name,
        phoneNumber: phoneNumber,
      );
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Upload une image de profil
  Future<String?> uploadImage({
    required String email,
    required File imageFile,
  }) async {
    try {
      final usecase = ref.read(uploadImageUsecaseProvider);
      final imageUrl = await usecase(
        email: email,
        imageFile: imageFile,
      );
      // Recharger le profil après l'upload
      await loadProfile(email);
      return imageUrl;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  /// Rafraîchit le profil
  Future<void> refresh(String email) async {
    await loadProfile(email);
  }

  /// Réinitialise l'état
  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour le notifier du profil
final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, AsyncValue<User?>>(() {
  return ProfileNotifier();
});

