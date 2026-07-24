part of 'signup_bloc.dart';

// sealed class SignupState extends Equatable {
//   const SignupState();

//   @override
//   List<Object> get props => [];
// }

// final class SignupInitial extends SignupState {}

typedef SignupState = SealedAuthStates<Failure, void>;
typedef SignupIntial = LoadInitialState<Failure, void>;
typedef SignupProgress = LoadProgressState<Failure, void>;
typedef SignupSuccess = LoadSuccessState<Failure, void>;
typedef SignupFailure = LoadFailureState<Failure, void>;
