import '../../screens/quiz_data.dart';

const List<QuizQuestion> cppQuizArithmetic = [
  QuizQuestion(
    id: 'cpp_arith_q1',
    prompt:
        'Ano ang resulta ng "7 / 2" kung int at int ang dalawang numero '
        'sa C++?',
    options: [
      QuizOption(id: 'a', text: '3 (int division, walang decimal)'),
      QuizOption(id: 'b', text: '3.5'),
      QuizOption(id: 'c', text: '4'),
      QuizOption(id: 'd', text: 'Magkakaroon ng error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Int division, aalisin ang decimal part!',
    explanation:
        'Kapag int ang dalawang numero, "int division" ang mangyayari — '
        'aalisin ang decimal part, kaya 3 lang ang sagot, hindi 3.5.',
  ),
  QuizQuestion(
    id: 'cpp_arith_q2',
    prompt: 'Ano ang ginagawa ng "%" (modulo) operator sa C++?',
    options: [
      QuizOption(id: 'a', text: 'Ibinabalik ang natitira pagkatapos maghati'),
      QuizOption(id: 'b', text: 'Nagpaparami ng dalawang numero'),
      QuizOption(id: 'c', text: 'Kumukuha ng percentage'),
      QuizOption(id: 'd', text: 'Nagbabago ng int papuntang double'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang modulo (%) ay nagbibigay ng "natitira" pagkatapos maghati — '
        'hal. 7 % 2 = 1.',
  ),
  QuizQuestion(
    id: 'cpp_arith_q3',
    prompt:
        'Alin ang unang gagawin sa "2 + 3 * 4" batay sa order of operations?',
    options: [
      QuizOption(id: 'a', text: '3 * 4 muna (multiplication bago addition)'),
      QuizOption(id: 'b', text: '2 + 3 muna'),
      QuizOption(id: 'c', text: 'Kaliwa papuntang kanan, walang priority'),
      QuizOption(id: 'd', text: 'Random lang ang pagkakasunod'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Sinusunod ng C++ ang PEMDAS — mauuna ang multiplication/division '
        'bago ang addition/subtraction.',
  ),
];
