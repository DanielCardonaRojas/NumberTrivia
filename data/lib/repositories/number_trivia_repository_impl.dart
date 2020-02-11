import 'package:dartz/dartz.dart';
import 'package:utilities/utilities.dart';
import '../datasources/number_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_datasource.dart';
import 'package:domain/domain.dart';
import 'package:meta/meta.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  // Constructors
  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  // NumberTriviaRepository
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() getConcreteOrRandom) async {
    if (!(await networkInfo.isConnected)) {
      try {
        final cachedNumberTrivia = await localDataSource.getLastNumberTrivia();
        return Right(cachedNumberTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    try {
      final numberTrivia = await getConcreteOrRandom();
      await localDataSource.cacheNumberTrivia(numberTrivia);
      return Right(numberTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
