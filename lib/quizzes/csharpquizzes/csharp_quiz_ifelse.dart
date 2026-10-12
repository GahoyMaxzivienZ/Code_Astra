import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizIfelse = [
  QuizQuestion(
    id: 'csharp_ifelse_q1',
    prompt: 'What must surround the condition in a C# if statement?',
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
        'C# requires parentheses around the condition, e.g. '
        'if (age >= 18) { }.',
  ),
  QuizQuestion(
    id: 'csharp_ifelse_q2',
    prompt: 'How do you write an "else if" branch in C#?',
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
        'C# writes it as two words, "else if", just like Java and C++ — '
        'unlike PHP\'s "elseif" or Python\'s "elif".',
  ),
  QuizQuestion(
    id: 'csharp_ifelse_q3',
    prompt: 'What marks the body of a C# if block?',
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
        'C# groups statements with curly braces, just like Java, C++, and '
        'PHP.',
  ),
];
