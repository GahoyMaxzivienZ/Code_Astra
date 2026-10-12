import '../../models/exercise.dart';
import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

final List<Exercise> javaEasyExercises = [
  const Exercise(
    id: 'java_easy_sum',
    title: 'Sum ng Dalawang Numero',
    language: ProgrammingLanguage.java,
    difficulty: ExerciseDifficulty.easy,
    instructions:
        'Gumawa ng program na magdedeklara ng dalawang integer variable: '
        '"a" na may value na 15, at "b" na may value na 27. Idagdag ang '
        'dalawa, at i-print ang resulta gamit ang eksaktong format:\n\n'
        '"Sum: 42"',
    starterCode: '''public class Main {
    public static void main(String[] args) {
        // TODO: idineklara ang int a = 15 at int b = 27, idagdag,
        // tapos i-print gamit ang format na "Sum: <resulta>"
    }
}''',
    expectedOutput: 'Sum: 42',
  ),
];
