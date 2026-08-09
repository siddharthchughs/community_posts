// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data_supabase/auth.dart' as _i561;
import 'package:data_supabase/posts.dart' as _i230;
import 'package:domain/auth.dart' as _i378;
import 'package:domain/posts.dart' as _i458;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart'
    as _i652;
import '../../features/auth/presentation/blocs/login/login_bloc.dart' as _i1018;
import '../../features/auth/presentation/blocs/signup/signup_bloc.dart' as _i41;
import '../../features/post/presentation/bloc/post/post_bloc.dart' as _i532;
import '../../features/post/presentation/bloc/post_form/post_form_bloc.dart'
    as _i686;
import '../bus/global_event_bus.dart' as _i91;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule(this);
    gh.singleton<_i91.GlobalEventBus>(
      () => _i91.GlobalEventBus(),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i230.PostRemoteDataSource>(
      () => registerModule.postRemoteDataSource,
    );
    gh.lazySingleton<_i561.AuthRemoteDataSource>(
      () => registerModule.authRemoteDataSource,
    );
    gh.lazySingleton<_i458.PostsRepository>(
      () => registerModule.postRepsitoryImpl,
    );
    gh.factory<_i458.GetPostsUsecases>(() => registerModule.getPostsUsecases);
    gh.factory<_i458.UploadPostImageUseCase>(
      () => registerModule.uploadImageUsecases,
    );
    gh.lazySingleton<_i378.AuthRepository>(() => registerModule.authRepository);
    gh.factory<_i378.SignupUsecase>(() => registerModule.signupUsecase);
    gh.factory<_i378.UserLoginUseCase>(() => registerModule.userLoginUsecase);
    gh.factory<_i378.UserLogout>(() => registerModule.logoutUsecase);
    gh.singleton<_i652.AuthenticationBloc>(
      () => _i652.AuthenticationBloc(
        authRepository: gh<_i378.AuthRepository>(),
        logoutUsecase: gh<_i378.UserLogout>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.factory<_i1018.LoginBloc>(
      () => _i1018.LoginBloc(loginUsecase: gh<_i378.UserLoginUseCase>()),
    );
    gh.factory<_i532.PostBloc>(
      () => _i532.PostBloc(
        getPostUseCase: gh<_i458.GetPostsUsecases>(),
        globalEventBus: gh<_i91.GlobalEventBus>(),
      ),
    );
    gh.factory<_i458.CreatePostUseCase>(
      () => registerModule.createPostUsecases,
    );
    gh.factory<_i41.SignupBloc>(
      () => _i41.SignupBloc(signupUsecase: gh<_i378.SignupUsecase>()),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i652.AuthenticationBloc>()),
    );
    gh.factory<_i686.PostFormBloc>(
      () => _i686.PostFormBloc(
        createPostUsecase: gh<_i458.CreatePostUseCase>(),
        uploadImageUsecase: gh<_i458.UploadPostImageUseCase>(),
        globalEventBus: gh<_i91.GlobalEventBus>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {
  _$RegisterModule(this._getIt);

  final _i174.GetIt _getIt;

  @override
  _i230.SupabasePostremoteDatasource get postRemoteDataSource =>
      _i230.SupabasePostremoteDatasource(
        client: _getIt<_i454.SupabaseClient>(),
      );

  @override
  _i561.SupabaseAuthRemoteDatasource get authRemoteDataSource =>
      _i561.SupabaseAuthRemoteDatasource(
        supabaseClient: _getIt<_i454.SupabaseClient>(),
      );

  @override
  _i230.PostRepsitoryImpl get postRepsitoryImpl => _i230.PostRepsitoryImpl(
    postRemoteDataSource: _getIt<_i230.PostRemoteDataSource>(),
  );

  @override
  _i458.GetPostsUsecases get getPostsUsecases =>
      _i458.GetPostsUsecases(postRepository: _getIt<_i458.PostsRepository>());

  @override
  _i458.UploadPostImageUseCase get uploadImageUsecases =>
      _i458.UploadPostImageUseCase(
        postRepository: _getIt<_i458.PostsRepository>(),
      );

  @override
  _i561.AuthRepositoryImpl get authRepository => _i561.AuthRepositoryImpl(
    authRemoteDatasource: _getIt<_i561.AuthRemoteDataSource>(),
  );

  @override
  _i378.SignupUsecase get signupUsecase =>
      _i378.SignupUsecase(repository: _getIt<_i378.AuthRepository>());

  @override
  _i378.UserLoginUseCase get userLoginUsecase =>
      _i378.UserLoginUseCase(repository: _getIt<_i378.AuthRepository>());

  @override
  _i378.UserLogout get logoutUsecase =>
      _i378.UserLogout(repository: _getIt<_i378.AuthRepository>());

  @override
  _i458.CreatePostUseCase get createPostUsecases =>
      _i458.CreatePostUseCase(postReository: _getIt<_i458.PostsRepository>());
}
