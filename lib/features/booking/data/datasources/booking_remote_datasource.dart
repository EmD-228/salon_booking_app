import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/booking_model.dart';
import '../models/time_slot_model.dart';

/// Interface pour la source de données distante des réservations
abstract class BookingRemoteDataSource {
  Future<List<TimeSlotModel>> getTimeSlots(int salonId);
  Future<BookingModel> createBooking({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  });
  Future<List<BookingModel>> getBookings(String customerEmail);
}

/// Implémentation de la source de données distante des réservations
class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TimeSlotModel>> getTimeSlots(int salonId) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.timeSlots,
        data: {'salonid': salonId.toString()},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => TimeSlotModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load time slots: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing time slots: $e');
    }
  }

  @override
  Future<BookingModel> createBooking({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.booking,
        data: {
          'salonid': salonId.toString(),
          'name': customerEmail,
          'time': timeSlot,
          'type': serviceType,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        // L'API retourne 'Success' en cas de succès
        if (responseData.toString().toLowerCase() == 'success') {
          // Pour l'instant, on retourne un BookingModel basique
          // TODO: L'API devrait retourner les détails de la réservation créée
          return BookingModel(
            salonId: salonId,
            salonName: '', // Sera rempli après
            salonAddress: '',
            salonPhone: '',
            salonEmail: '',
            customerEmail: customerEmail,
            serviceType: serviceType,
            startTime: timeSlot,
            endTime: '', // Sera rempli après
          );
        } else {
          throw Exception('Booking failed: ${responseData.toString()}');
        }
      } else {
        throw Exception('Failed to create booking: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  @override
  Future<List<BookingModel>> getBookings(String customerEmail) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.checkBooking,
        data: {'email': customerEmail},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing bookings: $e');
    }
  }
}

