import 'package:bloc/bloc.dart';
import 'package:core/errors.dart';
import 'package:core/utils.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

@injectable
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required SignupUsecase signupUsecase})
    : _signupUsecase = signupUsecase,
      super(const SignupIntial()) {
    on<SignUpRequest>(_onSignupRequest);
  }

  final SignupUsecase _signupUsecase;

  Future<void> _onSignupRequest(
    SignUpRequest event,
    Emitter<SignupState> emit,
  ) async {
    emit(const SignupProgress());
    final result = await _signupUsecase(
      UserSignupParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(SignupFailure(failure: failure)),
      (_) => emit(const SignupSuccess(data: null)),
    );
  }
}
