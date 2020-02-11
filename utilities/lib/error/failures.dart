import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  List<Object> get props => null;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
