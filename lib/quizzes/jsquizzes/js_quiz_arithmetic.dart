import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizArithmetic = [
  QuizQuestion(
    id: 'js_arithmetic_q1',
    prompt: 'What does "7 / 2" return in JavaScript?',
    options: [
      QuizOption(id: 'a', text: '3.5'),
      QuizOption(id: 'b', text: '3'),
      QuizOption(id: 'c', text: '4'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript has no separate integer type, so / always performs '
        'true division and can return a decimal.',
  ),
  QuizQuestion(
    id: 'js_arithmetic_q2',
    prompt: 'What does "5" + 5 evaluate to in JavaScript?',
    options: [
      QuizOption(id: 'a', text: '"55" (the number gets converted to a string)'),
      QuizOption(id: 'b', text: '10'),
      QuizOption(id: 'c', text: 'An error'),
      QuizOption(id: 'd', text: 'undefined'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'When + is used with a string and a number, JavaScript converts '
        'the number to a string and concatenates them instead of adding.',
  ),
  QuizQuestion(
    id: 'js_arithmetic_q3',
    prompt: 'What does the ** operator do in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'Exponentiation (raises to a power)'),
      QuizOption(id: 'b', text: 'Multiplication'),
      QuizOption(id: 'c', text: 'Modulo'),
      QuizOption(id: 'd', text: 'Floor division'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation: '2 ** 3 means "2 to the power of 3", which equals 8.',
  ),
];
