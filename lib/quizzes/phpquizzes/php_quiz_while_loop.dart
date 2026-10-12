import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizWhileLoop = [
  QuizQuestion(
    id: 'php_while_loop_q1',
    prompt: 'What is the correct syntax to start a while loop in PHP?',
    options: [
      QuizOption(id: 'a', text: 'while (\$condition) { }'),
      QuizOption(id: 'b', text: 'while \$condition: '),
      QuizOption(id: 'c', text: 'while (condition) then'),
      QuizOption(id: 'd', text: 'loop while (\$condition)'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP while loops look like Java\'s or C++\'s: a parenthesized '
        'condition followed by a curly-brace body.',
  ),
  QuizQuestion(
    id: 'php_while_loop_q2',
    prompt:
        r'Given "$count = 0; while ($count < 5) { echo $count; }" '
        r'with NO $count++; inside — what happens?',
    options: [
      QuizOption(id: 'a', text: 'An infinite loop'),
      QuizOption(id: 'b', text: 'It runs exactly once'),
      QuizOption(id: 'c', text: 'A syntax error'),
      QuizOption(id: 'd', text: 'The loop is skipped entirely'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'Since $count never changes, the condition $count < 5 stays true '
        'forever, so the loop never stops.',
  ),
  QuizQuestion(
    id: 'php_while_loop_q3',
    prompt: r'What does $i++ do in PHP?',
    options: [
      QuizOption(id: 'a', text: r'Increases $i by 1'),
      QuizOption(id: 'b', text: r'Decreases $i by 1'),
      QuizOption(id: 'c', text: r'Doubles $i'),
      QuizOption(id: 'd', text: 'Has no effect'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'The ++ increment operator adds 1 to the variable, same as in '
        'Java and C++.',
  ),
];
