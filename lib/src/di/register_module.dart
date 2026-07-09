import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth.dart';

@module
abstract class RegisterModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @LazySingleton(as: AuthRemoteDatasource)
  SupabaseAuthRemoteDatasource get authRemoteDataSource;

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository;

  @injectable
  SignupUsecase get signupUsecase;

  @injectable
  UserLoginUseCase get userLoginUsecase;

  @injectable
  UserLogout get logoutUsecase;
}
