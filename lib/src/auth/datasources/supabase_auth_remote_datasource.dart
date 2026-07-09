import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../errors.dart';
import '../../constants/app_constants.dart';
import '../auth.dart';

class SupabaseAuthRemoteDatasource implements AuthRemoteDatasource {
  SupabaseAuthRemoteDatasource({required this.supabaseClient});
  final SupabaseClient supabaseClient;

  @override
  Stream<UserModel?> get onAuthStateChnaged {
    return supabaseClient.auth.onAuthStateChange.map((AuthState authState) {
      final user = authState.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }

  @override
  Future<UserModel> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse _response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      final User? user = _response.user;

      if (user == null) {
        throw const AuthenticationException(
          message: 'User not found after login',
        );
      }

      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownFailure(
        message:
            'An unexpected error occurred while logging in: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> userLogout() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownFailure(
        message:
            'An unexpected error occurred while logging out: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> userSignUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final AuthResponse _response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'role': email.contains('admin') ? 'admin' : Role.user,
        },
      );

      final User? user = _response.user;
      if (user == null) {
        throw const AuthenticationException(
          message: 'User not found after signup',
        );
      }
      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(message: e.message);
    } on AuthenticationException {
      rethrow;
    } on SocketException {
      throw const NetworkException();
    } catch (e) {
      throw UnknownFailure(
        message:
            'An unexpected error occurred while signing up: ${e.toString()}',
      );
    }
  }
}
