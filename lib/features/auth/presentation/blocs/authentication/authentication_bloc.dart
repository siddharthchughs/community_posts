import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../src/auth/auth.dart';
import '../../../../../src/usecase/usecase_interface.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@singleton
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthRepository authRepository,
    required UserLogout logoutUsecase,
  }) : _authRepository = authRepository,
       _userLogout = logoutUsecase,
       super(const AuthenticationState.unknown()) {
    _authStateSubscription = _authRepository.onAuthStateChnaged.listen((
      UserEntity? user,
    ) {
      add(_AuthenticationStatusChanged(user));
    });
    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;
  final UserLogout _userLogout;

  StreamSubscription<UserEntity?>? _authStateSubscription;

  void _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    if (event._user != null) {
      emit(AuthenticationState.authorized(event._user));
    } else {
      emit(const AuthenticationState.unauthorized());
    }
  }

  Future<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _userLogout(const NoParams());
  }

  @disposeMethod
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
