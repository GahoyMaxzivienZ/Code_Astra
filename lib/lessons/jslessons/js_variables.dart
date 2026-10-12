import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_variables.dart';

const Lesson variablesLessonJs = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'A VARIABLE is like a "container" with a name, where you store a '
      'value that you can use and change throughout your program.\n\n'
      'In JavaScript, you declare a variable using "let" or "const" — '
      'you do not need to write a TYPE before it. JavaScript figures '
      'out the type automatically based on the value.\n\n'
      '• let — for a variable that may change later\n'
      '• const — for a variable that should never be reassigned\n\n'
      'Common kinds of values:\n'
      '• Number — whole numbers or decimals (e.g. 5, 3.14)\n'
      '• String — text (quoted, e.g. "Hello")\n'
      '• Boolean — true or false only\n\n'
      'The syntax is: let name = value;\n\n'
      'Example: let age = 20; — this creates a variable named "age" '
      'with the value 20, no type needed.',
  codeExample: {
    ProgrammingLanguage.javascript: '''let age = 20;
let price = 99.99;
let name = "Juan";
const isStudent = true;

console.log(name);
console.log(age);''',
  },
  exercisePrompt:
      'Create a variable named "year" with the value 2024, then print '
      'it using console.log().',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.javascript: '''// Create your variable here
''',
  },
  quiz: jsQuizVariables,
);
