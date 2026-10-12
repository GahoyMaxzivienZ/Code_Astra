import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizArithmetic = [
  QuizQuestion(
    id: 'csharp_arithmetic_q1',
    prompt: 'What is the result of "7 / 2" if both are declared as int in C#?',
    options: [
      QuizOption(id: 'a', text: '3 (int division, no decimal)'),
      QuizOption(id: 'b', text: '3.5'),
      QuizOption(id: 'c', text: '4'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Just like Java, dividing two int values in C# performs integer '
        'division and discards the decimal part.',
  ),
  QuizQuestion(
    id: 'csharp_arithmetic_q2',
    prompt: 'How do you get a decimal result from dividing two integers in C#?',
    options: [
      QuizOption(id: 'a', text: 'Cast at least one operand to double'),
      QuizOption(id: 'b', text: 'Use the // operator'),
      QuizOption(id: 'c', text: 'It happens automatically'),
      QuizOption(id: 'd', text: 'Use the % operator'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Casting, e.g. (double)a / b, forces C# to perform floating-point '
        'division instead of integer division.',
  ),
  QuizQuestion(
    id: 'csharp_arithmetic_q3',
    prompt: 'What does the % operator do in C#?',
    options: [
      QuizOption(id: 'a', text: 'Returns the remainder after division'),
      QuizOption(id: 'b', text: 'Converts a value to a percentage'),
      QuizOption(id: 'c', text: 'Multiplies two numbers'),
      QuizOption(id: 'd', text: 'Rounds a number'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'The modulo operator (%) gives the remainder — e.g. 7 % 2 is 1.',
  ),
];
