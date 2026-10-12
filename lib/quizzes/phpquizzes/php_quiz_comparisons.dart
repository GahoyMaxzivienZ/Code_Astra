import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizComparisons = [
  QuizQuestion(
    id: 'php_comparisons_q1',
    prompt: 'What is the difference between == and === in PHP?',
    options: [
      QuizOption(
        id: 'a',
        text: '== checks value only; === checks value AND type',
      ),
      QuizOption(id: 'b', text: 'There is no difference'),
      QuizOption(id: 'c', text: '=== is just an older syntax for =='),
      QuizOption(id: 'd', text: '== is stricter than ==='),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '== allows type conversion before comparing, while === (strict equality) '
        'requires both the value and the type to match.',
  ),
  QuizQuestion(
    id: 'php_comparisons_q2',
    prompt: 'What does "5" == 5 evaluate to in PHP?',
    options: [
      QuizOption(id: 'a', text: 'true — PHP converts types to compare'),
      QuizOption(id: 'b', text: 'false'),
      QuizOption(id: 'c', text: 'An error'),
      QuizOption(id: 'd', text: 'null'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '== performs type juggling, so the string "5" is converted for '
        'comparison and considered equal to the integer 5.',
  ),
  QuizQuestion(
    id: 'php_comparisons_q3',
    prompt: 'What does "5" === 5 evaluate to in PHP?',
    options: [
      QuizOption(
        id: 'a',
        text: 'false — a string is never identical to an int',
      ),
      QuizOption(id: 'b', text: 'true'),
      QuizOption(id: 'c', text: 'An error'),
      QuizOption(id: 'd', text: 'null'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '=== requires matching types, and a string is never identical to an '
        'integer, regardless of its value.',
  ),
];
