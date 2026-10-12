import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_ifelse.dart';

const Lesson ifElseLessonJs = Lesson(
  id: 'ifelse',
  title: 'If / Else',
  icon: Icons.call_split,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'IF / ELSE statements let your program make decisions and run '
      'different code depending on a condition.\n\n'
      'The condition must be wrapped in parentheses, and the body of '
      'each branch is wrapped in curly braces — just like Java, C++, '
      'and C#.\n\n'
      'Structure:\n'
      'if (condition) {\n'
      '    // runs if condition is true\n'
      '} else if (anotherCondition) {\n'
      '    // runs if the first condition is false but this one is true\n'
      '} else {\n'
      '    // runs if none of the above are true\n'
      '}',
  codeExample: {
    ProgrammingLanguage.javascript: '''let age = 20;

if (age >= 18) {
    console.log("You are an adult.");
} else if (age >= 13) {
    console.log("You are a teenager.");
} else {
    console.log("You are a child.");
}''',
  },
  exercisePrompt:
      'Create a variable score = 75. If score is 60 or above, print '
      '"Passed". Otherwise, print "Failed".',
  expectedOutput: 'Passed',
  starterCode: {
    ProgrammingLanguage.javascript: '''let score = 75;

// Write your if/else here
''',
  },
  quiz: jsQuizIfelse,
);
