import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salon_repository.dart';
import '../datasources/salon_remote_datasource.dart';

/// Implémentation du repository Salon
/// 
/// Coordonne les appels aux différentes sources de données
/// et convertit les modèles en entités
class SalonRepositoryImpl implements SalonRepository {
  final SalonRemoteDataSource remoteDataSource;

  SalonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Salon>> getNearbySalons() async {
    try {
      final models = await remoteDataSource.getNearbySalons();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<List<Salon>> searchSalonsByLocation(String searchQuery) async {
    try {
      final models = await remoteDataSource.searchSalonsByLocation(searchQuery);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<Salon> getSalonDetails(int salonId) async {
    try {
      final model = await remoteDataSource.getSalonDetails(salonId);
      return model.toEntity();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}

