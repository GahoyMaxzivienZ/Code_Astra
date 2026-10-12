import '../screens/code_editor_screen.dart' show ProgrammingLanguage;

/// Difficulty level of an exercise, used to group and filter exercises
/// within a single programming language.
enum ExerciseDifficulty { easy, medium, hard }

extension ExerciseDifficultyLabel on ExerciseDifficulty {
  String get label {
    switch (this) {
      case ExerciseDifficulty.easy:
        return 'Easy';
      case ExerciseDifficulty.medium:
        return 'Medium';
      case ExerciseDifficulty.hard:
        return 'Hard';
    }
  }
}

/// A single practice exercise: the student reads [instructions], writes
/// their own solution starting from [starterCode] in the code editor,
/// runs it, and the app compares the actual output against
/// [expectedOutput].
///
/// Unlike `StructureBlankExercise` (fill-in-the-blanks for language
/// boilerplate, see lesson.dart), an [Exercise] is solved from scratch —
/// the student writes the full solution themselves.
class Exercise {
  final String id;
  final String title;
  final ProgrammingLanguage language;
  final ExerciseDifficulty difficulty;

  /// Explanation of what the student needs to build.
  final String instructions;

  /// Code shown in the editor when the exercise is first opened —
  /// usually just the required boilerplate plus a TODO comment, not a
  /// full solution.
  final String starterCode;

  /// Exact output the program should print when run correctly.
  /// Compared to the actual output after trimming whitespace on both
  /// sides (see ExerciseScreen._checkSolution).
  final String expectedOutput;

  const Exercise({
    required this.id,
    required this.title,
    required this.language,
    required this.difficulty,
    required this.instructions,
    required this.starterCode,
    required this.expectedOutput,
  });
}
