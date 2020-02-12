import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:domain/domain.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;

  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumber = 1;
  final testTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for a give number from the repository', () async {
    //Arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber))
        .thenAnswer((_) async => Right(testTrivia));

    //Act
    final result = await useCase(Params(number: testNumber));

    //Assert
    expect(result, Right(testTrivia));

    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
