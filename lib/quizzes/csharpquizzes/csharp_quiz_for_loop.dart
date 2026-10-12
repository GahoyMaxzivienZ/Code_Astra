import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizForLoop = [
  QuizQuestion(
    id: 'csharp_for_loop_q1',
    prompt:
        'In "for (int i = 0; i < 10; i++) { }", what does the middle part do?',
    options: [
      QuizOption(
        id: 'a',
        text: "It's the condition checked before each iteration",
      ),
      QuizOption(id: 'b', text: 'It initializes the loop variable'),
      QuizOption(id: 'c', text: 'It runs after each iteration'),
      QuizOption(id: 'd', text: "It's the loop body"),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'A C# for loop has initialization; condition; increment — the '
        'middle part is the condition.',
  ),
  QuizQuestion(
    id: 'csharp_for_loop_q2',
    prompt: 'How many times does "for (int i = 0; i < 5; i++)" run?',
    options: [
      QuizOption(id: 'a', text: '5 times (0 through 4)'),
      QuizOption(id: 'b', text: '4 times'),
      QuizOption(id: 'c', text: '6 times'),
      QuizOption(id: 'd', text: 'Forever'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'i runs from 0 until i < 5 becomes false, giving 0, 1, 2, 3, 4 — '
        'five iterations.',
  ),
  QuizQuestion(
    id: 'csharp_for_loop_q3',
    prompt:
        'Where must you declare the loop variable\'s type in a C# for loop?',
    options: [
      QuizOption(id: 'a', text: 'In the initialization part, e.g. "int i = 0"'),
      QuizOption(id: 'b', text: 'You never declare a type'),
      QuizOption(id: 'c', text: 'Outside the loop, always'),
      QuizOption(id: 'd', text: 'In the increment part'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Like Java, C# requires a type for the loop variable, usually '
        'declared right in the initialization section.',
  ),
];
