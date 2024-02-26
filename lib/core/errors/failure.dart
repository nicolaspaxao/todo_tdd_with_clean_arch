// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:todo_tdd_clen_arch/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  String get errorMessage => 'Status: $statusCode | Error: $message.';

  @override
  List<Object> get props => [message, statusCode];
}

final class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});

  factory ApiFailure.fromException(ApiException exception) {
    return ApiFailure(
        message: exception.message, statusCode: exception.statusCode);
  }
}
