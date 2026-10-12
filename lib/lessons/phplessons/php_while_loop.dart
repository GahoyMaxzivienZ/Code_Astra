import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_while_loop.dart';

const Lesson whileLoopLessonPhp = Lesson(
  id: 'while_loop',
  title: 'While Loop',
  icon: Icons.loop,
  restrictToLanguages: {ProgrammingLanguage.php},
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
    ProgrammingLanguage.php: r'''<?php
$count = 0;

while ($count < 5) {
    echo $count;
    $count++;
}
?>''',
  },
  exercisePrompt:
      r'Create a variable $i = 1. Use a while loop to print numbers 1 '
      'through 5.',
  expectedOutput: '12345',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
$i = 1;

// Write your while loop here

?>''',
  },
  quiz: phpQuizWhileLoop,
);
