import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/csharpquizzes/csharp_quiz_arithmetic.dart';

const Lesson arithmeticLessonCsharp = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate,
  restrictToLanguages: {ProgrammingLanguage.csharp},
  theory:
      'ARITHMETIC OPERATORS let you perform math on numbers in C#.\n\n'
      '• + — addition\n'
      '• - — subtraction\n'
      '• * — multiplication\n'
      '• / — division (int / int truncates the decimal, just like Java)\n'
      '• % — modulo (gives the remainder after dividing)\n\n'
      'To get a decimal result from dividing two integers, cast one of '
      'them to double, e.g. (double)a / b.\n\n'
      'C# follows the standard order of operations (PEMDAS) — '
      'multiplication and division happen before addition and '
      'subtraction, unless you use parentheses to change the order.',
  codeExample: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        int a = 10;
        int b = 3;

        Console.WriteLine(a + b);
        Console.WriteLine(a - b);
        Console.WriteLine(a * b);
        Console.WriteLine(a / b);
        Console.WriteLine(a % b);
        Console.WriteLine((double)a / b);
    }
}''',
  },
  exercisePrompt:
      'Create two int variables, a = 15 and b = 4. Print the result of '
      'a % b (the remainder).',
  expectedOutput: '3',
  starterCode: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        // Create your variables and print the remainder here

    }
}''',
  },
  quiz: csharpQuizArithmetic,
);
