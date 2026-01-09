import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider pour AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});

/// Provider pour AuthLocalDataSource
final authLocalDataSourceProvider =
    FutureProvider<AuthLocalDataSource>((ref) async {
  final localStorage = await ref.watch(localStorageProvider.future);
  return AuthLocalDataSourceImpl(localStorage: localStorage);
});

/// Provider pour AuthRepository
final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});
