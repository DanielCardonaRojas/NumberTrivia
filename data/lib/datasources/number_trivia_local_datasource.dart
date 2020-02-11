import 'dart:convert';
import 'package:utilities/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the last cached number trivia when user had internet connection
  /// Throws [CacheException] if no cache data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) {
    final jsonString = json.encode(numberTrivia.toJson());
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final cachedJsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (cachedJsonString == null) {
      throw CacheException();
    }

    final jsonMap = json.decode(cachedJsonString);
    return NumberTriviaModel.fromJson(jsonMap);
  }
}
