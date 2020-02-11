import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utilities/utilities.dart';
import 'package:domain/domain.dart';
import 'package:number_trivia/features/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('Initial state should be Empty state', () async {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setupMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the inputConverter to validate and convert the string to usinged int',
        () async {
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest('should emit [Error] when the input is invalid',
        build: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: [Empty(), Error(message: INVALID_INPUT_MESSAGE)]);

    test('should get data from the concrete use case', () async {
      setupMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForConcreteNumber(tNumberString));

      await untilCalled(mockGetConcreteNumberTrivia(any));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      setupMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await emitsExactly(bloc, expected);
    });

    test('should emit [Loading, Error] when data is not gotten successfully',
        () async {
      setupMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        isA<Error>(),
      ];
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await emitsExactly(bloc, expected);
    });

    test(
        'should emit [Loading, Error(CacheFailure)] when data is not gotten successfully',
        () async {
      setupMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await emitsExactly(bloc, expected);
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      when(mockGetRandomNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.add(GetTriviaForRandomNumber());

      await untilCalled(mockGetRandomNumberTrivia.call(any));
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      bloc.add(GetTriviaForRandomNumber());
      await emitsExactly(bloc, expected);
    });

    test('should emit [Loading, Error] when data is not gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        isA<Error>(),
      ];
      bloc.add(GetTriviaForRandomNumber());
      await emitsExactly(bloc, expected);
    });

    test(
        'should emit [Loading, Error(CacheFailure)] when data is not gotten successfully',
        () async {
      when(mockGetRandomNumberTrivia.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ];

      bloc.add(GetTriviaForRandomNumber());
      await emitsExactly(bloc, expected);
    });
  });
}
