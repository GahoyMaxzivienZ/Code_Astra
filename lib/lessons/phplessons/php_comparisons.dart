import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_comparisons.dart';

const Lesson comparisonsLessonPhp = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'COMPARISON OPERATORS let you compare two values, and the result '
      'is always either true or false.\n\n'
      '• == — equal to (value only, converts types if needed)\n'
      '• === — identical to (value AND type must match)\n'
      '• != — not equal to\n'
      '• !== — not identical to\n'
      '• > — greater than\n'
      '• < — less than\n'
      '• >= — greater than or equal to\n'
      '• <= — less than or equal to\n\n'
      'PHP has a quirk worth remembering: because == converts types '
      'before comparing, "5" == 5 is true, even though one is a string '
      'and one is a number. If you want a stricter check that also '
      'requires the same type, use === instead.',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
$a = 5;
$b = "5";

var_dump($a == $b);
var_dump($a === $b);
var_dump($a != $b);
var_dump($a > 3);
?>''',
  },
  exercisePrompt:
      r'Create $a = 10 and $b = 20. Print the result of $a < $b using '
      'echo.',
  expectedOutput: '1',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
// Create your variables and print the comparison result here

?>''',
  },
  quiz: phpQuizComparisons,
);
