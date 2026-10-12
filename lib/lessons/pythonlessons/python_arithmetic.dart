import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_arithmetic.dart';

const Lesson arithmeticLessonPython = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'ARITHMETIC OPERATORS let you perform math on numbers in '
      'Python.\n\n'
      '• + — addition\n'
      '• - — subtraction\n'
      '• * — multiplication\n'
      '• / — division (always returns a float, even for whole numbers)\n'
      '• // — floor division (divides and rounds down to a whole '
      'number)\n'
      '• % — modulo (gives you the remainder after dividing)\n'
      '• ** — exponentiation (raises to a power)\n\n'
      'Python follows the standard order of operations (PEMDAS) — '
      'multiplication and division happen before addition and '
      'subtraction, unless you use parentheses to change the order.',
  codeExample: {
    ProgrammingLanguage.python: '''a = 10
b = 3

print(a + b)
print(a - b)
print(a * b)
print(a / b)
print(a // b)
print(a % b)
print(a ** 2)''',
  },
  exercisePrompt:
      'Create two variables, a = 15 and b = 4. Print the result of '
      'a % b (the remainder).',
  expectedOutput: '3',
  starterCode: {
    ProgrammingLanguage.python:
        '''# Create your variables and print the remainder here
''',
  },
  quiz: pythonQuizArithmetic,
);
