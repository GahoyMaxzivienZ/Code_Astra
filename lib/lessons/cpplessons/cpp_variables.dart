import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/cppquizzes/cpp_quiz_variables.dart';

const Lesson variablesLessonCpp = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.cpp},
  theory:
      'Ang VARIABLE ay parang "lalagyan" na may pangalan, kung saan '
      'naka-store ang isang value na pwede mong gamitin at baguhin sa '
      'buong programa.\n\n'
      'Sa C++, kada gagawa ka ng variable, kailangan mong sabihin muna '
      'ang TYPE nito — ano bang klaseng data ang ilalagay mo dito.\n\n'
      'Karaniwang mga TYPE sa C++:\n'
      '• int — buong numero (hal. 5, -10, 2024)\n'
      '• double — numerong may decimal (hal. 3.14, 99.99)\n'
      '• string — text/salita (kailangan ng #include <string>, laging '
      'naka-quote, hal. "Kumusta")\n'
      '• bool — true o false lang\n'
      '• char — iisang letra lang (hal. \'A\')\n\n'
      'Ang syntax ay: TYPE pangalan = value;\n\n'
      'Halimbawa: int edad = 20; — gumagawa ito ng variable na "edad" na '
      'may type na int at value na 20.',
  codeExample: {
    ProgrammingLanguage.cpp: '''#include <iostream>
#include <string>
using namespace std;

int main() {
    int edad = 20;
    double presyo = 99.99;
    string pangalan = "Juan";
    bool estudyante = true;

    cout << pangalan << endl;
    cout << edad << endl;

    return 0;
}''',
  },
  exercisePrompt:
      'Gumawa ng int variable na pinangalanang "taon" na may value na '
      '2024, tapos i-print ito gamit ang cout.',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    // Gumawa ng variable dito

    return 0;
}''',
  },
  quiz: cppQuizVariables,
);
