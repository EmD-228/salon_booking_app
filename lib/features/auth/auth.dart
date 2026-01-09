// Export principal pour la feature auth
// Utiliser: import 'package:salon_app/features/auth/auth.dart';

// Domain
export 'domain/entities/user.dart';
export 'domain/repositories/auth_repository.dart';
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/verify_email_usecase.dart';
export 'domain/usecases/send_otp_usecase.dart';
export 'domain/usecases/forgot_password_usecase.dart';
export 'domain/usecases/change_password_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';

// Data
export 'data/models/user_model.dart';
export 'data/datasources/auth_remote_datasource.dart';
export 'data/datasources/auth_local_datasource.dart';
export 'data/repositories/auth_repository_impl.dart';
export 'data/providers/auth_data_providers.dart';

// Presentation
export 'presentation/providers/auth_providers.dart';

