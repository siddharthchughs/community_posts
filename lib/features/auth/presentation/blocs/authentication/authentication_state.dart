part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authorized, unauthorized }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authorized(UserEntity user)
    : this._(status: AuthenticationStatus.authorized, user: user);

  const AuthenticationState.unauthorized()
    : this._(status: AuthenticationStatus.unauthorized);

  final AuthenticationStatus status;
  final UserEntity? user;

  @override
  List<Object?> props() => [status, user];
}
