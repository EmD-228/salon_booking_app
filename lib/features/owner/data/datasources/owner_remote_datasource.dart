import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../booking/data/models/booking_model.dart';
import '../models/owner_model.dart';

/// Interface pour la source de données distante des propriétaires
abstract class OwnerRemoteDataSource {
  Future<OwnerModel> loginOwner({
    required String id,
    required String email,
    required String phoneNumber,
  });
  Future<List<BookingModel>> getTodayBookings(String ownerId);
}

/// Implémentation de la source de données distante des propriétaires
class OwnerRemoteDataSourceImpl implements OwnerRemoteDataSource {
  final ApiClient apiClient;

  OwnerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OwnerModel> loginOwner({
    required String id,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.ownerDetail,
        data: {
          'id': id,
          'email': email,
          'number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData.toString().toLowerCase() == 'error') {
          throw Exception('Invalid owner credentials');
        }
        // L'API retourne une liste avec un seul élément
        final List<dynamic> data = responseData is List ? responseData : [responseData];
        if (data.isEmpty) {
          throw Exception('Owner not found');
        }
        return OwnerModel.fromJson(data[0] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to login owner: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error logging in owner: $e');
    }
  }

  @override
  Future<List<BookingModel>> getTodayBookings(String ownerId) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.todayBookings,
        data: {'id': ownerId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load today bookings: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing today bookings: $e');
    }
  }
}

