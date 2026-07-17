import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth.dart';
import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../config/router/app_router.dart';

@module
abstract class RegisterModule {
  @singleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @singleton
  GoRouter router(AuthenticationBloc authBloc) => createRouter(authBloc);

  @LazySingleton(as: AuthRemoteDataSource)
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
