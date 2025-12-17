import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('StringToUnsignedInt', () {
    test(
      'Should return an int when the string represent and unsigned integer',
      () {
        //arrange
        final str = '123';

        //act

        final result = inputConverter.stringToUnsignedInteger(str);

        //assert
        expect(result, Right(123));
      },
    );

    test('Should return a failure when the string is not an integer', () {
      //arrange
      final str = '1.0';

      //act

      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('Should return a failure when the string is negative integer', () {
      //arrange
      final str = '-123';

      //act

      final result = inputConverter.stringToUnsignedInteger(str);

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
