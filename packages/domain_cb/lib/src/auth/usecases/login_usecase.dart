import 'package:core/errors.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/auth_repository.dart';
import 'package:core/usecase.dart';

class UserLoginParams extends Equatable {
  const UserLoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUseCase implements Usecase<void, UserLoginParams> {
  UserLoginUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(UserLoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
