import '../screens/code_editor_screen.dart' show ProgrammingLanguage;

/// Shared string key + display label for each [ProgrammingLanguage],
/// matching the Firestore document keys already used by the app (see
/// structure_exercise_screen.dart's `_keyFor`). Centralizing this avoids
/// re-defining the same switch statement in every screen that needs it.
extension ProgrammingLanguageInfo on ProgrammingLanguage {
  /// Lowercase key used in Firestore documents (e.g. 'java', 'cpp').
  String get key {
    switch (this) {
      case ProgrammingLanguage.java:
        return 'java';
      case ProgrammingLanguage.cpp:
        return 'cpp';
      case ProgrammingLanguage.python:
        return 'python';
      case ProgrammingLanguage.javascript:
        return 'javascript';
      case ProgrammingLanguage.csharp:
        return 'csharp';
      case ProgrammingLanguage.php:
        return 'php';
    }
  }

  /// Human-readable display label (e.g. 'C++', 'C#').
  String get label {
    switch (this) {
      case ProgrammingLanguage.java:
        return 'Java';
      case ProgrammingLanguage.cpp:
        return 'C++';
      case ProgrammingLanguage.python:
        return 'Python';
      case ProgrammingLanguage.javascript:
        return 'JavaScript';
      case ProgrammingLanguage.csharp:
        return 'C#';
      case ProgrammingLanguage.php:
        return 'PHP';
    }
  }
}
