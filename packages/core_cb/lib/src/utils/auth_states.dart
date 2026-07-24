import 'package:equatable/equatable.dart';

sealed class SealedAuthStates<F, T> extends Equatable {
  const SealedAuthStates();

  const factory SealedAuthStates.initial() = LoadInitialState<F, T>;
  const factory SealedAuthStates.loading({T? prevData}) =
      LoadProgressState<F, T>;
  const factory SealedAuthStates.success({required T? data}) =
      LoadSuccessState<F, T>;
  const factory SealedAuthStates.failure({required F failure, T? prevData}) =
      LoadFailureState<F, T>;

  @override
  List<Object?> get props => [];
}

final class LoadInitialState<F, T> extends SealedAuthStates<F, T> {
  const LoadInitialState();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Initial<$F,$T>()';
}

final class LoadProgressState<F, T> extends SealedAuthStates<F, T> {
  const LoadProgressState({this.prevData});

  final T? prevData;

  @override
  List<Object?> get props => [prevData];

  @override
  String toString() => 'Loading<$F,$T>(prevData: $prevData)';
}

final class LoadSuccessState<F, T> extends SealedAuthStates<F, T> {
  const LoadSuccessState({required this.data});

  final T? data;

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Loaded Success <$F,$T>(prevData: $data)';
}

final class LoadFailureState<F, T> extends SealedAuthStates<F, T> {
  const LoadFailureState({required this.failure, this.prevData});

  final F failure;
  final T? prevData;

  @override
  List<Object?> get props => [failure, prevData];
}

extension SealedAuthStatesDataUtil<F, T> on SealedAuthStates<F, T> {
  T? get currentOrPrevioudData {
    return switch (this) {
      LoadSuccessState<F?, T>(data: final data) => data,
      LoadProgressState<F?, T>(prevData: final prevData) => prevData,
      LoadFailureState<F?, T>(prevData: final prevData) => prevData,
      _ => null,
    };
  }

  bool get hasData => currentOrPrevioudData != null;
}
