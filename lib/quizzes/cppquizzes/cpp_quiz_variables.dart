import '../../screens/quiz_data.dart';

const List<QuizQuestion> cppQuizVariables = [
  QuizQuestion(
    id: 'cpp_var_q1',
    prompt:
        'Bago gumamit ng "string" bilang type sa C++, anong header ang '
        'kailangang i-include?',
    options: [
      QuizOption(id: 'a', text: '#include <string>'),
      QuizOption(id: 'b', text: '#include <iostream>'),
      QuizOption(id: 'c', text: '#include <text>'),
      QuizOption(id: 'd', text: 'Hindi na kailangan ng header'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Kailangang i-include ang <string> para magamit ang "string" type '
        'sa C++.',
  ),
  QuizQuestion(
    id: 'cpp_var_q2',
    prompt: 'Alin sa mga sumusunod ang TAMANG paggawa ng int variable sa C++?',
    options: [
      QuizOption(id: 'a', text: 'int edad = 20;'),
      QuizOption(id: 'b', text: 'edad int = 20;'),
      QuizOption(id: 'c', text: 'variable edad = 20;'),
      QuizOption(id: 'd', text: '20 = edad;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Kagaya ng ibang statically-typed languages, TYPE muna bago '
        'pangalan bago "= value;" — kaya "int edad = 20;" ang tama.',
  ),
  QuizQuestion(
    id: 'cpp_var_q3',
    prompt:
        'Anong TYPE ang gagamitin mo sa C++ para sa text tulad ng '
        '"Kumusta"?',
    options: [
      QuizOption(id: 'a', text: 'string'),
      QuizOption(id: 'b', text: 'int'),
      QuizOption(id: 'c', text: 'bool'),
      QuizOption(id: 'd', text: 'double'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "string" ang ginagamit sa C++ para sa text/salita (may '
        '#include <string> na kailangan).',
  ),
];
