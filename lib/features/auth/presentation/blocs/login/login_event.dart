part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> props() => [];
}

final class LoginRequested extends LoginEvent {
  const LoginRequested({required this.username, required this.password});
  final String username;
  final String password;

  @override
  List<Object?> props() => [username, password];
}
