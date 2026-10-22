import 'package:flutter_test/flutter_test.dart';
import 'package:sohbet_kutusu/game_data.dart';

void main() {
  test('Dört modun her birinde 32 kart bulunur', () {
    expect(dilemmas.length, 32);
    expect(likelyQuestions.length, 32);
    expect(fiveSecondQuestions.length, 32);
    expect(challengeQuestions.length, 32);
  });

  test('Metin kartları benzersizdir', () {
    expect(likelyQuestions.toSet().length, likelyQuestions.length);
    expect(fiveSecondQuestions.toSet().length, fiveSecondQuestions.length);
    expect(challengeQuestions.toSet().length, challengeQuestions.length);
  });
}
