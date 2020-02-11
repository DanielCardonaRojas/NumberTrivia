import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:utilities/utilities.dart';
import 'package:data/data.dart';
import 'package:http/http.dart' as http;
import '../fixtures/fixture_reader.dart';

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  MockHTTPClient mockHTTPClient;
  NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHTTPClient);
  });

  // Setup Helpers
  void setupMockHttpClientSuccess200() {
    when(mockHTTPClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClientError(int errorCode) {
    when(mockHTTPClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Some server error', errorCode));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 42;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a get request on a url 
    with endpoint being a number and json content-type header''', () async {
      setupMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);
      verify(mockHTTPClient.get(
        'http://numbersapi.com/$tNumber',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('''should return a NumberTrivia when the response is OK
    with endpoint being a number and json content-type header''', () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw server exception when the response is not in the 2XX range',
        () async {
      setupMockHttpClientError(404);
      final call = dataSource.getConcreteNumberTrivia;
      expect(call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a get request on a url 
    with endpoint being a number and json content-type header''', () async {
      setupMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();
      verify(mockHTTPClient.get(
        'http://numbersapi.com/random',
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('''should return a NumberTrivia when the response is OK
    with endpoint being a number and json content-type header''', () async {
      // arrange
      setupMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should throw server exception when the response is not in the 2XX range',
        () async {
      setupMockHttpClientError(404);
      final call = dataSource.getRandomNumberTrivia;
      expect(call(), throwsA(isA<ServerException>()));
    });
  });
}
