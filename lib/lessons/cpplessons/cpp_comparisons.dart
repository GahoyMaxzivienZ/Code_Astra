import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_comparisons.dart';

const Lesson comparisonsLessonCpp = Lesson(
  id: 'comparisons',
  title: 'Comparisons',
  icon: Icons.compare_arrows,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang COMPARISON OPERATORS ay ginagamit para IKUMPARA ang dalawang '
      'value — ang resulta ay laging boolean (true o false):\n\n'
      '• == — pareho ba (equal to)\n'
      '• != — hindi pareho (not equal to)\n'
      '• > — mas malaki (greater than)\n'
      '• < — mas maliit (less than)\n'
      '• >= — mas malaki o pareho (greater than or equal)\n'
      '• <= — mas maliit o pareho (less than or equal)\n\n'
      'MAY ISANG QUIRK ANG C++ dito: kapag pinrint mo ang isang boolean '
      'gamit ang cout nang WALANG "boolalpha", ang lalabas ay 1 (para sa '
      'true) o 0 (para sa false), hindi ang salitang "true"/"false".\n\n'
      'Para lumabas ang salitang "true"/"false", kailangan mong isulat '
      'muna ang "cout << boolalpha;" bago ang pag-print ng boolean.\n\n'
      'PANSININ din: iba ang "=" (para mag-assign) sa "==" (para '
      'i-COMPARE) — common mistake ito ng mga bagong programmer!',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int a = 10;
    int b = 5;

    cout << boolalpha; // para lumabas na "true/false" imbes na 1/0
    cout << (a > b) << endl;  // true
    cout << (a == b) << endl; // false
    cout << (a != b) << endl; // true

    return 0;
}''',
  },
  exercisePrompt:
      'Gamit ang "cout << boolalpha;" bago ang pag-print, i-print ang '
      'resulta ng comparison na "10 > 5".',
  expectedOutput: 'true',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    // I-print ang resulta ng 10 > 5 (gamitin ang boolalpha)

    return 0;
}''',
  },
  quiz: cppQuizComparisons,
);
