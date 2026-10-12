import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizForLoop = [
  QuizQuestion(
    id: 'php_for_loop_q1',
    prompt:
        r'In "for ($i = 0; $i < 10; $i++) { }", what does the second part do?',
    options: [
      QuizOption(
        id: 'a',
        text: 'It\'s the condition checked before each iteration',
      ),
      QuizOption(id: 'b', text: 'It initializes the loop variable'),
      QuizOption(id: 'c', text: 'It runs after each iteration'),
      QuizOption(id: 'd', text: 'It\'s the loop body'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'The three parts of a PHP for loop are initialization; condition; '
        'increment — the middle part is the condition, checked before every '
        'run.',
  ),
  QuizQuestion(
    id: 'php_for_loop_q2',
    prompt: r'How many times does "for ($i = 0; $i < 5; $i++)" run?',
    options: [
      QuizOption(id: 'a', text: '5 times (0 through 4)'),
      QuizOption(id: 'b', text: '4 times'),
      QuizOption(id: 'c', text: '6 times'),
      QuizOption(id: 'd', text: 'Forever'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'$i starts at 0 and stops once $i < 5 is false, so it runs for '
        r'0, 1, 2, 3, 4 — five times total.',
  ),
  QuizQuestion(
    id: 'php_for_loop_q3',
    prompt: r'Which part of "for ($i = 0; $i < 5; $i++)" runs only once, at the very start?',
    options: [
      QuizOption(id: 'a', text: r'$i = 0 (the initialization)'),
      QuizOption(id: 'b', text: r'$i < 5 (the condition)'),
      QuizOption(id: 'c', text: r'$i++ (the increment)'),
      QuizOption(id: 'd', text: 'The loop body'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'The initialization step runs exactly once, before the loop starts '
        'checking its condition.',
  ),
];
