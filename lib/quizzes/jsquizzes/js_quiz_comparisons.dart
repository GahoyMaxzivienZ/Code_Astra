import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizComparisons = [
  QuizQuestion(
    id: 'js_comparisons_q1',
    prompt: 'What is the difference between == and === in JavaScript?',
    options: [
      QuizOption(
        id: 'a',
        text: '== converts types before comparing; === does not',
      ),
      QuizOption(id: 'b', text: 'There is no difference'),
      QuizOption(id: 'c', text: '=== is an older, deprecated version of =='),
      QuizOption(id: 'd', text: '== is stricter than ==='),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '=== (strict equality) requires the same value AND type, while == '
        'allows type coercion — the same distinction PHP makes.',
  ),
  QuizQuestion(
    id: 'js_comparisons_q2',
    prompt: 'What does "5" == 5 evaluate to in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'true — JavaScript converts types to compare'),
      QuizOption(id: 'b', text: 'false'),
      QuizOption(id: 'c', text: 'undefined'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '== performs type coercion, so the string "5" is converted and '
        'considered equal to the number 5.',
  ),
  QuizQuestion(
    id: 'js_comparisons_q3',
    prompt: 'What does "5" === 5 evaluate to in JavaScript?',
    options: [
      QuizOption(
        id: 'a',
        text: 'false — a string is never strictly equal to a number',
      ),
      QuizOption(id: 'b', text: 'true'),
      QuizOption(id: 'c', text: 'undefined'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '=== requires matching types, and a string is never identical to a '
        'number regardless of its value.',
  ),
];
