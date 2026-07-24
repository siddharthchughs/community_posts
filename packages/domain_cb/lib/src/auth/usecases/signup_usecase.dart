import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/auth_repository.dart';

class UserSignupParams extends Equatable {
  const UserSignupParams({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  @override
  List<Object> get props => [username, email, password];
}

class SignupUsecase implements Usecase<void, UserSignupParams> {
  SignupUsecase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(UserSignupParams params) async {
    return await repository.signup(
      email: params.email,
      password: params.password,
      username: params.username,
    );
  }
}
