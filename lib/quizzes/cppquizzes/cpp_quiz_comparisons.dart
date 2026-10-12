import '../../screens/quiz_data.dart';

const List<QuizQuestion> cppQuizComparisons = [
  QuizQuestion(
    id: 'cpp_comp_q1',
    prompt:
        'Kapag walang "boolalpha", ano ang ipi-print ng cout para sa isang '
        'TRUE na boolean sa C++?',
    options: [
      QuizOption(id: 'a', text: '1'),
      QuizOption(id: 'b', text: '"true"'),
      QuizOption(id: 'c', text: '"TRUE"'),
      QuizOption(id: 'd', text: 'Walang lalabas'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Sanay dyan yung C++ quirk!',
    explanation:
        'Sa C++, ang DEFAULT na pag-print ng boolean ay 1 (true) o 0 '
        '(false), hindi "true"/"false" — maliban kung gagamit ka ng '
        '"cout << boolalpha;" bago ito.',
  ),
  QuizQuestion(
    id: 'cpp_comp_q2',
    prompt: 'Ano ang pagkakaiba ng "=" sa "=="?',
    options: [
      QuizOption(
        id: 'a',
        text: '"=" ay para mag-assign, "==" ay para i-compare kung pareho',
      ),
      QuizOption(id: 'b', text: 'Walang pagkakaiba, pareho lang sila'),
      QuizOption(id: 'c', text: '"==" ay para mag-assign ng dalawang beses'),
      QuizOption(id: 'd', text: '"=" ay para lang sa string'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "=" ay nag-a-assign ng value, habang ang "==" ay '
        'nag-ko-compare kung pareho ang dalawang value.',
  ),
  QuizQuestion(
    id: 'cpp_comp_q3',
    prompt: 'Ano ang gamit ng "cout << boolalpha;" sa C++?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Para lumabas na "true"/"false" ang boolean sa halip na 1/0',
      ),
      QuizOption(id: 'b', text: 'Para i-convert ang int papuntang boolean'),
      QuizOption(id: 'c', text: 'Para gumawa ng bagong boolean variable'),
      QuizOption(id: 'd', text: 'Wala itong epekto'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "boolalpha" ay nag-aayos kung paano ipinapakita ng cout ang '
        'boolean values — magiging "true"/"false" sa halip na 1/0.',
  ),
];
