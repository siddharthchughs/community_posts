import 'package:dartz/dartz.dart';

import '../../errors/failures.dart';
import '../../usecase/usecase_interface.dart';
import '../repository/auth_repository.dart';

class UserLogout implements Usecase<void, NoParams> {
  UserLogout({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
