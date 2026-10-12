import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_arithmetic.dart';

const Lesson arithmeticLessonJs = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'ARITHMETIC OPERATORS let you perform math on numbers in '
      'JavaScript.\n\n'
      '• + — addition (also joins strings together!)\n'
      '• - — subtraction\n'
      '• * — multiplication\n'
      '• / — division (always returns a decimal if needed, since '
      'JavaScript has only one Number type)\n'
      '• % — modulo (gives the remainder after dividing)\n'
      '• ** — exponentiation (raises to a power)\n\n'
      'Be careful with +: if either side is a string, JavaScript '
      'converts the other side to a string too, e.g. "5" + 5 becomes '
      '"55" instead of 10.',
  codeExample: {
    ProgrammingLanguage.javascript: '''let a = 10;
let b = 3;

console.log(a + b);
console.log(a - b);
console.log(a * b);
console.log(a / b);
console.log(a % b);
console.log(a ** 2);''',
  },
  exercisePrompt:
      'Create two variables, a = 15 and b = 4. Print the result of a % '
      'b (the remainder).',
  expectedOutput: '3',
  starterCode: {
    ProgrammingLanguage.javascript:
        '''// Create your variables and print the remainder here
''',
  },
  quiz: jsQuizArithmetic,
);
