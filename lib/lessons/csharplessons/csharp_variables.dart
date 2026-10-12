import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/csharpquizzes/csharp_quiz_variables.dart';

const Lesson variablesLessonCsharp = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.csharp},
  theory:
      'A VARIABLE is like a "container" with a name, where you store a '
      'value that you can use and change throughout your program.\n\n'
      'In C#, you must declare a TYPE before the variable name, just '
      'like in Java. This is called "static typing" — the compiler checks '
      'that you only ever store the right kind of value in it.\n\n'
      'Common types:\n'
      '• int — whole numbers (e.g. 5, -10, 2024)\n'
      '• double — numbers with decimals (e.g. 3.14, 99.99)\n'
      '• string — text (quoted, e.g. "Hello")\n'
      '• bool — true or false only\n'
      '• char — a single character (e.g. \'A\')\n\n'
      'The syntax is: type name = value;\n\n'
      'Example: int age = 20; — this creates a variable named "age" of '
      'type int with the value 20.\n\n'
      'C# also has the "var" keyword, which lets the compiler infer the '
      'type from the value — var age = 20; still creates an int, just '
      'without you typing it out.',
  codeExample: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        int age = 20;
        double price = 99.99;
        string name = "Juan";
        bool isStudent = true;

        Console.WriteLine(name);
        Console.WriteLine(age);
    }
}''',
  },
  exercisePrompt:
      'Create an int variable named "year" with the value 2024, then '
      'print it using Console.WriteLine().',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        // Create your variable here

    }
}''',
  },
  quiz: csharpQuizVariables,
);
