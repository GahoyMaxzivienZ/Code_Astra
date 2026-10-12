import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizArithmetic = [
  QuizQuestion(
    id: 'php_arithmetic_q1',
    prompt: 'What does "echo 7 / 2;" print in PHP?',
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
        'Unlike int/int math in Java, PHP\'s / operator always does true '
        'division and returns a float when the numbers don\'t divide evenly.',
  ),
  QuizQuestion(
    id: 'php_arithmetic_q2',
    prompt: 'What does intdiv(7, 2) return in PHP?',
    options: [
      QuizOption(id: 'a', text: '3'),
      QuizOption(id: 'b', text: '3.5'),
      QuizOption(id: 'c', text: '4'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'intdiv() performs integer division and discards the remainder, giving '
        'you the whole-number result PHP\'s / operator won\'t.',
  ),
  QuizQuestion(
    id: 'php_arithmetic_q3',
    prompt: 'What does the "." (dot) operator do in PHP?',
    options: [
      QuizOption(id: 'a', text: 'Concatenates (joins) strings'),
      QuizOption(id: 'b', text: 'Adds two numbers'),
      QuizOption(id: 'c', text: 'Multiplies two numbers'),
      QuizOption(id: 'd', text: 'Compares two values'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'PHP uses "." for string concatenation, e.g. "Hello, " . $name — '
        'not + like Java or JavaScript.',
  ),
];
