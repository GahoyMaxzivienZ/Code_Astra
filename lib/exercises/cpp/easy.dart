import '../../models/exercise.dart';
import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

final List<Exercise> cppEasyExercises = [
  const Exercise(
    id: 'cpp_easy_sum',
    title: 'Sum ng Dalawang Numero',
    language: ProgrammingLanguage.cpp,
    difficulty: ExerciseDifficulty.easy,
    instructions:
        'Gumawa ng program na magdedeklara ng dalawang int variable: "a" '
        'na may value na 15, at "b" na may value na 27. Idagdag ang '
        'dalawa, at i-print ang resulta gamit ang eksaktong format:\n\n'
        '"Sum: 42"',
    starterCode: '''#include <iostream>
using namespace std;

int main() {
    // TODO: idineklara ang int a = 15 at int b = 27, idagdag,
    // tapos i-print gamit ang format na "Sum: <resulta>"
    return 0;
}''',
    expectedOutput: 'Sum: 42',
  ),
];
