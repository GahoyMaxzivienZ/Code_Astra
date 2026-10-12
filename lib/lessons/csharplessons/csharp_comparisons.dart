import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/csharpquizzes/csharp_quiz_comparisons.dart';

const Lesson comparisonsLessonCsharp = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.csharp},
  theory:
      'COMPARISON OPERATORS let you compare two values, and the result '
      'is always either true or false.\n\n'
      '• == — equal to\n'
      '• != — not equal to\n'
      '• > — greater than\n'
      '• < — less than\n'
      '• >= — greater than or equal to\n'
      '• <= — less than or equal to\n\n'
      'Because C# is strongly typed, there is no need for a separate '
      '"strict equality" operator like === in PHP or JavaScript — a '
      'single == already compares both value types safely, since the '
      'compiler will not let you compare mismatched types in the first '
      'place.',
  codeExample: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        int a = 5;
        int b = 3;

        Console.WriteLine(a == b);
        Console.WriteLine(a != b);
        Console.WriteLine(a > b);
        Console.WriteLine(a <= b);
    }
}''',
  },
  exercisePrompt:
      'Create int a = 10 and int b = 20. Print the result of a < b.',
  expectedOutput: 'True',
  starterCode: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        // Create your variables and print the comparison result here

    }
}''',
  },
  quiz: csharpQuizComparisons,
);
