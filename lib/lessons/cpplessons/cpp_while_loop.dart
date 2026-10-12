import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_while.dart';

const Lesson whileLoopLessonCpp = Lesson(
  id: 'while',
  title: 'While Loops',
  icon: Icons.loop,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang WHILE LOOP ay nag-uulit ng isang piraso ng code HABANG totoo '
      'pa ang isang condition. Chine-check ang condition BAGO ang bawat '
      'pag-uulit (iteration).\n\n'
      'Syntax:\n'
      'while (condition) {\n'
      '    // uulitin ito habang TRUE pa ang condition\n'
      '}\n\n'
      'MAHALAGA: kailangang may nagbabago sa loob ng loop (hal. '
      'pagdadagdag sa isang counter variable) para maging FALSE ang '
      'condition paglaon — kung hindi, magiging "infinite loop" ito na '
      'hindi na titigil!\n\n'
      'Halimbawa, para i-print ang numbers 1 hanggang 5:\n\n'
      'int i = 1;\n'
      'while (i <= 5) {\n'
      '    cout << i << endl;\n'
      '    i++; // dinadagdagan natin, kung hindi, infinite loop!\n'
      '}',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int i = 1;
    int sum = 0;

    while (i <= 5) {
        sum = sum + i;
        i++;
    }

    cout << sum << endl;

    return 0;
}''',
  },
  exercisePrompt:
      'Gamit ang while loop, kunin ang KABUUAN (sum) ng mga numero mula 1 '
      'hanggang 5 (1+2+3+4+5), tapos i-print ang sum.',
  expectedOutput: '15',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int i = 1;
    int sum = 0;

    // Isulat dito ang while loop

    cout << sum << endl;

    return 0;
}''',
  },
  quiz: cppQuizWhile,
);
