import 'package:data_supabase/auth.dart';
import 'package:data_supabase/posts.dart';
import 'package:domain/auth.dart';
import 'package:domain/posts.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  //post
  @LazySingleton(as: PostRemoteDataSource)
  SupabasePostremoteDatasource get postRemoteDataSource;

  @LazySingleton(as: PostsRepository)
  PostRepsitoryImpl get postRepsitoryImpl;

  @injectable
  SignupUsecase get signupUsecase;

  @injectable
  UserLoginUseCase get userLoginUsecase;

  @injectable
  UserLogout get logoutUsecase;

  @injectable
  GetPostsUseCase get getPostsUsecases;

  @injectable
  CreatePostUseCase get createPostUsecases;

  @injectable
  UploadPostImageUseCase get uploadImageUsecases;

  @injectable
  GetPostDetailUseCase get getPostDetailUseCase;

  @injectable
  GetPostCommentsUseCase get getPostCommentsUseCase;

  @injectable
  ToggleLikeUseCase get toggleLikeUseCase;

  @injectable
  CreateCommentUseCase get createCommentUseCase;

  @injectable
  DeleteCommentUseCase get deleteCommentUseCase;

  @injectable
  UpdateCommentUseCase get updateCommentUseCase;
}
