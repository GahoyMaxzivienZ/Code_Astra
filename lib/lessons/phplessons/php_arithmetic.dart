import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_arithmetic.dart';

const Lesson arithmeticLessonPhp = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'ARITHMETIC OPERATORS let you perform math on numbers in PHP.\n\n'
      '• + — addition\n'
      '• - — subtraction\n'
      '• * — multiplication\n'
      '• / — division (always returns a float if the result is not a '
      'whole number)\n'
      '• % — modulo (gives you the remainder after dividing)\n'
      '• intdiv() — a function for integer (whole-number) division\n\n'
      'PHP follows the standard order of operations (PEMDAS) — '
      'multiplication and division happen before addition and '
      'subtraction, unless you use parentheses to change the order.\n\n'
      'PHP also has a special operator for joining strings together: '
      'the dot (.) operator, called "concatenation".',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
$a = 10;
$b = 3;

echo $a + $b;
echo $a - $b;
echo $a * $b;
echo $a / $b;
echo $a % $b;
echo intdiv($a, $b);

$greeting = "Hello, " . "World!";
echo $greeting;
?>''',
  },
  exercisePrompt:
      r'Create two variables, $a = 15 and $b = 4. Print the result of '
      r'$a % $b (the remainder).',
  expectedOutput: '3',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
// Create your variables and print the remainder here

?>''',
  },
  quiz: phpQuizArithmetic,
);
