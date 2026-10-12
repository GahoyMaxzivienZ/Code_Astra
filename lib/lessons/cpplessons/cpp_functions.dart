import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_functions.dart';

const Lesson functionsLessonCpp = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang FUNCTION sa C++ ay isang "reusable" na piraso ng code na may '
      'pangalan — pwede mo itong tawagin (call) kung kailan mo kailangan, '
      'sa halip na paulit-ulit na isulat ang parehong code.\n\n'
      'Syntax ng isang function sa C++:\n'
      'RETURN_TYPE pangalanNgFunction(mga_parameter) {\n'
      '    // code\n'
      '    return value; // kung may RETURN_TYPE\n'
      '}\n\n'
      '• RETURN_TYPE — ang uri ng value na ibabalik ng function (hal. '
      'int, string). Kung walang ibabalik, gamitin ang "void".\n'
      '• Mga PARAMETER — ang mga input na kailangan ng function para '
      'gumana (hal. int a, int b).\n'
      '• "return" — ito ang nagpapabalik ng value papunta sa nagtawag '
      '(caller) ng function.\n\n'
      'PANSININ: sa C++, kailangang IDEKLARA/ISULAT ang function BAGO '
      'ito gamitin sa "main" — kaya karaniwang nasa itaas ng "main" ang '
      'mga functions.\n\n'
      'Halimbawa: isang function na "square" na kumukuha ng isang int '
      'at ibinabalik ang parisukat (square) nito:\n\n'
      'int square(int n) {\n'
      '    return n * n;\n'
      '}\n\n'
      'Para tawagin: int result = square(6); — dito, ang "result" ay '
      'magiging 36.',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int square(int n) {
    return n * n;
}

int main() {
    int result = square(6);
    cout << result << endl;

    return 0;
}''',
  },
  exercisePrompt:
      'Gumawa ng function na pinangalanang "square" na kumukuha ng int '
      'parameter at nagbabalik ng parisukat (square) nito. Sa loob ng '
      'main, tawagin ang square(6) at i-print ang resulta.',
  expectedOutput: '36',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

// Gumawa dito ng "square" function

int main() {
    // Tawagin ang square(6) dito at i-print ang resulta

    return 0;
}''',
  },
  quiz: cppQuizFunctions,
);
