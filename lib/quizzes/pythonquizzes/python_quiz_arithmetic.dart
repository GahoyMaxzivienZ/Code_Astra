import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizArithmetic = [
  QuizQuestion(
    id: 'python_arithmetic_q1',
    prompt: 'What does 7 / 2 return in Python 3?',
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
        'In Python 3, / always performs "true division" and returns a '
        'float, even when dividing two whole numbers.',
  ),
  QuizQuestion(
    id: 'python_arithmetic_q2',
    prompt: 'What operator does Python use for floor (integer) division?',
    options: [
      QuizOption(id: 'a', text: '//'),
      QuizOption(id: 'b', text: '/'),
      QuizOption(id: 'c', text: 'div'),
      QuizOption(id: 'd', text: r'\'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        '// divides and rounds down to the nearest whole number, e.g. '
        '7 // 2 is 3.',
  ),
  QuizQuestion(
    id: 'python_arithmetic_q3',
    prompt: 'What does ** do in Python?',
    options: [
      QuizOption(id: 'a', text: 'Exponentiation (raises to a power)'),
      QuizOption(id: 'b', text: 'Multiplication'),
      QuizOption(id: 'c', text: 'Floor division'),
      QuizOption(id: 'd', text: 'Modulo'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation: '2 ** 3 means "2 to the power of 3", which equals 8.',
  ),
];
