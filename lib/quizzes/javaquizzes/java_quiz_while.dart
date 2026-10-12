import '../../screens/quiz_data.dart';

const List<QuizQuestion> javaQuizWhile = [
  QuizQuestion(
    id: 'while_q1',
    prompt: 'Kailan chine-check ang condition ng while loop?',
    options: [
      QuizOption(id: 'a', text: 'Bago ang BAWAT pag-uulit (iteration)'),
      QuizOption(id: 'b', text: 'Pagkatapos lang ng bawat iteration'),
      QuizOption(id: 'c', text: 'Isang beses lang, sa simula'),
      QuizOption(id: 'd', text: 'Hindi ito chine-check'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Chine-check ang condition BAGO ang bawat iteration — kapag naging '
        'FALSE ito, tumitigil ang loop.',
  ),
  QuizQuestion(
    id: 'while_q2',
    prompt:
        'Ano ang mangyayari kung walang nagbabago sa loob ng while loop '
        'na makakapagpa-false sa condition?',
    options: [
      QuizOption(id: 'a', text: 'Magiging infinite loop, hindi na titigil'),
      QuizOption(id: 'b', text: 'Isang beses lang tatakbo'),
      QuizOption(id: 'c', text: 'Magkakaroon ng compile error agad'),
      QuizOption(id: 'd', text: 'Automatic na titigil pagkatapos ng 10x'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Mag-ingat sa infinite loops!',
    explanation:
        'Kung hindi nagbabago ang variable na sinusuri ng condition, '
        'magiging TRUE ito habang buhay — infinite loop na hindi na '
        'titigil.',
  ),
  QuizQuestion(
    id: 'while_q3',
    prompt:
        'Sa "int i = 1; while (i <= 5) { ...; i++; }", ilang beses '
        'tatakbo ang loop?',
    options: [
      QuizOption(id: 'a', text: '5 beses'),
      QuizOption(id: 'b', text: '4 beses'),
      QuizOption(id: 'c', text: '6 beses'),
      QuizOption(id: 'd', text: 'Walang hanggan'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Mula i=1 hanggang i=5 (kasama), 5 beses tatakbo bago maging FALSE '
        'ang "i <= 5" kapag umabot na sa i=6.',
  ),
];
