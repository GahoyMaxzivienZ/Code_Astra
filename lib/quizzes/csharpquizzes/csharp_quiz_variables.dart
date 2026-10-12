import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizVariables = [
  QuizQuestion(
    id: 'csharp_variables_q1',
    prompt: 'Which of these is a valid C# variable declaration?',
    options: [
      QuizOption(id: 'a', text: 'int age = 20;'),
      QuizOption(id: 'b', text: 'age = 20;'),
      QuizOption(id: 'c', text: r'$age = 20;'),
      QuizOption(id: 'd', text: 'age: int = 20;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Like Java, C# requires you to declare a type before the variable '
        'name, e.g. int age = 20;.',
  ),
  QuizQuestion(
    id: 'csharp_variables_q2',
    prompt: 'What does the "var" keyword do in C#?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Lets the compiler infer the type from the assigned value',
      ),
      QuizOption(id: 'b', text: 'Makes the variable global'),
      QuizOption(id: 'c', text: 'Removes the need for a value'),
      QuizOption(id: 'd', text: 'Makes the variable a constant'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'var age = 20; still creates a strongly-typed int variable — the '
        'compiler just figures out the type for you instead of you writing '
        'it explicitly.',
  ),
  QuizQuestion(
    id: 'csharp_variables_q3',
    prompt: 'What must end every C# statement?',
    options: [
      QuizOption(id: 'a', text: 'A semicolon ;'),
      QuizOption(id: 'b', text: 'A colon :'),
      QuizOption(id: 'c', text: 'Nothing'),
      QuizOption(id: 'd', text: 'A period .'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation: 'C# statements end with a semicolon, just like Java and C++.',
  ),
];
