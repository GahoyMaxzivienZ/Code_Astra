import '../../screens/quiz_data.dart';

const List<QuizQuestion> javaQuizComparisons = [
  QuizQuestion(
    id: 'comp_q1',
    prompt: 'Ano ang TYPE ng resulta ng isang comparison, hal. "5 > 3"?',
    options: [
      QuizOption(id: 'a', text: 'boolean (true o false)'),
      QuizOption(id: 'b', text: 'int'),
      QuizOption(id: 'c', text: 'String'),
      QuizOption(id: 'd', text: 'Walang resulta'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Laging boolean (true o false) ang resulta ng comparison operators.',
  ),
  QuizQuestion(
    id: 'comp_q2',
    prompt: 'Ano ang pagkakaiba ng "=" sa "=="?',
    options: [
      QuizOption(
        id: 'a',
        text: '"=" ay para mag-assign, "==" ay para i-compare kung pareho',
      ),
      QuizOption(id: 'b', text: 'Walang pagkakaiba, pareho lang sila'),
      QuizOption(id: 'c', text: '"==" ay para mag-assign ng dalawang beses'),
      QuizOption(id: 'd', text: '"=" ay para lang sa String'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Common mistake ito kaya ingat!',
    explanation:
        'Ang "=" ay nag-a-assign ng value sa isang variable, habang ang '
        '"==" ay ginagamit para i-COMPARE kung pareho ang dalawang value.',
  ),
  QuizQuestion(
    id: 'comp_q3',
    prompt: 'Ano ang ibig sabihin ng operator na "!="?',
    options: [
      QuizOption(id: 'a', text: 'Hindi pareho (not equal to)'),
      QuizOption(id: 'b', text: 'Pareho (equal to)'),
      QuizOption(id: 'c', text: 'Mas malaki'),
      QuizOption(id: 'd', text: 'Mas maliit'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation: 'Ang "!=" ay nagsasabing "hindi pareho" ang dalawang value.',
  ),
];
