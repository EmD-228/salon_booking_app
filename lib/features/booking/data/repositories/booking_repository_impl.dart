import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

/// Implémentation du repository Booking
/// 
/// Coordonne les appels aux sources de données
/// et convertit les modèles en entités
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TimeSlot>> getTimeSlots(int salonId) async {
    try {
      final models = await remoteDataSource.getTimeSlots(salonId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Booking> createBooking({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  }) async {
    try {
      final model = await remoteDataSource.createBooking(
        salonId: salonId,
        customerEmail: customerEmail,
        serviceType: serviceType,
        timeSlot: timeSlot,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<List<Booking>> getBookings(String customerEmail) async {
    try {
      final models = await remoteDataSource.getBookings(customerEmail);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}

