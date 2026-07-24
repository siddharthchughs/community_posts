import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/auth_repository.dart';

class UserLogout implements Usecase<void, NoParams> {
  UserLogout({required this.repository});
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
