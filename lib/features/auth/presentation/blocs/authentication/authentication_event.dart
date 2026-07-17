part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> props() => [];
}

final class _AuthenticationStatusChanged extends AuthenticationEvent {
  const _AuthenticationStatusChanged(this._user);
  final UserEntity? _user;

  @override
  List<Object?> props() => [_user];
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}
