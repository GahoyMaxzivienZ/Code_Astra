import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';

const Lesson programStructureLesson = Lesson(
  id: 'program-structure',
  title: 'Program Structure',
  icon: Icons.architecture_outlined,
  theoryByLanguage: {
    ProgrammingLanguage.java:
        'Bago tayo makasulat ng "totoong" code sa Java, kailangan muna '
        'nating maintindihan ang ilang salitang laging makikita natin sa '
        'simula ng bawat Java program:\n\n'
        '• "public" — nangangahulugang "puwedeng ma-access galing '
        'kahit saan." Ginagamit ito sa class at method para hindi '
        'restricted ang access dito.\n\n'
        '• "class" — isang "container" o "blueprint" na naglalaman ng '
        'buong code ng iyong program. Sa Java, LAHAT ng code ay '
        'kailangang nasa loob ng isang class.\n\n'
        '• "Main" — ito ay PANGALAN lamang ng class (pwede itong '
        'palitan sa totoong Java, pero "Main" ang gagamitin natin sa '
        'app na ito para consistent).\n\n'
        '• "public static void main(String[] args)" — ito ang tinatawag '
        'na "entry point" — DITO nagsisimula ang pagtakbo ng bawat Java '
        'program. Ang "static" ay nangangahulugang hindi na kailangang '
        'gumawa ng bagong object para patakbuhin ito. Ang "void" ay '
        'nangangahulugang walang ibinabalik na value ang method na ito. '
        'Ang "String[] args" ay listahan ng mga karagdagang '
        'impormasyon na pwedeng ipasa sa program (hindi natin ito '
        'ginagamit sa ngayon, pero required sa syntax).',
    ProgrammingLanguage.cpp:
        'Bago tayo makasulat ng "totoong" code sa C++, kailangan muna '
        'nating maintindihan ang ilang linya na laging makikita sa '
        'simula ng bawat C++ program:\n\n'
        '• "#include <iostream>" — "isinasama" nito ang isang '
        'library (koleksyon ng mga handa nang gamiting tools) na '
        'tinatawag na "iostream", na naglalaman ng mga tools para sa '
        'input/output tulad ng "cout" (para sa pag-print).\n\n'
        '• "using namespace std;" — nagbibigay-daan ito na direktang '
        'gamitin ang mga pangalan mula sa standard library ni C++ '
        '(tinatawag na "std" namespace) nang hindi na kailangang isulat '
        'ang "std::" sa harap ng bawat "cout" o "cin".\n\n'
        '• "int main() { ... }" — ito ang "entry point" — DITO '
        'nagsisimula ang pagtakbo ng bawat C++ program. Ang "int" ay '
        'nangangahulugang dapat magbalik ng integer value ang function '
        'na ito.\n\n'
        '• "return 0;" — ito ang huling linya, nagsasabi sa operating '
        'system na "successful ang pagtakbo ng program" (0 = walang '
        'problema).',
    ProgrammingLanguage.python:
        'Magandang balita — WALANG kailangang boilerplate/balangkas '
        'si Python! Direkta ka nang makakasulat ng code, tulad ng '
        'sumusunod:\n\n'
        'print("Hello, World!")\n\n'
        'Iyan na, tapos na! Walang class, walang "public", walang '
        '"entry point" na kailangang isulat.\n\n'
        'Bakit ganito? Dahil si Python ay dinisenyo bilang isang '
        '"scripting language" — sinusundan lang niya ang code mula sa '
        'unang linya papunta sa huli, tulad ng pagbasa ng isang libro. '
        'Ito rin ang dahilan kung bakit sinasabi na si Python ay may '
        '"simple at readable" na syntax — mas kaunti ang '
        '"ceremony"/"paperwork" bago ka makasulat ng aktwal na logic.',
    ProgrammingLanguage.javascript:
        'Tulad ng Python, WALANG kailangang boilerplate/balangkas si '
        'JavaScript! Direkta ka nang makakasulat ng code:\n\n'
        'console.log("Hello, World!");\n\n'
        'Iyan na, tapos na! Walang class, walang "entry point" na '
        'kailangang isulat.\n\n'
        'Ang "function" keyword ay ginagamit lamang KUNG gusto mong '
        'gumawa ng sarili mong reusable na function — pero hindi ito '
        'required kung simpleng mga statements lang ang isusulat mo.',
    ProgrammingLanguage.csharp:
        'Bago tayo makasulat ng "totoong" code sa C#, kailangan muna '
        'nating maintindihan ang ilang salitang laging makikita natin '
        'sa simula ng bawat C# program:\n\n'
        '• "using System;" — katulad ng "#include" sa C++, '
        '"isinasama" nito ang "System" namespace, na naglalaman ng '
        'mga tools tulad ng "Console" (para sa pag-print).\n\n'
        '• "public class Program { ... }" — tulad ng Java, kailangan '
        'ng C# na nakapaloob sa isang class ang lahat ng code.\n\n'
        '• "static void Main(string[] args)" — ito ang "entry point" '
        '— DITO nagsisimula ang pagtakbo ng bawat C# program. '
        'PANSININ: malaking letrang "M" ang "Main" sa C# (case-'
        'sensitive ang programming languages, kaya importanteng '
        'tama ang pagkasulat).',
    ProgrammingLanguage.php:
        'Sa PHP, kailangan mong markahan kung SAAN nagsisimula at '
        'natatapos ang PHP code sa loob ng isang file, gamit ang mga '
        'espesyal na tags:\n\n'
        '<?php\n'
        '    // dito mo isusulat ang code mo\n'
        '?>\n\n'
        'Bakit kailangan ito? Dahil sa totoong mundo, madalas '
        'naghahalo ng PHP at HTML sa parehong file (halimbawa, isang '
        'webpage na may embedded PHP logic) — kaya kailangan ng '
        'paraan para malaman ng interpreter kung "PHP code" o '
        '"plain HTML text" ang binabasa niya.\n\n'
        'Sa loob ng "<?php" at "?>", direkta ka nang makakasulat ng '
        'code — walang kailangang class o entry point declaration.',
  },
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {                          // "Main" - pangalan ng class
    public static void main(String[] args) { // dito nagsisimula ang program
        // dito mo isusulat ang code mo

    }
}''',
    ProgrammingLanguage.cpp:
        '''#include <iostream>      // isinasama ang tools para sa input/output
using namespace std;     // para direkta na lang gamitin ang cout/cin

int main() {              // dito nagsisimula ang program
    // dito mo isusulat ang code mo

    return 0;              // nagsasabing "successful"
}''',
    ProgrammingLanguage.python: '''# Walang kailangang boilerplate!
# Direkta ka nang makakasulat ng code dito.

print("Hello, World!")''',
    ProgrammingLanguage.javascript: '''// Walang kailangang boilerplate!
// Direkta ka nang makakasulat ng code dito.

console.log("Hello, World!");''',
    ProgrammingLanguage.csharp:
        '''using System;                          // isinasama ang Console class

public class Program {                 // kailangan ng class wrapper
    static void Main(string[] args) {  // dito nagsisimula ang program
        // dito mo isusulat ang code mo

    }
}''',
    ProgrammingLanguage.php: '''<?php
// Sa pagitan ng <?php at ?>, dito ka na direktang makakasulat ng code

?>''',
  },
  quizByLanguage: programStructureQuizByLanguage,
  blankExercise: {
    ProgrammingLanguage.java: StructureBlankExercise(
      instruction:
          'Kumpletuhin ang mga blangko para maging kumpleto ang structure '
          'ng Java program.',
      templateParts: [
        '',
        ' class Main {\n    public static void main(String[] args) {\n        System.out.println("Tama ang structure!");\n    }\n',
        '',
      ],
      correctAnswers: ['public', '}'],
    ),
    ProgrammingLanguage.cpp: StructureBlankExercise(
      instruction:
          'Kumpletuhin ang mga blangko para maging kumpleto ang structure '
          'ng C++ program.',
      templateParts: [
        '',
        ' <iostream>\nusing namespace std;\n\nint main() {\n    cout << "Tama ang structure!" << endl;\n    return 0;\n',
        '',
      ],
      correctAnswers: ['#include', '}'],
    ),
  },
  exercisePrompt:
      'Ngayon, isulat ang BUONG structure mula sa wala (kasama na ang '
      'lahat ng natutunan mo sa mga blangko) — gumawa ng program na '
      'nagpi-print ng "Tama ang structure!".',
  expectedOutput: 'Tama ang structure!',
  starterCode: {
    ProgrammingLanguage.java:
        '''// Isulat dito ang buong structure ng Java program
// na nagpi-print ng "Tama ang structure!"
''',
    ProgrammingLanguage.cpp:
        '''// Isulat dito ang buong structure ng C++ program
// na nagpi-print ng "Tama ang structure!"
''',
  },
);
