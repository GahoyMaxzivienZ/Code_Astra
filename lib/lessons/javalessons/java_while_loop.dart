import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_while.dart';

const Lesson whileLoopLesson = Lesson(
  id: 'while',
  title: 'While Loops',
  icon: Icons.loop,
  restrictToLanguages: {ProgrammingLanguage.java},
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
      '    System.out.println(i);\n'
      '    i++; // dinadagdagan natin, kung hindi, infinite loop!\n'
      '}',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int i = 1;
        int sum = 0;

        while (i <= 5) {
            sum = sum + i;
            i++;
        }

        System.out.println(sum);
    }
}''',
  },
  exercisePrompt:
      'Gamit ang while loop, kunin ang KABUUAN (sum) ng mga numero mula 1 '
      'hanggang 5 (1+2+3+4+5), tapos i-print ang sum.',
  expectedOutput: '15',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int i = 1;
        int sum = 0;

        // Isulat dito ang while loop

        System.out.println(sum);
    }
}''',
  },
  quiz: javaQuizWhile,
);
