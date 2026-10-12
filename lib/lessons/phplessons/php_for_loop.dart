import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_for_loop.dart';

const Lesson forLoopLessonPhp = Lesson(
  id: 'for_loop',
  title: 'For Loop',
  icon: Icons.repeat,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'A FOR LOOP is useful when you know exactly how many times you '
      'want to repeat something. It packs three parts into one line:\n\n'
      'for (initialization; condition; increment) {\n'
      '    // this code repeats\n'
      '}\n\n'
      '• Initialization — runs once, before the loop starts (e.g. '
      r'$i = 0;)'
      '\n'
      '• Condition — checked before every run; the loop stops once this '
      'is false\n'
      '• Increment — runs after every iteration (e.g. \$i++)\n\n'
      'Example: for (\$i = 0; \$i < 5; \$i++) runs 5 times, with \$i '
      'taking the values 0, 1, 2, 3, 4.',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
for ($i = 0; $i < 5; $i++) {
    echo $i;
}
?>''',
  },
  exercisePrompt: 'Use a for loop to print numbers 1 through 5.',
  expectedOutput: '12345',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
// Write your for loop here

?>''',
  },
  quiz: phpQuizForLoop,
);
