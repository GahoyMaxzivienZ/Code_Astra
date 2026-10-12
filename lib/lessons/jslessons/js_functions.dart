import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_functions.dart';

const Lesson functionsLessonJs = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'A FUNCTION is a reusable block of code that you can run whenever '
      'you need it, instead of rewriting the same code over and over.\n\n'
      'Structure:\n'
      'function functionName(parameter) {\n'
      '    // code to run\n'
      '    return value;\n'
      '}\n\n'
      'JavaScript functions never require a return type. A PARAMETER can '
      'even have a DEFAULT VALUE, so the function still works if that '
      'argument is not provided when it is called, e.g. '
      'function greet(name = "World").',
  codeExample: {
    ProgrammingLanguage.javascript: '''function greet(name = "World") {
    return "Hello, " + name + "!";
}

function add(a, b) {
    return a + b;
}

console.log(greet("Maria"));
console.log(add(3, 4));''',
  },
  exercisePrompt:
      'Write a function called square(n) that returns n multiplied by '
      'itself. Call it with square(5) and print the result.',
  expectedOutput: '25',
  starterCode: {
    ProgrammingLanguage.javascript: '''// Write your function here
''',
  },
  quiz: jsQuizFunctions,
);
