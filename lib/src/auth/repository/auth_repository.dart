import 'package:dartz/dartz.dart';

import '../../errors/failures.dart';
import '../auth.dart';

abstract interface class AuthRepository {
  Stream<UserEntity?> get onAuthStateChnaged;
  Future<Either<Failure, void>> signup({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}
