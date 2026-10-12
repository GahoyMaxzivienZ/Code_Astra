import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/csharpquizzes/csharp_quiz_ifelse.dart';

const Lesson ifElseLessonCsharp = Lesson(
  id: 'ifelse',
  title: 'If / Else',
  icon: Icons.call_split,
  restrictToLanguages: {ProgrammingLanguage.csharp},
  theory:
      'IF / ELSE statements let your program make decisions and run '
      'different code depending on a condition.\n\n'
      'The condition must be wrapped in parentheses, and the body of '
      'each branch is wrapped in curly braces — just like Java and '
      'C++.\n\n'
      'Structure:\n'
      'if (condition) {\n'
      '    // runs if condition is true\n'
      '} else if (anotherCondition) {\n'
      '    // runs if the first condition is false but this one is true\n'
      '} else {\n'
      '    // runs if none of the above are true\n'
      '}',
  codeExample: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        int age = 20;

        if (age >= 18) {
            Console.WriteLine("You are an adult.");
        } else if (age >= 13) {
            Console.WriteLine("You are a teenager.");
        } else {
            Console.WriteLine("You are a child.");
        }
    }
}''',
  },
  exercisePrompt:
      'Create an int variable score = 75. If score is 60 or above, '
      'print "Passed". Otherwise, print "Failed".',
  expectedOutput: 'Passed',
  starterCode: {
    ProgrammingLanguage.csharp: '''using System;

class Program {
    static void Main() {
        int score = 75;

        // Write your if/else here

    }
}''',
  },
  quiz: csharpQuizIfelse,
);
