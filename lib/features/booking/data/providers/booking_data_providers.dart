import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../datasources/booking_remote_datasource.dart';
import '../repositories/booking_repository_impl.dart';

/// Provider pour la source de données distante des réservations
final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookingRemoteDataSourceImpl(apiClient: apiClient);
});

/// Provider pour le repository des réservations
final bookingRepositoryProvider = Provider<BookingRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(bookingRemoteDataSourceProvider);
  return BookingRepositoryImpl(remoteDataSource: remoteDataSource);
});

