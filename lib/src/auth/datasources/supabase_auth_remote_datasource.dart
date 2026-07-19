import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../errors.dart';
import '../../constants/app_constants.dart';
import '../auth.dart';

String resolveSupabaseAuthErrorMessage(
  String message, {
  required bool forSignup,
}) {
  final normalized = message.toLowerCase();
  final isRateLimit =
      normalized.contains('rate limit') ||
      normalized.contains('too many requests') ||
      normalized.contains('429') ||
      normalized.contains('exceeded');

  if (isRateLimit) {
    if (forSignup) {
      return 'Too many signup attempts. Please wait a few minutes or use another email address.';
    }
    return 'Too many login attempts. Please wait a few minutes and try again.';
  }

  return message;
}

class SupabaseAuthRemoteDatasource implements AuthRemoteDataSource {
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
        data: {'username': username, 'role': Role.user},
      );

      final User? user = _response.user;
      if (user == null) {
        throw const AuthenticationException(
          message: 'User not found after signup',
        );
      }
      return UserModel.fromSupabaseUser(user);
    } on AuthException catch (e) {
      throw AuthenticationException(
        message: resolveSupabaseAuthErrorMessage(e.message, forSignup: true),
      );
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
