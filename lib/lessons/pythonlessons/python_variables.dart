import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/pythonquizzes/python_quiz_variables.dart';

const Lesson variablesLessonPython = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.python},
  theory:
      'A VARIABLE is like a "container" with a name, where you store a '
      'value that you can use and change throughout your program.\n\n'
      'In Python, you do not need to write a TYPE or use any special '
      'symbol before a variable name — just write the name, an equals '
      'sign, and the value. Python figures out the type automatically.\n\n'
      'Common kinds of values:\n'
      '• int — whole numbers (e.g. 5, -10, 2024)\n'
      '• float — numbers with decimals (e.g. 3.14, 99.99)\n'
      '• str — text (quoted, e.g. "Hello")\n'
      '• bool — True or False only\n\n'
      'The syntax is: name = value\n\n'
      'Example: age = 20 — this creates a variable named "age" with '
      'the value 20. No semicolon is needed at the end of the line.\n\n'
      'By convention, Python variable names use snake_case (words '
      'separated by underscores), like total_score.',
  codeExample: {
    ProgrammingLanguage.python: '''age = 20
price = 99.99
name = "Juan"
is_student = True

print(name)
print(age)''',
  },
  exercisePrompt:
      'Create a variable named year with the value 2024, '
      'then print it.',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.python: '''# Create your variable here
''',
  },
  quiz: pythonQuizVariables,
);
