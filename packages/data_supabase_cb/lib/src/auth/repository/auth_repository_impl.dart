import 'dart:async';

import 'package:core/errors.dart';
import 'package:domain/auth.dart';
import 'package:fpdart/fpdart.dart';

import '../auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.authRemoteDatasource});
  final AuthRemoteDataSource authRemoteDatasource;

  @override
  Stream<UserEntity?> get onAuthStateChnaged {
    final controller = StreamController<UserModel?>();
    final subscription = authRemoteDatasource.onAuthStateChnaged.listen(
      (userModel) {
        controller.add(userModel);
      },
      onError: (error) {
        print('Auth Stream Error: $error');
        controller.add(null);
      },
    );

    controller.onCancel = () {
      subscription.cancel();
    };
    return controller.stream;
  }

  @override
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      await authRemoteDatasource.userSignUp(
        email: email,
        password: password,
        username: username,
      );
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'Network error occurred'));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await authRemoteDatasource.userLogin(email: email, password: password);
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'Network error occurred'));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRemoteDatasource.userLogout();
      return const Right(null);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'Network error occurred'));
    } on UnknownException catch (e) {
      return Left(UnknownFailure(message: e.message));
    }
  }
}
