import '../../screens/quiz_data.dart';

const List<QuizQuestion> javaQuizFor = [
  QuizQuestion(
    id: 'for_q1',
    prompt: 'Anong TATLONG bagay ang pinagsasama ng for loop sa isang linya?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Starting value, condition, at pagbabago ng counter',
      ),
      QuizOption(id: 'b', text: 'Tatlong magkaibang variables'),
      QuizOption(id: 'c', text: 'Tatlong magkaibang functions'),
      QuizOption(id: 'd', text: 'Tatlong if statements'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Pinagsasama ng for loop sa isang linya ang (1) starting value, '
        '(2) condition, at (3) kung paano magbabago ang counter bawat '
        'iteration.',
  ),
  QuizQuestion(
    id: 'for_q2',
    prompt: 'Kailan mas mainam gamitin ang FOR loop kaysa WHILE loop?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Kapag ALAM MO NA kung ilang beses dapat mag-ulit',
      ),
      QuizOption(id: 'b', text: 'Kapag hindi mo alam kung ilang beses'),
      QuizOption(id: 'c', text: 'Palagi mong dapat gamitin ang while'),
      QuizOption(id: 'd', text: 'Walang pagkakaiba ang dalawa'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Mas ginagamit ang for loop kapag alam mo na kung ilang beses dapat '
        'mag-ulit, habang ang while loop ay ginagamit kung hindi natin '
        'alam nang eksakto.',
  ),
  QuizQuestion(
    id: 'for_q3',
    prompt:
        'Sa "for (int i = 0; i < 5; i++)", ano ang HULING value ng i na '
        'papasok sa loob ng loop?',
    options: [
      QuizOption(id: 'a', text: '4'),
      QuizOption(id: 'b', text: '5'),
      QuizOption(id: 'c', text: '0'),
      QuizOption(id: 'd', text: '6'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Mula i=0 hanggang i=4 lang papasok sa loop, dahil titigil na kapag '
        'i=5 (hindi na totoo ang "i < 5").',
  ),
];
