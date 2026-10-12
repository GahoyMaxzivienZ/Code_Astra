import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_arithmetic.dart';

const Lesson arithmeticLessonCpp = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate_outlined,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang mga ARITHMETIC OPERATORS ay ginagamit para gumawa ng mga '
      'kalkulasyon sa C++:\n\n'
      '• + — addition (pagdadagdag)\n'
      '• - — subtraction (pagbabawas)\n'
      '• * — multiplication (pagpaparami)\n'
      '• / — division (paghahati)\n'
      '• % — modulo (nagbibigay ng "natitira" pagkatapos maghati)\n\n'
      'Mahalagang tandaan: kapag pareho ang dalawang int na hinahati '
      '(hal. 7 / 2), ang resulta ay INT DIVISION — inaalis ang decimal '
      'part, kaya ang sagot ay 3, hindi 3.5. Kung gusto mo ng decimal '
      'result, kailangang isa sa mga numero ay double.\n\n'
      'Sinusunod din ng C++ ang tamang "order of operations" (PEMDAS) — '
      'mauuna ang multiplication/division bago ang addition/subtraction, '
      'maliban kung may parenthesis.',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int a = 10;
    int b = 3;

    cout << (a + b) << endl; // 13
    cout << (a - b) << endl; // 7
    cout << (a * b) << endl; // 30
    cout << (a / b) << endl; // 3 (int division!)
    cout << (a % b) << endl; // 1 (natitira)

    return 0;
}''',
  },
  exercisePrompt:
      'Gumawa ng dalawang int variables na 15 at 27, tapos i-print ang '
      'KABUUAN (sum) nila.',
  expectedOutput: '42',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    // Gumawa ng dalawang variable at i-print ang sum

    return 0;
}''',
  },
  quiz: cppQuizArithmetic,
);
