import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_variables.dart';

const Lesson variablesLesson = Lesson(
  id: 'variables',
  title: 'Variables',
  icon: Icons.data_object,
  restrictToLanguages: {ProgrammingLanguage.java},
  theory:
      'Ang VARIABLE ay parang "lalagyan" na may pangalan, kung saan '
      'naka-store ang isang value na pwede mong gamitin at baguhin sa '
      'buong programa.\n\n'
      'Sa Java, kada gagawa ka ng variable, kailangan mong sabihin muna '
      'ang TYPE nito — ano bang klaseng data ang ilalagay mo dito. Ito '
      'ang tinatawag na "static typing".\n\n'
      'Karaniwang mga TYPE sa Java:\n'
      '• int — buong numero (hal. 5, -10, 2024)\n'
      '• double — numerong may decimal (hal. 3.14, 99.99)\n'
      '• String — text/salita (laging naka-quote, hal. "Kumusta")\n'
      '• boolean — true o false lang\n'
      '• char — iisang letra lang (hal. \'A\')\n\n'
      'Ang syntax ay: TYPE pangalan = value;\n\n'
      'Halimbawa: int edad = 20; — gumagawa ito ng variable na "edad" na '
      'may type na int at value na 20.',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int edad = 20;
        double presyo = 99.99;
        String pangalan = "Juan";
        boolean estudyante = true;

        System.out.println(pangalan);
        System.out.println(edad);
    }
}''',
  },
  exercisePrompt:
      'Gumawa ng int variable na pinangalanang "taon" na may value na '
      '2024, tapos i-print ito gamit ang System.out.println().',
  expectedOutput: '2024',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        // Gumawa ng variable dito

    }
}''',
  },
  quiz: javaQuizVariables,
);
