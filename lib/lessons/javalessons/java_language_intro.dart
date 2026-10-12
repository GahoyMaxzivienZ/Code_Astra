import 'package:flutter/material.dart';

import '../../screens/code_editor_screen.dart' show ProgrammingLanguage;

import '../../screens/lesson.dart';

const Lesson languageIntroLesson = Lesson(
  id: 'language-intro',

  title: 'Get to Know the Language',

  icon: Icons.info_outline,

  theoryByLanguage: {
    ProgrammingLanguage.java:
        'Java was created by James Gosling (Sun Microsystems) in 1995. '
        'It was designed as a "write once, run anywhere" language — '
        'meaning that a Java program can run on almost '
        'any device (Windows, Mac, Linux, Android), as long as it has a Java '
        'Virtual Machine (JVM). It is an object-oriented language '
        'with a strict type system.\n\n'
        'Fun Facts:\n'
        '• Java was originally named "Oak", named after a '
        'tree outside Gosling\'s office.\n'
        '• One of the most widely used languages for Android app '
        'development.\n\n'
        'Common Uses: Android apps, Enterprise/banking systems, '
        'Server-side backends',

    ProgrammingLanguage.cpp:
        'C++ was created by Bjarne Stroustrup in 1985, as an extension '
        'of the C language — at first, it was literally called "C with '
        'Classes". It added object-oriented programming to C, '
        'while maintaining the ability to directly control the '
        'computer\'s memory.\n\n'
        'Fun Facts:\n'
        '• C++ is used in almost all major video game '
        'engines (Unreal Engine, for example).\n'
        '• C++ is known for its "performance" — it runs fast because '
        'it is close to the hardware.\n\n'
        'Common Uses: Game engines, Operating systems, '
        'High-performance software',

    ProgrammingLanguage.python:
        'Python was created by Guido van Rossum in 1991, because he wanted '
        'a language that was easy to read and write, like '
        'English pseudocode. This is why Python does not have { } '
        'braces — indentation (spacing) is what creates '
        'blocks.\n\n'
        'Fun Facts:\n'
        '• Python was named after "Monty Python\'s Flying Circus", '
        'a British comedy show — not the snake!\n'
        '• One of the most widely used languages today in Artificial '
        'Intelligence and Data Science.\n\n'
        'Common Uses: Data science / AI, Automation scripts, Web '
        'development',

    ProgrammingLanguage.csharp:
        'C# was created by Anders Hejlsberg (Microsoft) in 2000, as '
        'part of the .NET framework, as an alternative to Java. It has a '
        'structure similar to Java (both are object-oriented, both '
        'have class-based organization), but it has its own '
        'ecosystem and features.\n\n'
        'Fun Facts:\n'
        '• The "#" in the name refers to the musical term "sharp" — '
        'like C being "raised" to a higher level.\n'
        '• Unity, one of the most popular game engines, uses '
        'C# as its scripting language.\n\n'
        'Common Uses: Windows applications, Game development '
        '(Unity), Enterprise software',

    ProgrammingLanguage.php:
        'PHP was created by Rasmus Lerdorf in 1994. It started '
        'as a simple set of tools that he created for '
        'his own personal website — the original meaning '
        'of PHP was "Personal Home Page". Eventually, it became '
        'one of the most widely used server-side scripting languages '
        'on the entire internet.\n\n'
        'Fun Facts:\n'
        '• A large part of the web uses PHP behind the '
        'scenes — including WordPress.\n'
        '• All variables in PHP have a "\$" at the beginning of their names.\n\n'
        'Common Uses: Web backend development, Content management '
        'systems, Server-side scripting',

    ProgrammingLanguage.javascript:
        'JavaScript was created by Brendan Eich (Netscape) in just '
        'TEN DAYS in 1995! It was originally created just to '
        'work inside the web browser (Netscape), but now '
        'it is also used on the server-side (via Node.js).\n\n'
        'Fun Facts:\n'
        '• Despite the similar name, JavaScript and Java have '
        'NO relation to each other.\n'
        '• JavaScript is one of the languages that can run '
        'directly inside a web browser.\n\n'
        'Common Uses: Web development (frontend), Server-side '
        '(Node.js), Mobile apps',
  },

  quizByLanguage: languageIntroQuizByLanguage,
);
