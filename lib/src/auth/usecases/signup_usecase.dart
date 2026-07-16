import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../errors/failures.dart';
import '../../usecase/usecase_interface.dart';
import '../repository/auth_repository.dart';

class UserSignupUsecase extends Equatable {
  const UserSignupUsecase({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  @override
  List<Object> props() => [email, password, username];
}

class SignupUsecase implements Usecase<void, UserSignupUsecase> {
  SignupUsecase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(UserSignupUsecase params) {
    return repository.signup(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}
