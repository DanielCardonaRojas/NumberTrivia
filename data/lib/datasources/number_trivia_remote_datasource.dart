import 'dart:convert';

import 'package:utilities/utilities.dart';
import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return _getTrivia('$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getTrivia('random');
  }

  Future<NumberTriviaModel> _getTrivia(String urlPath) async {
    final response = await client.get(
      'http://numbersapi.com/$urlPath',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return NumberTriviaModel.fromJson(json.decode(response.body));
  }
}
