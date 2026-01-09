import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/salon_remote_datasource.dart';
import '../repositories/salon_repository_impl.dart';

/// Provider pour la source de données distante des salons
final salonRemoteDataSourceProvider = Provider<SalonRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SalonRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider pour le repository des salons
final salonRepositoryProvider = Provider<SalonRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(salonRemoteDataSourceProvider);
  return SalonRepositoryImpl(remoteDataSource: remoteDataSource);
});

