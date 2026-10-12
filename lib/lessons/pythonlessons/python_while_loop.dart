import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_while_loop.dart';

const Lesson whileLoopLessonPython = Lesson(
  id: 'while_loop',
  title: 'While Loop',
  icon: Icons.loop,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'A WHILE LOOP repeats a block of code as long as a condition '
      'stays True.\n\n'
      'Structure:\n'
      'while condition:\n'
      '    # this code repeats\n\n'
      'Every while loop needs something inside it that eventually makes '
      'the condition False — otherwise, you get an INFINITE LOOP that '
      'never stops. Python has no ++ operator, so you increment a '
      'counter using += 1 instead.',
  codeExample: {
    ProgrammingLanguage.python: '''count = 0

while count < 5:
    print(count)
    count += 1''',
  },
  exercisePrompt:
      'Create a variable i = 1. Use a while loop to print numbers 1 '
      'through 5.',
  expectedOutput: '1\n2\n3\n4\n5',
  starterCode: {
    ProgrammingLanguage.python: '''i = 1

# Write your while loop here
''',
  },
  quiz: pythonQuizWhileLoop,
);
