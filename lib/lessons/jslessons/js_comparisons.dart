import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/jsquizzes/js_quiz_comparisons.dart';

const Lesson comparisonsLessonJs = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.javascript},
  theory:
      'COMPARISON OPERATORS let you compare two values, and the result '
      'is always either true or false.\n\n'
      '• == — equal to (value only, converts types if needed)\n'
      '• === — strictly equal to (value AND type must match)\n'
      '• != — not equal to\n'
      '• !== — not strictly equal to\n'
      '• > — greater than\n'
      '• < — less than\n'
      '• >= — greater than or equal to\n'
      '• <= — less than or equal to\n\n'
      'Just like PHP, JavaScript\'s == converts types before comparing, so '
      '"5" == 5 is true. If you want a stricter check that also requires '
      'matching types, use === instead — this is considered best practice '
      'in JavaScript.',
  codeExample: {
    ProgrammingLanguage.javascript: '''let a = 5;
let b = "5";

console.log(a == b);
console.log(a === b);
console.log(a != b);
console.log(a > 3);''',
  },
  exercisePrompt: 'Create a = 10 and b = 20. Print the result of a < b.',
  expectedOutput: 'true',
  starterCode: {
    ProgrammingLanguage.javascript:
        '''// Create your variables and print the comparison result here
''',
  },
  quiz: jsQuizComparisons,
);
