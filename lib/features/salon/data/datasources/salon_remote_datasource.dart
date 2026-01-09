import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/salon_model.dart';

/// Interface pour la source de données distante des salons
abstract class SalonRemoteDataSource {
  Future<List<SalonModel>> getNearbySalons();
  Future<List<SalonModel>> searchSalonsByLocation(String searchQuery);
  Future<SalonModel> getSalonDetails(int salonId);
}

/// Implémentation de la source de données distante des salons
class SalonRemoteDataSourceImpl implements SalonRemoteDataSource {
  final ApiClient apiClient;

  SalonRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SalonModel>> getNearbySalons() async {
    try {
      final response = await apiClient.get(ApiEndpoints.nearbySalons);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => SalonModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load nearby salons: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing salons: $e');
    }
  }

  @override
  Future<List<SalonModel>> searchSalonsByLocation(String searchQuery) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.searchLocation,
        data: {'search': searchQuery},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => SalonModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to search salons: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing search results: $e');
    }
  }

  @override
  Future<SalonModel> getSalonDetails(int salonId) async {
    try {
      // Pour l'instant, on récupère tous les salons et on filtre
      // TODO: Créer un endpoint spécifique pour les détails d'un salon
      final salons = await getNearbySalons();
      final salon = salons.firstWhere(
        (s) => s.id == salonId,
        orElse: () => throw Exception('Salon not found'),
      );
      return salon;
    } catch (e) {
      throw Exception('Error getting salon details: $e');
    }
  }
}

