import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../errors.dart';

abstract interface class Usecase<ReturnType, ParamsType> {
  Future<Either<Failure, ReturnType>> call(ParamsType params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> props() => [];
}
