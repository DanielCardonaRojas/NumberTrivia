part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => null;
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({@required this.trivia});
  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message});
  @override
  List<Object> get props => [message];
}

extension FailureToErrorState on Failure {
  Error error() {
    String errorMessage;

    switch (this.runtimeType) {
      case ServerFailure:
        errorMessage = SERVER_FAILURE_MESSAGE;
        break;
      case CacheFailure:
        errorMessage = CACHE_FAILURE_MESSAGE;
        break;
      default:
        errorMessage = "Unexpected error";
        break;
    }
    return Error(message: errorMessage);
  }
}
