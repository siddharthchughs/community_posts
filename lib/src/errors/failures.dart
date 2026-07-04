import 'package:equatable/equatable.dart';

abstract interface class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => '${runtimeType.toString()}:$message';
}

class ServerFailure extends Failure {
  const ServerFailure({required message}) : super("Server Failure: $message");
}

class NetworkFailure extends Failure {
  const NetworkFailure({required message}) : super("Network Failure: $message");
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required message}) : super("Not Found: $message");
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({required message})
    : super("Connection Failure: $message");
}

class UnknownFailure extends Failure {
  const UnknownFailure({required message}) : super("Unknown Failure: $message");
}
