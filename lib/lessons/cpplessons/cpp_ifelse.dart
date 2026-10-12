import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_ifelse.dart';

const Lesson ifElseLessonCpp = Lesson(
  id: 'ifelse',
  title: 'If-Else',
  icon: Icons.call_split,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang IF-ELSE STATEMENT ay nagbibigay-daan sa program natin na '
      'gumawa ng DESISYON — magpapatakbo lang ng isang piraso ng code '
      'KUNG totoo (true) ang isang condition.\n\n'
      'Syntax:\n'
      'if (condition) {\n'
      '    // gagawin kung TRUE ang condition\n'
      '} else {\n'
      '    // gagawin kung FALSE ang condition\n'
      '}\n\n'
      'Pwede ring gumamit ng "else if" kung may higit sa dalawang '
      'posibleng landas:\n\n'
      'if (grade >= 90) {\n'
      '    // A\n'
      '} else if (grade >= 80) {\n'
      '    // B\n'
      '} else {\n'
      '    // ibang grade\n'
      '}\n\n'
      'Ang condition sa loob ng () ay dapat laging boolean expression — '
      'kadalasan galing ito sa mga comparison operators na natutunan '
      'natin sa nakaraang lesson.',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int edad = 20;

    if (edad >= 18) {
        cout << "Legal age na!" << endl;
    } else {
        cout << "Menor de edad pa." << endl;
    }

    return 0;
}''',
  },
  exercisePrompt:
      'Gumawa ng int variable na "numero" na may value na 8. Gamit ang '
      'if-else, i-print ang "Even" kung pareho ang natitira sa paghahati '
      'sa 2 (numero % 2 == 0), o "Odd" kung hindi.',
  expectedOutput: 'Even',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    int numero = 8;

    // Isulat dito ang if-else

    return 0;
}''',
  },
  quiz: cppQuizIfElse,
);
