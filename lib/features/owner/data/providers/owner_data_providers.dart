import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/owner_remote_datasource.dart';
import '../repositories/owner_repository_impl.dart';

/// Provider pour la source de données distante des propriétaires
final ownerRemoteDataSourceProvider = Provider<OwnerRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OwnerRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider pour le repository des propriétaires
final ownerRepositoryProvider = Provider<OwnerRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(ownerRemoteDataSourceProvider);
  return OwnerRepositoryImpl(remoteDataSource: remoteDataSource);
});

