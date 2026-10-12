import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;
import '../../screens/lesson.dart';

const Lesson printLesson = Lesson(
  id: 'print',
  title: 'Print / Output',
  icon: Icons.terminal,
  theory:
      'Ang "print statement" ay ang pinaka-simpleng paraan para magpakita '
      'ng text o resulta sa screen. Ito karaniwan ang una nating natututunan '
      'sa bawat programming language, dahil dito natin nakikita kung '
      'gumagana nga ba ang code natin.\n\n'
      'Bawat language ay may sariling paraan ng pag-print, pero pareho '
      'lang ang konsepto: sabihin sa computer kung anong text ang ipapakita.',
  codeExample: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}''',
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}''',
    ProgrammingLanguage.python: 'print("Hello, World!")',
    ProgrammingLanguage.javascript: 'console.log("Hello, World!");',
    ProgrammingLanguage.csharp: '''using System;

public class Program {
    static void Main(string[] args) {
        Console.WriteLine("Hello, World!");
    }
}''',
    ProgrammingLanguage.php: '''<?php
echo "Hello, World!";
?>''',
  },
  exercisePrompt:
      'Gumawa ng print statement na maglalabas ng eksaktong sumusunod na '
      'text:\n\n"Kumusta, CodeAstra!"',
  expectedOutput: 'Kumusta, CodeAstra!',
  starterCode: {
    ProgrammingLanguage.java: '''public class Main {
    public static void main(String[] args) {
        // Isulat dito ang iyong print statement

    }
}''',
    ProgrammingLanguage.cpp: '''#include <iostream>
using namespace std;

int main() {
    // Isulat dito ang iyong print statement

    return 0;
}''',
    ProgrammingLanguage.python: '# Isulat dito ang iyong print statement\n',
    ProgrammingLanguage.javascript:
        '// Isulat dito ang iyong print statement\n',
    ProgrammingLanguage.csharp: '''using System;

public class Program {
    static void Main(string[] args) {
        // Isulat dito ang iyong print statement

    }
}''',
    ProgrammingLanguage.php: '''<?php
// Isulat dito ang iyong print statement

?>''',
  },
);
