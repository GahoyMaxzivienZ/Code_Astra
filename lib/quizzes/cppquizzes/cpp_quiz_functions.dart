import '../../screens/quiz_data.dart';

const List<QuizQuestion> cppQuizFunctions = [
  QuizQuestion(
    id: 'cpp_func_q1',
    prompt: 'Ano ang gamit ng "return" sa loob ng isang function?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Ibinabalik nito ang value papunta sa nagtawag (caller)',
      ),
      QuizOption(id: 'b', text: 'Tinatapos nito ang buong program'),
      QuizOption(id: 'c', text: 'Nagpi-print ito sa screen'),
      QuizOption(id: 'd', text: 'Gumagawa ito ng bagong loop'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "return" ay nagpapabalik ng value mula sa function papunta '
        'sa lugar kung saan ito tinawag.',
  ),
  QuizQuestion(
    id: 'cpp_func_q2',
    prompt:
        'Anong RETURN_TYPE ang gagamitin kung walang ibabalik na value ang '
        'function sa C++?',
    options: [
      QuizOption(id: 'a', text: 'void'),
      QuizOption(id: 'b', text: 'int'),
      QuizOption(id: 'c', text: 'null'),
      QuizOption(id: 'd', text: 'empty'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "void" ang ginagamit kung walang ibinabalik na value ang '
        'function.',
  ),
  QuizQuestion(
    id: 'cpp_func_q3',
    prompt: 'Sa "int square(int n) { return n * n; }", ano ang "n" dito?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Isang parameter — input na kailangan ng function',
      ),
      QuizOption(id: 'b', text: 'Ang pangalan ng function'),
      QuizOption(id: 'c', text: 'Ang return type'),
      QuizOption(id: 'd', text: 'Isang comment lang'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "n" ay isang parameter — ito ang input na kailangang ipasa '
        'kapag tatawagin ang function na "square".',
  ),
];
