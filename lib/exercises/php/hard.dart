import '../../models/exercise.dart';
import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

final List<Exercise> phpHardExercises = [
  const Exercise(
    id: 'php_hard_payroll',
    title: 'Basic Payroll Calculator',
    language: ProgrammingLanguage.php,
    difficulty: ExerciseDifficulty.hard,
    instructions:
        'Gumawa ng simpleng payroll calculator gamit ang mga sumusunod na '
        'values:\n\n'
        '\$hoursWorked = 45\n'
        '\$hourlyRate = 100\n\n'
        'Kung ang \$hoursWorked ay higit sa 40, ang sobrang oras (overtime) '
        'ay babayaran ng 1.5x ang normal rate. Gamitin ang integer '
        'arithmetic lang (walang decimal). I-print ang kabuuang sahod '
        'gamit ang format na:\n\n'
        '"Total Pay: 4750"',
    starterCode: '''<?php
\$hoursWorked = 45;
\$hourlyRate = 100;

// TODO: kwentahin ang regular pay (max 40 hours) at ang
// overtime pay (sobrang oras x rate x 1.5), tapos i-print
// gamit ang format na "Total Pay: <kabuuan>"
?>''',
    expectedOutput: 'Total Pay: 4750',
  ),
];
