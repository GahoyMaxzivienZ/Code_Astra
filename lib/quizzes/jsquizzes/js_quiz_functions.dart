import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizFunctions = [
  QuizQuestion(
    id: 'js_functions_q1',
    prompt: 'How do you define a function in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'function myFunction(param) { }'),
      QuizOption(id: 'b', text: 'def myFunction(param):'),
      QuizOption(id: 'c', text: 'void myFunction(param) { }'),
      QuizOption(id: 'd', text: 'func myFunction(param) { }'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript functions start with the "function" keyword, a name, '
        'parentheses for parameters, and a curly-brace body.',
  ),
  QuizQuestion(
    id: 'js_functions_q2',
    prompt: 'Do you need to specify a return type when writing a JavaScript function?',
    options: [
      QuizOption(
        id: 'a',
        text: 'No, return types are never declared in JavaScript',
      ),
      QuizOption(id: 'b', text: 'Yes, always required'),
      QuizOption(id: 'c', text: 'Only for functions with parameters'),
      QuizOption(id: 'd', text: 'Only if it returns a string'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript never requires a return type — the function simply '
        'returns whatever follows the "return" keyword, or nothing at all.',
  ),
  QuizQuestion(
    id: 'js_functions_q3',
    prompt: 'What does function greet(name = "World") { } demonstrate?',
    options: [
      QuizOption(id: 'a', text: 'A default parameter value'),
      QuizOption(id: 'b', text: 'A required parameter'),
      QuizOption(id: 'c', text: 'A syntax error'),
      QuizOption(id: 'd', text: 'A global variable'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'If greet() is called with no argument, name automatically falls '
        'back to "World".',
  ),
];
