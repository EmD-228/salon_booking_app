import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/profile_remote_datasource.dart';
import '../repositories/profile_repository_impl.dart';

/// Provider pour la source de données distante du profil
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider pour le repository du profil
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

