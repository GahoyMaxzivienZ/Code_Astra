import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizFunctions = [
  QuizQuestion(
    id: 'python_functions_q1',
    prompt: 'What keyword defines a function in Python?',
    options: [
      QuizOption(id: 'a', text: 'def'),
      QuizOption(id: 'b', text: 'function'),
      QuizOption(id: 'c', text: 'func'),
      QuizOption(id: 'd', text: 'void'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python functions start with "def", followed by a name, parentheses '
        'for parameters, and a colon.',
  ),
  QuizQuestion(
    id: 'python_functions_q2',
    prompt: 'What punctuation follows the parameter list in a Python function definition?',
    options: [
      QuizOption(id: 'a', text: 'A colon :'),
      QuizOption(id: 'b', text: 'A curly brace {'),
      QuizOption(id: 'c', text: 'A semicolon ;'),
      QuizOption(id: 'd', text: 'Nothing'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'def greet(name): ends with a colon, and the function body is the '
        'indented block that follows.',
  ),
  QuizQuestion(
    id: 'python_functions_q3',
    prompt: 'Can a Python function have a default value for a parameter?',
    options: [
      QuizOption(id: 'a', text: 'Yes, e.g. def greet(name="World"):'),
      QuizOption(id: 'b', text: 'No, all parameters are required'),
      QuizOption(id: 'c', text: 'Only for numbers'),
      QuizOption(id: 'd', text: 'Only if declared static'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Default parameter values let you call the function without '
        'supplying that argument — it falls back to the given default.',
  ),
];
