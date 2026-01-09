import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/owner.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../domain/repositories/owner_repository.dart';
import '../../domain/usecases/login_owner_usecase.dart';
import '../../domain/usecases/get_today_bookings_usecase.dart';
import '../../data/providers/owner_data_providers.dart';

/// Provider pour le repository (interface)
final ownerRepositoryInterfaceProvider = Provider<OwnerRepository>((ref) {
  return ref.watch(ownerRepositoryProvider);
});

/// Provider pour LoginOwnerUsecase
final loginOwnerUsecaseProvider = Provider<LoginOwnerUsecase>((ref) {
  final repository = ref.watch(ownerRepositoryInterfaceProvider);
  return LoginOwnerUsecase(repository);
});

/// Provider pour GetTodayBookingsUsecase
final getTodayBookingsUsecaseProvider = Provider<GetTodayBookingsUsecase>((ref) {
  final repository = ref.watch(ownerRepositoryInterfaceProvider);
  return GetTodayBookingsUsecase(repository);
});

/// Notifier pour gérer l'état de connexion du propriétaire
class OwnerNotifier extends Notifier<AsyncValue<Owner?>> {
  @override
  AsyncValue<Owner?> build() {
    return const AsyncValue.data(null);
  }

  /// Connecte un propriétaire
  Future<bool> loginOwner({
    required String id,
    required String email,
    required String phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(loginOwnerUsecaseProvider);
      final owner = await usecase(
        id: id,
        email: email,
        phoneNumber: phoneNumber,
      );
      state = AsyncValue.data(owner);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour le notifier du propriétaire
final ownerNotifierProvider =
    NotifierProvider<OwnerNotifier, AsyncValue<Owner?>>(() {
  return OwnerNotifier();
});

/// Notifier pour gérer l'état des réservations du jour
class TodayBookingsNotifier extends Notifier<AsyncValue<List<Booking>>> {
  @override
  AsyncValue<List<Booking>> build() {
    return const AsyncValue.data([]);
  }

  /// Charge les réservations du jour
  Future<void> loadTodayBookings(String ownerId) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getTodayBookingsUsecaseProvider);
      final bookings = await usecase(ownerId);
      state = AsyncValue.data(bookings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh(String ownerId) async {
    await loadTodayBookings(ownerId);
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider pour le notifier des réservations du jour
final todayBookingsNotifierProvider =
    NotifierProvider<TodayBookingsNotifier, AsyncValue<List<Booking>>>(() {
  return TodayBookingsNotifier();
});

