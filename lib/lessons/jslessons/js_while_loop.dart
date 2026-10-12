import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_while_loop.dart';

const Lesson whileLoopLessonJs = Lesson(
  id: 'while_loop',
  title: 'While Loop',
  icon: Icons.loop,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'A WHILE LOOP repeats a block of code as long as a condition '
      'stays true.\n\n'
      'Structure:\n'
      'while (condition) {\n'
      '    // this code repeats\n'
      '}\n\n'
      'Every while loop needs something inside it that eventually makes '
      'the condition false — otherwise, you get an INFINITE LOOP that '
      'never stops. This is usually done by incrementing a counter '
      'variable using the ++ operator.',
  codeExample: {
    ProgrammingLanguage.javascript: '''let count = 0;

while (count < 5) {
    console.log(count);
    count++;
}''',
  },
  exercisePrompt:
      'Create a variable i = 1. Use a while loop to print numbers 1 '
      'through 5.',
  expectedOutput: '1\n2\n3\n4\n5',
  starterCode: {
    ProgrammingLanguage.javascript: '''let i = 1;

// Write your while loop here
''',
  },
  quiz: jsQuizWhileLoop,
);
