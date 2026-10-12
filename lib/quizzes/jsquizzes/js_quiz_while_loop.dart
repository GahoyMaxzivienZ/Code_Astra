import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizWhileLoop = [
  QuizQuestion(
    id: 'js_while_loop_q1',
    prompt: 'What is the correct syntax for a while loop in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'while (condition) { }'),
      QuizOption(id: 'b', text: 'while condition:'),
      QuizOption(id: 'c', text: 'loop while (condition)'),
      QuizOption(id: 'd', text: 'while condition { }'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript while loops use a parenthesized condition and a '
        'curly-brace body.',
  ),
  QuizQuestion(
    id: 'js_while_loop_q2',
    prompt:
        'Given "let count = 0; while (count < 5) { console.log(count); }" '
        'with no count++ inside — what happens?',
    options: [
      QuizOption(id: 'a', text: 'An infinite loop'),
      QuizOption(id: 'b', text: 'It runs once'),
      QuizOption(id: 'c', text: 'A syntax error'),
      QuizOption(id: 'd', text: 'The loop never runs'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Since count never changes, the condition stays true forever, so '
        'the loop never stops.',
  ),
  QuizQuestion(
    id: 'js_while_loop_q3',
    prompt: 'What does count++ do in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'Increases count by 1'),
      QuizOption(id: 'b', text: 'Decreases count by 1'),
      QuizOption(id: 'c', text: 'Doubles count'),
      QuizOption(id: 'd', text: 'Has no effect'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation: 'The ++ increment operator adds 1, same as Java and C#.',
  ),
];
