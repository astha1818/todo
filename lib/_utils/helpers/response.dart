import 'package:dartz/dartz.dart';

typedef Response<T> = Either<Failure, T>;

class Failure {
  final int code;
  final Object response;

  Failure({
    required this.code,
    required this.response,
  });
}
