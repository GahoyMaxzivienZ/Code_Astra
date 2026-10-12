import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_functions.dart';

const Lesson functionsLesson = Lesson(
  id: 'functions',
  title: 'Functions',
  icon: Icons.functions,
  restrictToLanguages: {ProgrammingLanguage.java},
  theory:
      'Ang FUNCTION (o "method" sa Java) ay isang "reusable" na piraso '
      'ng code na may pangalan — pwede mo itong tawagin (call) kung '
      'kailan mo kailangan, sa halip na paulit-ulit na isulat ang '
      'parehong code.\n\n'
      'Syntax ng isang method sa Java:\n'
      'static RETURN_TYPE pangalanNgMethod(mga_parameter) {\n'
      '    // code\n'
      '    return value; // kung may RETURN_TYPE\n'
      '}\n\n'
      '• RETURN_TYPE — ang uri ng value na ibabalik ng method (hal. int, '
      'String). Kung walang ibabalik, gamitin ang "void".\n'
      '• Mga PARAMETER — ang mga input na kailangan ng method para gumana '
      '(hal. int a, int b).\n'
      '• "return" — ito ang nagpapabalik ng value papunta sa nagtawag '
      '(caller) ng method.\n\n'
      'Halimbawa: isang method na "square" na kumukuha ng isang int at '
      'ibinabalik ang parisukat (square) nito:\n\n'
      'static int square(int n) {\n'
      '    return n * n;\n'
      '}\n\n'
      'Para tawagin: int result = square(6); — dito, ang "result" ay '
      'magiging 36.',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    static int square(int n) {
        return n * n;
    }

    public static void main(String[] args) {
        int result = square(6);
        System.out.println(result);
    }
}''',
  },
  exercisePrompt:
      'Gumawa ng static method na pinangalanang "square" na kumukuha ng '
      'int parameter at nagbabalik ng parisukat (square) nito. Sa loob ng '
      'main, tawagin ang square(6) at i-print ang resulta.',
  expectedOutput: '36',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    // Gumawa dito ng "square" method

    public static void main(String[] args) {
        // Tawagin ang square(6) dito at i-print ang resulta

    }
}''',
  },
  quiz: javaQuizFunctions,
);
