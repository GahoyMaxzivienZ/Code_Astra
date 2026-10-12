import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_ifelse.dart';

const Lesson ifElseLessonPhp = Lesson(
  id: 'ifelse',
  title: 'If / Else',
  icon: Icons.call_split,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'IF / ELSE statements let your program make decisions and run '
      'different code depending on a condition.\n\n'
      'The condition must be wrapped in parentheses, and the body of '
      'each branch is wrapped in curly braces — just like Java and '
      'C++.\n\n'
      'Structure:\n'
      'if (condition) {\n'
      '    // runs if condition is true\n'
      '} elseif (anotherCondition) {\n'
      '    // runs if the first condition is false but this one is true\n'
      '} else {\n'
      '    // runs if none of the above are true\n'
      '}\n\n'
      'Note that PHP uses "elseif" (one word) as its common style, '
      'though "else if" (two words) also works.',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
$age = 20;

if ($age >= 18) {
    echo "You are an adult.";
} elseif ($age >= 13) {
    echo "You are a teenager.";
} else {
    echo "You are a child.";
}
?>''',
  },
  exercisePrompt:
      r'Create a variable $score = 75. If $score is 60 or above, print '
      '"Passed". Otherwise, print "Failed".',
  expectedOutput: 'Passed',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
$score = 75;

// Write your if/else here

?>''',
  },
  quiz: phpQuizIfelse,
);
