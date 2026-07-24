import 'package:core/errors.dart';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

abstract interface class Usecase<ReturnType, ParamsType> {
  Future<Either<Failure, ReturnType>> call(ParamsType params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
