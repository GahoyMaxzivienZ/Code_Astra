import '../../models/exercise.dart';
import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

final List<Exercise> phpMediumExercises = [
  const Exercise(
    id: 'php_medium_multiplication_table',
    title: 'Multiplication Table',
    language: ProgrammingLanguage.php,
    difficulty: ExerciseDifficulty.medium,
    instructions:
        'Gumamit ng loop para i-print ang multiplication table ng 5, mula '
        '1 hanggang 5. Bawat linya ay dapat sumunod sa format na:\n\n'
        '"5 x 1 = 5"\n'
        '"5 x 2 = 10"\n'
        '...hanggang "5 x 5 = 25"',
    starterCode: '''<?php
// TODO: gumamit ng for loop (\$i mula 1 hanggang 5) para i-print
// ang bawat linya ng multiplication table ng 5.
?>''',
    expectedOutput: '5 x 1 = 5\n5 x 2 = 10\n5 x 3 = 15\n5 x 4 = 20\n5 x 5 = 25',
  ),
];
