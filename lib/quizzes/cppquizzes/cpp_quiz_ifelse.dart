import '../../screens/quiz_data.dart';

const List<QuizQuestion> cppQuizIfElse = [
  QuizQuestion(
    id: 'cpp_ifelse_q1',
    prompt: 'Kailan tatakbo ang code sa loob ng "else" block?',
    options: [
      QuizOption(id: 'a', text: 'Kapag FALSE ang condition sa "if"'),
      QuizOption(id: 'b', text: 'Kapag TRUE ang condition sa "if"'),
      QuizOption(id: 'c', text: 'Palaging tumatakbo ito'),
      QuizOption(id: 'd', text: 'Kailanman hindi ito tumatakbo'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang "else" block ay tumatakbo lamang kapag FALSE ang condition sa '
        '"if".',
  ),
  QuizQuestion(
    id: 'cpp_ifelse_q2',
    prompt: 'Anong uri ng value ang dapat nasa loob ng () ng "if" sa C++?',
    options: [
      QuizOption(id: 'a', text: 'boolean expression (true o false)'),
      QuizOption(id: 'b', text: 'int lang'),
      QuizOption(id: 'c', text: 'string lang'),
      QuizOption(id: 'd', text: 'Kahit anong type'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ang condition sa loob ng () ay dapat magre-resolve sa boolean — '
        'kadalasan galing sa mga comparison operators.',
  ),
  QuizQuestion(
    id: 'cpp_ifelse_q3',
    prompt: 'Kailan mo gagamitin ang "else if"?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Kapag may higit sa dalawang posibleng landas na susundin',
      ),
      QuizOption(id: 'b', text: 'Kapag isa lang ang posibleng landas'),
      QuizOption(id: 'c', text: 'Hindi ito kailanman ginagamit'),
      QuizOption(id: 'd', text: 'Kapag gagawa ng loop'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    explanation:
        'Ginagamit ang "else if" kapag may higit sa dalawang posibleng '
        'landas na dapat suriin nang sunud-sunod.',
  ),
];
