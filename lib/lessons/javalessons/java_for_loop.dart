import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';
import '../../quizzes/javaquizzes/java_quiz_for.dart';

const Lesson forLoopLesson = Lesson(
  id: 'for',
  title: 'For Loops',
  icon: Icons.repeat,
  restrictToLanguages: {ProgrammingLanguage.java},
  theory:
      'Ang FOR LOOP ay isa ring paraan para mag-ulit, pero mas '
      '"compact" — pinagsasama nito sa isang linya ang TATLONG bagay: '
      '(1) starting value, (2) condition, at (3) kung paano magbabago ang '
      'counter bawat iteration.\n\n'
      'Syntax:\n'
      'for (int i = 0; i < 5; i++) {\n'
      '    // uulitin ito 5 beses (i = 0, 1, 2, 3, 4)\n'
      '}\n\n'
      'Mas ginagamit ang FOR LOOP kapag ALAM MO NA kung ilang beses dapat '
      'mag-ulit (hal. "gawin ito ng 10 beses"). Ginagamit naman ang WHILE '
      'LOOP kapag hindi natin alam nang eksakto kung ilang beses, basta '
      'hanggang totoo ang condition.\n\n'
      'Halimbawa: gamit ang for loop, makakagawa tayo ng "factorial" — '
      'ang produkto ng lahat ng numero mula 1 papunta sa isang numero '
      '(hal. 5! = 5×4×3×2×1 = 120).',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int factorial = 1;

        for (int i = 1; i <= 5; i++) {
            factorial = factorial * i;
        }

        System.out.println(factorial);
    }
}''',
  },
  exercisePrompt:
      'Gamit ang for loop, kalkulahin ang factorial ng 5 (5! = 5×4×3×2×1), '
      'tapos i-print ang resulta.',
  expectedOutput: '120',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        int factorial = 1;

        // Isulat dito ang for loop

        System.out.println(factorial);
    }
}''',
  },
  quiz: javaQuizFor,
);
