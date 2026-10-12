import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizForLoop = [
  QuizQuestion(
    id: 'python_for_loop_q1',
    prompt: 'What is the typical way to loop 5 times in Python?',
    options: [
      QuizOption(id: 'a', text: 'for i in range(5):'),
      QuizOption(id: 'b', text: 'for (i = 0; i < 5; i++):'),
      QuizOption(id: 'c', text: 'for i = 1 to 5:'),
      QuizOption(id: 'd', text: 'while i in range(5):'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python for loops iterate over a sequence, and range(5) generates '
        'a sequence of 5 numbers to loop through.',
  ),
  QuizQuestion(
    id: 'python_for_loop_q2',
    prompt: 'What does range(5) produce?',
    options: [
      QuizOption(id: 'a', text: 'The numbers 0, 1, 2, 3, 4'),
      QuizOption(id: 'b', text: 'The numbers 1 through 5'),
      QuizOption(id: 'c', text: 'Just the number 5'),
      QuizOption(id: 'd', text: 'A decimal range'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'range(5) starts at 0 by default and stops before 5, producing 5 '
        'values total: 0, 1, 2, 3, 4.',
  ),
  QuizQuestion(
    id: 'python_for_loop_q3',
    prompt: "Unlike Java, C++, or PHP's for loops, what does Python's for loop iterate over?",
    options: [
      QuizOption(id: 'a', text: 'Items in a sequence (like a list or range)'),
      QuizOption(id: 'b', text: 'A fixed counter defined with semicolons'),
      QuizOption(id: 'c', text: 'Nothing — Python always uses while instead'),
      QuizOption(id: 'd', text: 'A boolean expression only'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python\'s for loop is built to walk through a sequence of items, '
        'not to manage a counter with init/condition/increment clauses.',
  ),
];
