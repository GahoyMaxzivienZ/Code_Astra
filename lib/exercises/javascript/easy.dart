import '../../models/exercise.dart';
import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

final List<Exercise> javascriptEasyExercises = [
  const Exercise(
    id: 'javascript_easy_sum',
    title: 'Sum ng Dalawang Numero',
    language: ProgrammingLanguage.javascript,
    difficulty: ExerciseDifficulty.easy,
    instructions:
        'Gumawa ng program na magdedeklara ng dalawang variable: "a" na '
        'may value na 15, at "b" na may value na 27. Idagdag ang dalawa, '
        'at i-print ang resulta gamit ang eksaktong format:\n\n'
        '"Sum: 42"',
    starterCode: '''// TODO: idineklara ang let a = 15 at let b = 27, idagdag,
// tapos i-print gamit ang format na "Sum: <resulta>"''',
    expectedOutput: 'Sum: 42',
  ),
];
