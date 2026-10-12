import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_functions.dart';

const Lesson functionsLessonPhp = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'A FUNCTION is a reusable block of code that you can run whenever '
      'you need it, instead of rewriting the same code over and over.\n\n'
      'Structure:\n'
      'function functionName(\$parameter) {\n'
      '    // code to run\n'
      '    return \$value;\n'
      '}\n\n'
      'PHP functions do not require you to declare a return type — you '
      'can just write "return" followed by whatever value you want to '
      'send back. A PARAMETER is a placeholder for a value that gets '
      'passed in when the function is called.',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
function greet($name) {
    return "Hello, " . $name . "!";
}

function add($a, $b) {
    return $a + $b;
}

echo greet("Maria");
echo add(3, 4);
?>''',
  },
  exercisePrompt:
      r'Write a function called square($n) that returns $n multiplied '
      r'by itself. Call it with square(5) and print the result.',
  expectedOutput: '25',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
// Write your function here

?>''',
  },
  quiz: phpQuizFunctions,
);
