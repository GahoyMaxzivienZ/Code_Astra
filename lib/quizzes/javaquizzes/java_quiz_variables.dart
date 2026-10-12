import '../../screens/quiz_data.dart';

const List<QuizQuestion> javaQuizVariables = [
  QuizQuestion(
    id: 'var_q1',
    prompt: 'Ano ang ibig sabihin ng "static typing" sa Java?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'Kailangan mong ideklara ang TYPE ng variable bago ito '
            'gamitin',
      ),
      QuizOption(id: 'b', text: 'Hindi na pwedeng baguhin ang value nito'),
      QuizOption(id: 'c', text: 'Laging naka-capitalize ang pangalan nito'),
      QuizOption(id: 'd', text: 'Isang uri ng loop'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Sa Java, kailangan mong sabihin muna ang TYPE (int, String, atbp.) '
        'bago gumawa ng variable — ito ang tinatawag na static typing.',
  ),
  QuizQuestion(
    id: 'var_q2',
    prompt: 'Alin sa mga sumusunod ang TAMANG paggawa ng int variable?',
    options: [
      QuizOption(id: 'a', text: 'int edad = 20;'),
      QuizOption(id: 'b', text: 'edad int = 20;'),
      QuizOption(id: 'c', text: 'variable edad = 20;'),
      QuizOption(id: 'd', text: '20 = edad;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang tamang pagkakasunod-sunod ay TYPE, tapos pangalan, tapos '
        '"= value;" — kaya "int edad = 20;" ang tama.',
  ),
  QuizQuestion(
    id: 'var_q3',
    prompt: 'Anong TYPE ang gagamitin mo para sa text tulad ng "Kumusta"?',
    options: [
      QuizOption(id: 'a', text: 'String'),
      QuizOption(id: 'b', text: 'int'),
      QuizOption(id: 'c', text: 'boolean'),
      QuizOption(id: 'd', text: 'double'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang String ang ginagamit sa Java para sa text/salita — laging '
        'naka-quote ang value nito.',
  ),
];
