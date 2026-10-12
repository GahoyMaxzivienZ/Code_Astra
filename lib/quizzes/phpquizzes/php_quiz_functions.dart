import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizFunctions = [
  QuizQuestion(
    id: 'php_functions_q1',
    prompt: 'How do you define a function in PHP?',
    options: [
      QuizOption(id: 'a', text: r'function myFunction($param) { }'),
      QuizOption(id: 'b', text: r'def myFunction($param):'),
      QuizOption(id: 'c', text: r'void myFunction($param) { }'),
      QuizOption(id: 'd', text: r'func myFunction($param) { }'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP functions start with the "function" keyword, followed by a '
        'name, parentheses for parameters, and a curly-brace body.',
  ),
  QuizQuestion(
    id: 'php_functions_q2',
    prompt: 'Do you need to specify a return type when writing a PHP function?',
    options: [
      QuizOption(id: 'a', text: 'No, return types are optional in PHP'),
      QuizOption(id: 'b', text: 'Yes, always required'),
      QuizOption(id: 'c', text: 'Only for functions with parameters'),
      QuizOption(id: 'd', text: 'Only if it returns a string'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP lets you write functions without declaring a return type, '
        'unlike Java where every method needs one (or void).',
  ),
  QuizQuestion(
    id: 'php_functions_q3',
    prompt: r'What is $param in "function greet($param) { }"?',
    options: [
      QuizOption(
        id: 'a',
        text: 'A parameter — a placeholder for the value passed in',
      ),
      QuizOption(id: 'b', text: 'A global variable'),
      QuizOption(id: 'c', text: 'A return value'),
      QuizOption(id: 'd', text: 'A constant'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r"$param holds whatever value is passed into greet() when it's "
        'called, e.g. greet("Maria").',
  ),
];
