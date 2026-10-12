import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_arithmetic.dart';

const Lesson arithmeticLesson = Lesson(
  id: 'arithmetic',
  title: 'Arithmetic',
  icon: Icons.calculate_outlined,
  restrictToLanguages: {ProgrammingLanguage.java},
  theory:
      'Ang mga ARITHMETIC OPERATORS ay ginagamit para gumawa ng mga '
      'kalkulasyon sa Java:\n\n'
      '• + — addition (pagdadagdag)\n'
      '• - — subtraction (pagbabawas)\n'
      '• * — multiplication (pagpaparami)\n'
      '• / — division (paghahati)\n'
      '• % — modulo (nagbibigay ng "natitira" pagkatapos maghati)\n\n'
      'Mahalagang tandaan: kapag pareho ang dalawang int na hinahati '
      '(hal. 7 / 2), ang resulta ay INT DIVISION — inaalis ang decimal '
      'part, kaya ang sagot ay 3, hindi 3.5. Kung gusto mo ng decimal '
      'result, kailangang isa sa mga numero ay double.\n\n'
      'Sinusunod din ng Java ang tamang "order of operations" (PEMDAS) — '
      'mauuna ang multiplication/division bago ang addition/subtraction, '
      'maliban kung may parenthesis.',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int a = 10;
        int b = 3;

        System.out.println(a + b); // 13
        System.out.println(a - b); // 7
        System.out.println(a * b); // 30
        System.out.println(a / b); // 3 (int division!)
        System.out.println(a % b); // 1 (natitira)
    }
}''',
  },
  exercisePrompt:
      'Gumawa ng dalawang int variables na 15 at 27, tapos i-print ang '
      'KABUUAN (sum) nila.',
  expectedOutput: '42',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        // Gumawa ng dalawang variable at i-print ang sum

    }
}''',
  },
  quiz: javaQuizArithmetic,
);
