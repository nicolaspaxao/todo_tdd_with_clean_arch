// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  String get errorMessage => 'Status: $statusCode | Error: $message.';

  @override
  List<Object> get props => [message, statusCode];
}

final class APIFailure extends Failure {
  const APIFailure({required super.message, required super.statusCode});
}
