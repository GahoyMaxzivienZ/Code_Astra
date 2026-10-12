import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizForLoop = [
  QuizQuestion(
    id: 'js_for_loop_q1',
    prompt:
        'In "for (let i = 0; i < 10; i++) { }", what does the middle part do?',
    options: [
      QuizOption(
        id: 'a',
        text: "It's the condition checked before each iteration",
      ),
      QuizOption(id: 'b', text: 'It initializes the loop variable'),
      QuizOption(id: 'c', text: 'It runs after each iteration'),
      QuizOption(id: 'd', text: "It's the loop body"),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'A JavaScript for loop has initialization; condition; increment — '
        'the middle part is the condition.',
  ),
  QuizQuestion(
    id: 'js_for_loop_q2',
    prompt: 'How many times does "for (let i = 0; i < 5; i++)" run?',
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
        'i runs from 0 until i < 5 becomes false, giving 0, 1, 2, 3, 4 — '
        'five iterations.',
  ),
  QuizQuestion(
    id: 'js_for_loop_q3',
    prompt: 'Why is "let" preferred over "var" for loop variables in modern JavaScript?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'let keeps the variable scoped to the loop block, avoiding '
            'bugs',
      ),
      QuizOption(id: 'b', text: 'var is not allowed in loops'),
      QuizOption(id: 'c', text: 'let makes the loop run faster'),
      QuizOption(id: 'd', text: 'There is no difference'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'let is block-scoped, so each loop iteration gets its own i, unlike '
        'var which can leak outside the loop and cause confusing bugs.',
  ),
];
