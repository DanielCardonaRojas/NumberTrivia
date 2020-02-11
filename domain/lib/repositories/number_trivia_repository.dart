import 'package:dartz/dartz.dart';
import 'package:domain/entities/number_trivia.dart';
import 'package:utilities/utilities.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
