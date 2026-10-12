import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizVariables = [
  QuizQuestion(
    id: 'python_variables_q1',
    prompt: 'Which of these is a valid Python variable assignment?',
    options: [
      QuizOption(id: 'a', text: 'age = 25'),
      QuizOption(id: 'b', text: 'int age = 25;'),
      QuizOption(id: 'c', text: r'$age = 25'),
      QuizOption(id: 'd', text: 'var age = 25;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python variables need no type keyword, no dollar sign, and no '
        'semicolon — just a name, =, and a value.',
  ),
  QuizQuestion(
    id: 'python_variables_q2',
    prompt: 'Do you need a semicolon at the end of a Python statement?',
    options: [
      QuizOption(id: 'a', text: 'No, semicolons are optional and rarely used'),
      QuizOption(id: 'b', text: 'Yes, always required'),
      QuizOption(id: 'c', text: 'Only for numbers'),
      QuizOption(id: 'd', text: 'Only inside functions'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'A new line ends a Python statement, so semicolons aren\'t needed — '
        'unlike Java, C++, or PHP.',
  ),
  QuizQuestion(
    id: 'python_variables_q3',
    prompt: 'What naming convention is typically used for Python variables?',
    options: [
      QuizOption(id: 'a', text: 'snake_case (e.g., total_score)'),
      QuizOption(id: 'b', text: 'camelCase'),
      QuizOption(id: 'c', text: 'PascalCase'),
      QuizOption(id: 'd', text: 'ALL_CAPS always'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python style (PEP 8) favors snake_case for variable names, unlike '
        'Java\'s camelCase convention.',
  ),
];
