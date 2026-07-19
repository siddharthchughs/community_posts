import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../src/auth/auth.dart';
import '../../../../../src/errors/errors.dart';
import '../../../../../src/utils/auth_states.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required UserLoginUseCase loginUsecase})
    : _loginUseCase = loginUsecase,
      super(const LoadInitialState()) {
    on<LoginRequested>(_onloginRequest);
  }

  final UserLoginUseCase _loginUseCase;

  Future<void> _onloginRequest(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoadProgressState());

    final result = await _loginUseCase(
      UserLoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(LoginFailure(failure: failure)),
      (_) => emit(const LoginSuccess(data: null)),
    );
  }
}
