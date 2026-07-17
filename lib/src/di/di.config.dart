// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../auth.dart' as _i607;
import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart'
    as _i652;
import '../../features/auth/presentation/blocs/login/login_bloc.dart' as _i1018;
import '../../features/auth/presentation/blocs/signup/signup_bloc.dart' as _i41;
import '../auth/auth.dart' as _i727;
import '../auth/usecases/signup_usecase.dart' as _i750;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.singleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i607.AuthRemoteDataSource>(
      () => registerModule.authRemoteDataSource,
    );
    gh.lazySingleton<_i607.AuthRepository>(() => registerModule.authRepository);
    gh.factory<_i607.SignupUsecase>(() => registerModule.signupUsecase);
    gh.factory<_i607.UserLoginUseCase>(() => registerModule.userLoginUsecase);
    gh.factory<_i607.UserLogout>(() => registerModule.logoutUsecase);
    gh.singleton<_i652.AuthenticationBloc>(
      () => _i652.AuthenticationBloc(
        authRepository: gh<_i727.AuthRepository>(),
        logoutUsecase: gh<_i727.UserLogout>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i652.AuthenticationBloc>()),
    );
    gh.factory<_i1018.LoginBloc>(
      () => _i1018.LoginBloc(loginUsecase: gh<_i727.UserLoginUseCase>()),
    );
    gh.factory<_i41.SignupBloc>(
      () => _i41.SignupBloc(signupUsecase: gh<_i750.SignupUsecase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i607.SupabaseAuthRemoteDatasource get authRemoteDataSource =>
      _i607.SupabaseAuthRemoteDatasource(
        supabaseClient: _getIt<_i454.SupabaseClient>(),
      );

  @override
  _i607.AuthRepositoryImpl get authRepository => _i607.AuthRepositoryImpl(
    authRemoteDatasource: _getIt<_i607.AuthRemoteDataSource>(),
  );

  @override
  _i607.SignupUsecase get signupUsecase =>
      _i607.SignupUsecase(repository: _getIt<_i607.AuthRepository>());

  @override
  _i607.UserLoginUseCase get userLoginUsecase =>
      _i607.UserLoginUseCase(repository: _getIt<_i607.AuthRepository>());

  @override
  _i607.UserLogout get logoutUsecase =>
      _i607.UserLogout(repository: _getIt<_i607.AuthRepository>());
}
