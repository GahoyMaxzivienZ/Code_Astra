import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_comparisons.dart';

const Lesson comparisonsLessonPython = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'COMPARISON OPERATORS let you compare two values, and the result '
      'is always either True or False.\n\n'
      '• == — equal to\n'
      '• != — not equal to\n'
      '• > — greater than\n'
      '• < — less than\n'
      '• >= — greater than or equal to\n'
      '• <= — less than or equal to\n\n'
      'Unlike PHP, Python does not convert types before comparing with '
      '==, so "5" == 5 is False — a string and an int are simply '
      'different types. Python also supports "chained comparisons", '
      'like 1 < x < 10, which checks both conditions at once.',
  codeExample: {
    ProgrammingLanguage.python: '''a = 5
b = "5"

print(a == b)
print(a != b)
print(a > 3)
print(1 < a < 10)''',
  },
  exercisePrompt: 'Create a = 10 and b = 20. Print the result of a < b.',
  expectedOutput: 'True',
  starterCode: {
    ProgrammingLanguage.python:
        '''# Create your variables and print the comparison result here
''',
  },
  quiz: pythonQuizComparisons,
);
