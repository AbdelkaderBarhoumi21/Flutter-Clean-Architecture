part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

//Event should not convert data => only pass data to the bloc
//And UI also should only have event logic and UI and should not hold UI logic like conversion
// int get number => int.parse(numberString);
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  const GetTriviaForConcreteNumber(this.numberString);
  final String numberString;
  @override
  List<Object> get props => [numberString];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
