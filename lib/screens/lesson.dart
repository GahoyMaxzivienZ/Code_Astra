import 'package:flutter/material.dart';

import 'code_editor_screen.dart' show ProgrammingLanguage;
import 'quiz_data.dart';

// Ino-export natin 'to para yung ibang files (tulad ng lesson_detail_screen.dart
// at quiz_screen.dart) na nag-i-import ng 'lesson.dart' ay makikita pa rin
// nila ang QuizQuestion/QuizOption nang hindi na kailangan mag-import
// nang hiwalay ng quiz_data.dart.
export 'quiz_data.dart';

/// Isang "fill in the blanks" na exercise — ginagamit para sa mga lesson
/// na kailangang kumpletuhin muna ang STRUCTURE/SKELETON bago pumunta sa
/// "type the whole thing yourself" na step. Case-sensitive at exact-match
/// ang pagsusuri ng bawat blangko.
class StructureBlankExercise {
  final String instruction;

  // Ang code, hinati sa mga piraso sa PAGITAN ng bawat blangko. Kung may
  // N na blangko, dapat may N+1 na piraso dito (bago ang unang blangko,
  // sa pagitan ng bawat magkasunod na blangko, at pagkatapos ng huli).
  final List<String> templateParts;

  // Ang TAMANG sagot sa bawat blangko, sa pagkakasunod-sunod. Dapat
  // eksaktong (correctAnswers.length + 1) ang templateParts.length.
  final List<String> correctAnswers;

  const StructureBlankExercise({
    required this.instruction,
    required this.templateParts,
    required this.correctAnswers,
  });

  // Hindi na natin pwedeng gawing `assert` sa loob ng const constructor
  // ang pagsusuring ito (Dart const evaluator ay hindi pumapayag sa
  // `.length` sa isang List na constructor parameter kapag const context).
  // Sa halip, tawagin ang `validate()` na ito sa debug-time (hal. sa
  // isang unit test o sa `main()` bago tumakbo ang app) para masiguro
  // pa rin na tama ang bilang ng templateParts vs correctAnswers.
  bool validate() {
    final ok = templateParts.length == correctAnswers.length + 1;
    assert(
      ok,
      'templateParts dapat isa itong higit sa bilang ng correctAnswers '
      '(instruction: "$instruction")',
    );
    return ok;
  }
}

/// Static content model — hindi ito naka-store sa Firestore, bahagi ito
/// ng app mismo (parang "curriculum" na naka-built-in). Ang naka-store
/// lang sa Firestore ay ang RESULTA ng ginawa ng estudyante dito
/// (submissions, progress) — tignan ang lesson_detail_screen.dart.
///
/// Ang aktwal na LAMAN ng bawat lesson (theory, code, exercise, quiz) ay
/// nasa loob ng "lessons/" folder — isang file per lesson — tapos
/// pinagsasama-sama sa "lessons_data.dart".
class Lesson {
  final String id;
  final String title;
  final IconData icon;
  final bool comingSoon;

  final String? theory;
  final Map<ProgrammingLanguage, String>? theoryByLanguage;
  final Map<ProgrammingLanguage, String>? codeExample;

  final String? exercisePrompt;
  final Map<ProgrammingLanguage, String>? starterCode;
  final String? expectedOutput;

  // Gamitin ang "quiz" kapag PAREHO ang mga tanong sa lahat ng languages
  // (hal. konsepto ng tokens — universal, hindi nakadepende sa syntax).
  final List<QuizQuestion>? quiz;

  // Gamitin ang "quizByLanguage" kapag MAGKAIBA ang mga tanong per
  // language (hal. ang balangkas/boilerplate — magkaiba ang public/class/
  // main sa Java kumpara sa walang-boilerplate na Python). Tignan ang
  // quiz_data.dart para sa aktwal na laman ng mga quiz.
  final Map<ProgrammingLanguage, List<QuizQuestion>>? quizByLanguage;

  // Kung naka-set 'to (hal. {ProgrammingLanguage.java}), ang lesson ay
  // "available" lang para sa mga languages na nakalista dito — sa ibang
  // languages, ituturing itong parang "Coming Soon" pa rin (naka-lock,
  // hindi ma-a-access) hangga't wala pang nilalaman doon. Null = available
  // sa LAHAT ng languages.
  final Set<ProgrammingLanguage>? restrictToLanguages;

  // Kung naka-set 'to para sa isang language, ang "Subukan Mo" na section
  // ng lesson na ito ay magbubukas ng dedicated na StructureExerciseScreen
  // (fill-in-the-blanks muna, tapos type-the-whole-thing) sa halip na ang
  // normal na exercise editor o quiz button.
  final Map<ProgrammingLanguage, StructureBlankExercise>? blankExercise;

  const Lesson({
    required this.id,
    required this.title,
    required this.icon,
    this.comingSoon = false,
    this.theory,
    this.theoryByLanguage,
    this.codeExample,
    this.exercisePrompt,
    this.starterCode,
    this.expectedOutput,
    this.quiz,
    this.quizByLanguage,
    this.restrictToLanguages,
    this.blankExercise,
  });

  bool get hasExercise => exercisePrompt != null && starterCode != null;

  /// True kung may StructureBlankExercise para sa hiniling na language.
  bool hasBlankExercise(ProgrammingLanguage language) {
    return blankExercise?[language] != null;
  }

  bool get hasQuiz =>
      (quiz != null && quiz!.isNotEmpty) ||
      (quizByLanguage != null && quizByLanguage!.isNotEmpty);

  /// True kung ang lesson na ito ay may TALAGANG nilalaman para sa
  /// partikular na language — ginagamit ito ng LessonsListScreen para
  /// malaman kung dapat itong buksan o i-treat na parang "Coming Soon".
  bool availableFor(ProgrammingLanguage language) {
    if (comingSoon) return false;
    if (restrictToLanguages == null) return true;
    return restrictToLanguages!.contains(language);
  }

  String theoryFor(ProgrammingLanguage language) {
    return theoryByLanguage?[language] ?? theory ?? '';
  }

  /// Kinukuha ang tamang set ng quiz questions depende sa language —
  /// kung may per-language na bersyon, gamitin 'yon; kung wala, gamitin
  /// ang generic na "quiz".
  List<QuizQuestion> quizFor(ProgrammingLanguage language) {
    return quizByLanguage?[language] ?? quiz ?? [];
  }
}
