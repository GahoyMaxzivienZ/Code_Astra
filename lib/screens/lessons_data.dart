import 'code_editor_screen.dart' show ProgrammingLanguage;
import 'lesson.dart';
export 'lesson.dart';

import '../lessons/javalessons/java_arithmetic.dart';
import '../lessons/javalessons/java_comparisons.dart';
import '../lessons/javalessons/java_compiler_intro.dart';
import '../lessons/javalessons/java_for_loop.dart';
import '../lessons/javalessons/java_functions.dart';
import '../lessons/javalessons/java_ifelse.dart';
import '../lessons/javalessons/java_language_intro.dart';
import '../lessons/javalessons/java_print_lesson.dart';
import '../lessons/javalessons/java_program_structure.dart';
import '../lessons/javalessons/java_variables.dart';
import '../lessons/javalessons/java_while_loop.dart';

import '../lessons/cpplessons/cpp_arithmetic.dart';
import '../lessons/cpplessons/cpp_comparisons.dart';
import '../lessons/cpplessons/cpp_for_loop.dart';
import '../lessons/cpplessons/cpp_functions.dart';
import '../lessons/cpplessons/cpp_ifelse.dart';
import '../lessons/cpplessons/cpp_variables.dart';
import '../lessons/cpplessons/cpp_while_loop.dart';

import '../lessons/phplessons/php_arithmetic.dart';
import '../lessons/phplessons/php_comparisons.dart';
import '../lessons/phplessons/php_for_loop.dart';
import '../lessons/phplessons/php_functions.dart';
import '../lessons/phplessons/php_ifelse.dart';
import '../lessons/phplessons/php_variables.dart';
import '../lessons/phplessons/php_while_loop.dart';

import '../lessons/pythonlessons/python_arithmetic.dart';
import '../lessons/pythonlessons/python_comparisons.dart';
import '../lessons/pythonlessons/python_for_loop.dart';
import '../lessons/pythonlessons/python_functions.dart';
import '../lessons/pythonlessons/python_ifelse.dart';
import '../lessons/pythonlessons/python_variables.dart';
import '../lessons/pythonlessons/python_while_loop.dart';

import '../lessons/csharplessons/csharp_arithmetic.dart';
import '../lessons/csharplessons/csharp_comparisons.dart';
import '../lessons/csharplessons/csharp_for_loop.dart';
import '../lessons/csharplessons/csharp_functions.dart';
import '../lessons/csharplessons/csharp_ifelse.dart';
import '../lessons/csharplessons/csharp_variables.dart';
import '../lessons/csharplessons/csharp_while_loop.dart';

import '../lessons/jslessons/js_arithmetic.dart';
import '../lessons/jslessons/js_comparisons.dart';
import '../lessons/jslessons/js_for_loop.dart';
import '../lessons/jslessons/js_functions.dart';
import '../lessons/jslessons/js_ifelse.dart';
import '../lessons/jslessons/js_variables.dart';
import '../lessons/jslessons/js_while_loop.dart';

/// ALL lesson entries, including those with the same "id" but different
/// content per language. DO NOT USE THIS DIRECTLY in the UI —
/// use "lessonsForDisplay()" below instead, which
/// combines duplicate ids into ONE card.
const List<Lesson> lessons = [
  // Shared/multi-language lessons (content for all languages)
  languageIntroLesson,
  compilerIntroLesson,
  programStructureLesson,
  printLesson,

  // Java-only content
  variablesLesson,
  arithmeticLesson,
  comparisonsLesson,
  ifElseLesson,
  whileLoopLesson,
  forLoopLesson,
  functionsLesson,

  // C++-only content
  variablesLessonCpp,
  arithmeticLessonCpp,
  comparisonsLessonCpp,
  ifElseLessonCpp,
  whileLoopLessonCpp,
  forLoopLessonCpp,
  functionsLessonCpp,

  // PHP-only content
  variablesLessonPhp,
  arithmeticLessonPhp,
  comparisonsLessonPhp,
  ifElseLessonPhp,
  whileLoopLessonPhp,
  forLoopLessonPhp,
  functionsLessonPhp,

  // Python-only content
  variablesLessonPython,
  arithmeticLessonPython,
  comparisonsLessonPython,
  ifElseLessonPython,
  whileLoopLessonPython,
  forLoopLessonPython,
  functionsLessonPython,

  // C#-only content
  variablesLessonCsharp,
  arithmeticLessonCsharp,
  comparisonsLessonCsharp,
  ifElseLessonCsharp,
  whileLoopLessonCsharp,
  forLoopLessonCsharp,
  functionsLessonCsharp,

  // JavaScript-only content
  variablesLessonJs,
  arithmeticLessonJs,
  comparisonsLessonJs,
  ifElseLessonJs,
  whileLoopLessonJs,
  forLoopLessonJs,
  functionsLessonJs,
];

/// USE THIS in screens (LessonsListScreen, LanguagePickerScreen).
/// It combines lessons with the same "id" into ONE card in the list:
///
/// - If a version is "available" for the requested language, that one
///   will be used (with the correct code example, exercise, quiz).
/// - If none is available, the FIRST one found in the list
///   will be used as a PLACEHOLDER — but it will remain
///   locked/"Coming Soon" because it is not available for that language.
List<Lesson> lessonsForDisplay(ProgrammingLanguage language) {
  final Map<String, Lesson> byId = {};
  final List<String> order = [];

  for (final lesson in lessons) {
    if (!byId.containsKey(lesson.id)) {
      order.add(lesson.id);
      byId[lesson.id] = lesson;
    }
    if (lesson.availableFor(language)) {
      byId[lesson.id] = lesson;
    }
  }

  return [for (final id in order) byId[id]!];
}
