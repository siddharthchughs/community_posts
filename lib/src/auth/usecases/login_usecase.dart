import 'package:equatable/equatable.dart';
import '../../errors/failures.dart';
import '../../usecase/usecase_interface.dart';
import 'package:dartz/dartz.dart';
import '../repository/auth_repository.dart';

class UserLoginParams extends Equatable {
  const UserLoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> props() => [email, password];
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
