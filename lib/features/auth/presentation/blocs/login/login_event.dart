part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginRequested extends LoginEvent {
  LoginRequested({required this.username, required this.password});
  String username;
  String password;

  @override
  List<Object> get props => [username, password];
}
