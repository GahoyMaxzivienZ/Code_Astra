import '../models/exercise.dart';
import '../screens/code_editor_screen.dart' show ProgrammingLanguage;

import 'cpp/easy.dart';
import 'cpp/hard.dart';
import 'cpp/medium.dart';
import 'csharp/easy.dart';
import 'csharp/hard.dart';
import 'csharp/medium.dart';
import 'java/easy.dart';
import 'java/hard.dart';
import 'java/medium.dart';
import 'javascript/easy.dart';
import 'javascript/hard.dart';
import 'javascript/medium.dart';
import 'php/easy.dart';
import 'php/hard.dart';
import 'php/medium.dart';
import 'python/easy.dart';
import 'python/hard.dart';
import 'python/medium.dart';

/// Every exercise in the app, grouped by language. Each language's list
/// is built from its own exercises/{language}/{difficulty}.dart files —
/// add new exercises by appending to the right difficulty file, or add a
/// whole new difficulty tier by creating a new file and adding it to the
/// language's list below.
final Map<ProgrammingLanguage, List<Exercise>> exercisesByLanguage = {
  ProgrammingLanguage.java: [
    ...javaEasyExercises,
    ...javaMediumExercises,
    ...javaHardExercises,
  ],
  ProgrammingLanguage.cpp: [
    ...cppEasyExercises,
    ...cppMediumExercises,
    ...cppHardExercises,
  ],
  ProgrammingLanguage.python: [
    ...pythonEasyExercises,
    ...pythonMediumExercises,
    ...pythonHardExercises,
  ],
  ProgrammingLanguage.javascript: [
    ...javascriptEasyExercises,
    ...javascriptMediumExercises,
    ...javascriptHardExercises,
  ],
  ProgrammingLanguage.csharp: [
    ...csharpEasyExercises,
    ...csharpMediumExercises,
    ...csharpHardExercises,
  ],
  ProgrammingLanguage.php: [
    ...phpEasyExercises,
    ...phpMediumExercises,
    ...phpHardExercises,
  ],
};

/// All exercises for a given language, optionally narrowed further to a
/// single [difficulty].
List<Exercise> exercisesFor(
  ProgrammingLanguage language, {
  ExerciseDifficulty? difficulty,
}) {
  final all = exercisesByLanguage[language] ?? const [];
  if (difficulty == null) return all;
  return all.where((e) => e.difficulty == difficulty).toList();
}

/// Groups a language's exercises by difficulty, in easy → medium → hard
/// order — handy for building a sectioned list UI.
Map<ExerciseDifficulty, List<Exercise>> exercisesGroupedByDifficulty(
  ProgrammingLanguage language,
) {
  final all = exercisesFor(language);
  return {
    for (final difficulty in ExerciseDifficulty.values)
      difficulty: all.where((e) => e.difficulty == difficulty).toList(),
  };
}
