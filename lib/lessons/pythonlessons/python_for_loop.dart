import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_for_loop.dart';

const Lesson forLoopLessonPython = Lesson(
  id: 'for_loop',
  title: 'For Loop',
  icon: Icons.repeat,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'Unlike Java, C++, or PHP, a Python FOR LOOP does not use an '
      'initialization/condition/increment setup. Instead, it iterates '
      'directly over the items in a sequence.\n\n'
      'Structure:\n'
      'for variable in sequence:\n'
      '    # this code repeats for each item\n\n'
      'The range() function is commonly used to generate a sequence of '
      'numbers. range(5) produces 0, 1, 2, 3, 4 — it starts at 0 by '
      'default and stops right before the number you give it.',
  codeExample: {
    ProgrammingLanguage.python: '''for i in range(5):
    print(i)''',
  },
  exercisePrompt:
      'Use a for loop with range() to print numbers 1 '
      'through 5.',
  expectedOutput: '1\n2\n3\n4\n5',
  starterCode: {
    ProgrammingLanguage.python: '''# Write your for loop here
''',
  },
  quiz: pythonQuizForLoop,
);
