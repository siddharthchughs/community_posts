part of 'login_bloc.dart';

// sealed class LoginState extends Equatable {
//   const LoginState();

//   @override
//   List<Object> get props => [];
// }

// final class LoginInitial extends LoginState {}

typedef LoginState = SealedAuthStates<Failure, void>;
typedef LoginIntial = LoadInitialState<Failure, void>;
typedef LoginProgress = LoadProgressState<Failure, void>;
typedef LoginSuccess = LoadSuccessState<Failure, void>;
typedef LoginFailure = LoadFailureState<Failure, void>;
