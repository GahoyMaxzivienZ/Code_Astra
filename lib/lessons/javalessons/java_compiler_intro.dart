import 'package:flutter/material.dart';

import '../../screens/lesson.dart';

const Lesson compilerIntroLesson = Lesson(
  id: 'compiler-intro',
  title: 'How Does a Compiler Work?',
  icon: Icons.psychology_outlined,
  theory:
      'Before we start writing code, it is important to understand '
      'what happens behind the scenes when we run a program.\n\n'
      'Think of a sentence: "Juan ate an apple." '
      'Before you can understand it, you first divide it into words: '
      '["Juan", "ate", "an", "apple"].\n\n'
      'The compiler does something similar with your code. It first '
      'divides the code into small pieces called TOKENS before '
      'trying to understand its complete meaning. This is called '
      'Lexical Analysis, which is the FIRST step of a compiler.\n\n'
      'For example, the code "int x = 5;" is divided into 5 tokens:\n'
      '• int — keyword (tells the compiler that this is a whole number)\n'
      '• x — identifier (the name of the variable)\n'
      '• = — operator (assigns a value)\n'
      '• 5 — literal (the actual number)\n'
      '• ; — symbol (indicates that the line is finished)\n\n'
      'After Lexical Analysis, the code goes through two more '
      'steps: Syntax Analysis (checking whether the tokens are '
      'arranged correctly) and Execution (running the code to get '
      'the result).\n\n'
      'Inside the Code Editor, you will see a button called "Tokens". '
      'Press it anytime to see how the compiler divides your code!',
  codeExample: null,
  quiz: compilerIntroQuiz,
);
