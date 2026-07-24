import 'package:equatable/equatable.dart';

abstract interface class AppException extends Equatable {
  const AppException({required this.message});

  final String message;

  @override
  String toString() => '${runtimeType.toString()}:$message';
}

class AuthenticationException extends AppException {
  const AuthenticationException({required super.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class DatabaseException extends AppException {
  const DatabaseException({required super.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class PermissionException extends AppException {
  const PermissionException({required super.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class NotFoundException extends AppException {
  const NotFoundException({required super.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class StorageServerException extends AppException {
  const StorageServerException({required super.message});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class NetworkException extends AppException {
  const NetworkException({
    super.message =
        'Network Exception:'
        'Please check your internet connection and try again.',
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UnknownException extends AppException {
  const UnknownException({
    super.message =
        'Unknown Exception:'
        'An unknown error occurred. Please try again.',
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
