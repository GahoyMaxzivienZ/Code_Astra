import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_functions.dart';

const Lesson functionsLessonPython = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'A FUNCTION is a reusable block of code that you can run whenever '
      'you need it, instead of rewriting the same code over and over.\n\n'
      'Structure:\n'
      'def function_name(parameter):\n'
      '    # code to run\n'
      '    return value\n\n'
      'Python functions start with the "def" keyword, and the line ends '
      'with a colon, just like if statements and loops. You can also '
      'give a parameter a DEFAULT VALUE, so the function still works '
      'even if that argument is not provided when it is called.',
  codeExample: {
    ProgrammingLanguage.python: '''def greet(name="World"):
    return "Hello, " + name + "!"

def add(a, b):
    return a + b

print(greet("Maria"))
print(add(3, 4))''',
  },
  exercisePrompt:
      'Write a function called square(n) that returns n multiplied by '
      'itself. Call it with square(5) and print the result.',
  expectedOutput: '25',
  starterCode: {
    ProgrammingLanguage.python: '''# Write your function here
''',
  },
  quiz: pythonQuizFunctions,
);
