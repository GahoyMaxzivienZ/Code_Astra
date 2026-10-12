import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizVariables = [
  QuizQuestion(
    id: 'js_variables_q1',
    prompt:
        'Which of these is a valid way to declare a variable in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'let age = 20;'),
      QuizOption(id: 'b', text: 'int age = 20;'),
      QuizOption(id: 'c', text: r'$age = 20;'),
      QuizOption(id: 'd', text: 'age := 20;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript variables are declared with let, const, or var, and '
        'need no type keyword before the name.',
  ),
  QuizQuestion(
    id: 'js_variables_q2',
    prompt: 'What is the difference between let and const in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'const cannot be reassigned after it is set'),
      QuizOption(id: 'b', text: 'let is only for numbers'),
      QuizOption(id: 'c', text: 'const is only for strings'),
      QuizOption(id: 'd', text: 'There is no difference'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'const creates a variable whose value cannot be reassigned, while '
        'let can be updated later.',
  ),
  QuizQuestion(
    id: 'js_variables_q3',
    prompt:
        'Do you need to specify a type when declaring a JavaScript variable?',
    options: [
      QuizOption(
        id: 'a',
        text: 'No — JavaScript figures out the type automatically',
      ),
      QuizOption(id: 'b', text: 'Yes, always'),
      QuizOption(id: 'c', text: 'Only for numbers'),
      QuizOption(id: 'd', text: 'Only inside functions'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript is dynamically typed — a variable\'s type is determined '
        'by the value assigned to it, and can even change later.',
  ),
];
