import '../../screens/quiz_data.dart';

const List<QuizQuestion> jsQuizIfelse = [
  QuizQuestion(
    id: 'js_ifelse_q1',
    prompt: 'How do you write an "else if" branch in JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'else if (condition) { }'),
      QuizOption(id: 'b', text: 'elseif (condition) { }'),
      QuizOption(id: 'c', text: 'elif condition:'),
      QuizOption(id: 'd', text: 'otherwise (condition) { }'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript writes it as two words, "else if", same as Java, C++, '
        'and C#.',
  ),
  QuizQuestion(
    id: 'js_ifelse_q2',
    prompt: 'What must surround the condition in a JavaScript if statement?',
    options: [
      QuizOption(id: 'a', text: 'Parentheses ( )'),
      QuizOption(id: 'b', text: 'Square brackets [ ]'),
      QuizOption(id: 'c', text: 'Nothing'),
      QuizOption(id: 'd', text: 'A colon'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript requires parentheses around the condition, e.g. '
        'if (age >= 18) { }.',
  ),
  QuizQuestion(
    id: 'js_ifelse_q3',
    prompt: 'What marks the body of a JavaScript if block?',
    options: [
      QuizOption(id: 'a', text: 'Curly braces { }'),
      QuizOption(id: 'b', text: 'A colon and indentation'),
      QuizOption(id: 'c', text: 'The keyword "end"'),
      QuizOption(id: 'd', text: 'A semicolon'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'JavaScript groups statements with curly braces, just like Java, '
        'C++, C#, and PHP.',
  ),
];
