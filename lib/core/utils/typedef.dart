import 'package:dartz/dartz.dart';
import 'package:todo_tdd_clen_arch/core/errors/failure.dart';

typedef DataMap = Map<String, dynamic>;
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
