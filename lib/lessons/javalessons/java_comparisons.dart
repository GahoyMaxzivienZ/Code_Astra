import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_comparisons.dart';

const Lesson comparisonsLesson = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.java},
  theory:
      'Ang COMPARISON OPERATORS ay ginagamit para IKUMPARA ang dalawang '
      'value — ang resulta ay laging boolean (true o false):\n\n'
      '• == — pareho ba (equal to)\n'
      '• != — hindi pareho (not equal to)\n'
      '• > — mas malaki (greater than)\n'
      '• < — mas maliit (less than)\n'
      '• >= — mas malaki o pareho (greater than or equal)\n'
      '• <= — mas maliit o pareho (less than or equal)\n\n'
      'PANSININ: iba ang "=" (para mag-assign ng value) sa "==" (para '
      'i-COMPARE kung pareho). Isa ito sa pinaka-common na mistake ng mga '
      'bagong programmer!\n\n'
      'Ang mga comparison ay pinaka-ginagamit kasabay ng if-statements — '
      'susunod nating aralin.',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int a = 10;
        int b = 5;

        System.out.println(a > b);  // true
        System.out.println(a == b); // false
        System.out.println(a != b); // true
    }
}''',
  },
  exercisePrompt: 'I-print ang resulta ng comparison na "10 > 5".',
  expectedOutput: 'true',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        // I-print ang resulta ng 10 > 5

    }
}''',
  },
  quiz: javaQuizComparisons,
);
