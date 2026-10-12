import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/phpquizzes/php_quiz_variables.dart';

const Lesson variablesLessonPhp = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.php},
  theory:
      'A VARIABLE is like a "container" with a name, where you store a '
      'value that you can use and change throughout your program.\n\n'
      'In PHP, every variable name must start with a dollar sign (\$). '
      'You do not need to write a TYPE before it — PHP automatically '
      'figures out what kind of data you are storing. This is called '
      '"loose typing".\n\n'
      'Common kinds of values:\n'
      '• Integer — whole numbers (e.g. 5, -10, 2024)\n'
      '• Float — numbers with decimals (e.g. 3.14, 99.99)\n'
      '• String — text (always quoted, e.g. "Hello")\n'
      '• Boolean — true or false only\n\n'
      'The syntax is: \$name = value;\n\n'
      'Example: \$age = 20; — this creates a variable named "age" with '
      'the value 20, no type needed.',
  codeExample: {
    ProgrammingLanguage.php: r'''<?php
$age = 20;
$price = 99.99;
$name = "Juan";
$isStudent = true;

echo $name;
echo $age;
?>''',
  },
  exercisePrompt:
      r'Create a variable named $year with the value 2024, then print it '
      'using echo.',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.php: r'''<?php
// Create your variable here

?>''',
  },
  quiz: phpQuizVariables,
);
