import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../auth/data/models/user_model.dart';

/// Interface pour la source de données distante du profil
abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile(String email);
  Future<UserModel> updateProfile({
    required String email,
    String? name,
    String? phoneNumber,
  });
  Future<String> uploadProfileImage({
    required String email,
    required File imageFile,
  });
}

/// Implémentation de la source de données distante du profil
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getProfile(String email) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.userDetail,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isEmpty) {
          throw Exception('User not found');
        }
        final userData = data[0] as Map<String, dynamic>;
        
        // Mapper les données de l'API vers UserModel
        return UserModel(
          email: userData['email'] as String? ?? email,
          name: userData['name'] as String? ?? '',
          phoneNumber: userData['phoneNumber'] as String?,
          profilePicture: userData['Profile_Picture'] as String?,
          id: userData['id'] as String?,
        );
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error parsing profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String email,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final data = <String, dynamic>{
        'email': email,
      };
      if (name != null) data['name'] = name;
      if (phoneNumber != null) data['phoneNumber'] = phoneNumber;

      final response = await apiClient.post(
        ApiEndpoints.userDetail, // TODO: Créer un endpoint spécifique pour update
        data: data,
      );

      if (response.statusCode == 200) {
        // Pour l'instant, on récupère le profil mis à jour
        return await getProfile(email);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  @override
  Future<String> uploadProfileImage({
    required String email,
    required File imageFile,
  }) async {
    try {
      // Créer un FormData pour l'upload multipart
      final formData = FormData.fromMap({
        'email': email,
        'Profile_Picture': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await apiClient.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        // L'API devrait retourner l'URL de l'image uploadée
        // Pour l'instant, on retourne une URL par défaut
        final responseData = response.data;
        if (responseData is Map && responseData.containsKey('image_url')) {
          return responseData['image_url'] as String;
        }
        // Si l'API ne retourne pas l'URL, on construit une URL par défaut
        return '${ApiEndpoints.imagesBaseUrl}${imageFile.path.split('/').last}';
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}

