import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_data_providers.g.dart';

/// Provider pour AuthRemoteDataSource
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
}

/// Provider pour AuthLocalDataSource
@riverpod
Future<AuthLocalDataSource> authLocalDataSource(
    AuthLocalDataSourceRef ref) async {
  final localStorage = await ref.watch(localStorageProvider.future);
  return AuthLocalDataSourceImpl(localStorage: localStorage);
}

/// Provider pour AuthRepository
@riverpod
Future<AuthRepository> authRepository(AuthRepositoryRef ref) async {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}

