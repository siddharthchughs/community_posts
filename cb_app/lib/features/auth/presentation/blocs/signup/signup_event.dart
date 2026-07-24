part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

final class SignUpRequest extends SignupEvent {
  const SignUpRequest({
    required this.email,
    required this.username,
    required this.password,
  });
  final String email;
  final String password;
  final String username;

  @override
  List<Object?> get props => [email, username, password];
}
