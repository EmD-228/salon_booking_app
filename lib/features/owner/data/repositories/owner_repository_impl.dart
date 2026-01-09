import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/owner.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../domain/repositories/owner_repository.dart';
import '../datasources/owner_remote_datasource.dart';

/// Implémentation du repository Owner
/// 
/// Coordonne les appels aux sources de données
/// et convertit les modèles en entités
class OwnerRepositoryImpl implements OwnerRepository {
  final OwnerRemoteDataSource remoteDataSource;

  OwnerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Owner> loginOwner({
    required String id,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final model = await remoteDataSource.loginOwner(
        id: id,
        email: email,
        phoneNumber: phoneNumber,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<List<Booking>> getTodayBookings(String ownerId) async {
    try {
      final models = await remoteDataSource.getTodayBookings(ownerId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}

