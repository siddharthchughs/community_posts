import 'package:equatable/equatable.dart';
import '../../errors/failures.dart';
import '../../usecase/usecase_interface.dart';
import 'package:dartz/dartz.dart';
import '../repository/auth_repository.dart';

class UserLoginUseCase extends Equatable {
  const UserLoginUseCase({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class UserLogin implements Usecase<void, UserLoginUseCase> {
  UserLogin({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(UserLoginUseCase params) {
    return repository.login(email: params.email, password: params.password);
  }
}
