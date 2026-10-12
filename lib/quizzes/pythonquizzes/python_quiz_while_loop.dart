import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizWhileLoop = [
  QuizQuestion(
    id: 'python_while_loop_q1',
    prompt: 'What ends a while loop\'s condition line in Python?',
    options: [
      QuizOption(id: 'a', text: 'A colon :'),
      QuizOption(id: 'b', text: 'A semicolon ;'),
      QuizOption(id: 'c', text: 'A curly brace {'),
      QuizOption(id: 'd', text: 'Nothing'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Like if statements, a while line ends in a colon, followed by an '
        'indented block.',
  ),
  QuizQuestion(
    id: 'python_while_loop_q2',
    prompt:
        'Given "i = 0" then "while i < 5:" with "print(i)" and "i += 1" indented '
        'inside — how many times does this print?',
    options: [
      QuizOption(id: 'a', text: '5 times (0 through 4)'),
      QuizOption(id: 'b', text: '4 times'),
      QuizOption(id: 'c', text: 'Forever'),
      QuizOption(id: 'd', text: '6 times'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'i starts at 0 and the loop stops once i < 5 is false, so it prints '
        '0, 1, 2, 3, 4 — five times.',
  ),
  QuizQuestion(
    id: 'python_while_loop_q3',
    prompt: 'Does Python support the i++ shorthand for incrementing?',
    options: [
      QuizOption(id: 'a', text: 'No — use i += 1 instead'),
      QuizOption(id: 'b', text: 'Yes, identical to Java or C++'),
      QuizOption(id: 'c', text: 'Yes, but only inside loops'),
      QuizOption(id: 'd', text: 'No, you must write i = i - (-1)'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python has no ++ or -- operators; i += 1 is the standard way to '
        'increment a variable.',
  ),
];
