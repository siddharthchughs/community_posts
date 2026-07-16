import '../auth.dart';

abstract interface class AuthRemoteDataSource {
  Stream<UserModel?> get onAuthStateChnaged;
  Future<UserModel> userSignUp({
    required String email,
    required String password,
    required String username,
  });

  Future<UserModel> userLogin({
    required String email,
    required String password,
  });
  Future<void> userLogout();
}
