import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_time_slots_usecase.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../data/providers/booking_data_providers.dart';

/// Provider pour le repository (interface)
final bookingRepositoryInterfaceProvider = Provider<BookingRepository>((ref) {
  return ref.watch(bookingRepositoryProvider);
});

/// Provider pour GetTimeSlotsUsecase
final getTimeSlotsUsecaseProvider = Provider<GetTimeSlotsUsecase>((ref) {
  final repository = ref.watch(bookingRepositoryInterfaceProvider);
  return GetTimeSlotsUsecase(repository);
});

/// Provider pour CreateBookingUsecase
final createBookingUsecaseProvider = Provider<CreateBookingUsecase>((ref) {
  final repository = ref.watch(bookingRepositoryInterfaceProvider);
  return CreateBookingUsecase(repository);
});

/// Provider pour GetBookingsUsecase
final getBookingsUsecaseProvider = Provider<GetBookingsUsecase>((ref) {
  final repository = ref.watch(bookingRepositoryInterfaceProvider);
  return GetBookingsUsecase(repository);
});

/// Notifier pour gérer l'état des créneaux horaires
class TimeSlotsNotifier extends Notifier<AsyncValue<List<TimeSlot>>> {
  @override
  AsyncValue<List<TimeSlot>> build() {
    return const AsyncValue.data([]);
  }

  /// Charge les créneaux horaires pour un salon
  Future<void> loadTimeSlots(int salonId) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getTimeSlotsUsecaseProvider);
      final timeSlots = await usecase(salonId);
      state = AsyncValue.data(timeSlots);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider pour le notifier des créneaux horaires
final timeSlotsNotifierProvider =
    NotifierProvider<TimeSlotsNotifier, AsyncValue<List<TimeSlot>>>(() {
  return TimeSlotsNotifier();
});

/// Notifier pour gérer l'état de création de réservation
class CreateBookingNotifier extends Notifier<AsyncValue<Booking?>> {
  @override
  AsyncValue<Booking?> build() {
    return const AsyncValue.data(null);
  }

  /// Crée une réservation
  Future<bool> createBooking({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  }) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(createBookingUsecaseProvider);
      final booking = await usecase(
        salonId: salonId,
        customerEmail: customerEmail,
        serviceType: serviceType,
        timeSlot: timeSlot,
      );
      state = AsyncValue.data(booking);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour le notifier de création de réservation
final createBookingNotifierProvider =
    NotifierProvider<CreateBookingNotifier, AsyncValue<Booking?>>(() {
  return CreateBookingNotifier();
});

/// Notifier pour gérer l'état des réservations
class BookingsNotifier extends Notifier<AsyncValue<List<Booking>>> {
  @override
  AsyncValue<List<Booking>> build() {
    return const AsyncValue.data([]);
  }

  /// Charge les réservations d'un client
  Future<void> loadBookings(String customerEmail) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getBookingsUsecaseProvider);
      final bookings = await usecase(customerEmail);
      state = AsyncValue.data(bookings);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh(String customerEmail) async {
    await loadBookings(customerEmail);
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider pour le notifier des réservations
final bookingsNotifierProvider =
    NotifierProvider<BookingsNotifier, AsyncValue<List<Booking>>>(() {
  return BookingsNotifier();
});

