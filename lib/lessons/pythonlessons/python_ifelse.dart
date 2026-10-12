import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_ifelse.dart';

const Lesson ifElseLessonPython = Lesson(
  id: 'ifelse',
  title: 'If / Else',
  icon: Icons.call_split,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'IF / ELSE statements let your program make decisions and run '
      'different code depending on a condition.\n\n'
      'Python does not use curly braces to mark a block of code — '
      'instead, it uses INDENTATION (consistent spacing). Each line in '
      'the if statement ends with a colon (:), and the lines that '
      'belong to that block are indented underneath it.\n\n'
      'Structure:\n'
      'if condition:\n'
      '    # runs if condition is True\n'
      'elif anotherCondition:\n'
      '    # runs if the first condition is False but this one is True\n'
      'else:\n'
      '    # runs if none of the above are True\n\n'
      'Note that Python uses "elif" — a shortened, one-word keyword '
      'unique to Python.',
  codeExample: {
    ProgrammingLanguage.python: '''age = 20

if age >= 18:
    print("You are an adult.")
elif age >= 13:
    print("You are a teenager.")
else:
    print("You are a child.")''',
  },
  exercisePrompt:
      'Create a variable score = 75. If score is 60 or above, print '
      '"Passed". Otherwise, print "Failed".',
  expectedOutput: 'Passed',
  starterCode: {
    ProgrammingLanguage.python: '''score = 75

# Write your if/else here
''',
  },
  quiz: pythonQuizIfelse,
);
