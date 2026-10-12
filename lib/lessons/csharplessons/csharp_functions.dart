import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/csharpquizzes/csharp_quiz_functions.dart';

const Lesson functionsLessonCsharp = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.csharp},
  theory:
      'A FUNCTION (called a "method" in C#) is a reusable block of code '
      'that you can run whenever you need it, instead of rewriting the '
      'same code over and over.\n\n'
      'Structure:\n'
      'static returnType methodName(paramType parameter) {\n'
      '    // code to run\n'
      '    return value;\n'
      '}\n\n'
      'Just like Java, C# methods must declare a return type — use '
      '"void" if the method does not return anything. The "static" '
      'keyword lets Main() call the method directly, without needing to '
      'create an object first.',
  codeExample: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static string Greet(string name) {
        return "Hello, " + name + "!";
    }

    static int Add(int a, int b) {
        return a + b;
    }

    static void Main() {
        Console.WriteLine(Greet("Maria"));
        Console.WriteLine(Add(3, 4));
    }
}''',
  },
  exercisePrompt:
      'Write a method called Square(int n) that returns n multiplied by '
      'itself. Call it with Square(5) and print the result.',
  expectedOutput: '25',
  starterCode: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    // Write your method here

    static void Main() {

    }
}''',
  },
  quiz: csharpQuizFunctions,
);
