import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizComparisons = [
  QuizQuestion(
    id: 'csharp_comparisons_q1',
    prompt: 'What does == check when comparing two int values in C#?',
    options: [
      QuizOption(id: 'a', text: 'Whether their values are equal'),
      QuizOption(id: 'b', text: 'Whether they are the same object in memory'),
      QuizOption(id: 'c', text: 'Whether they have the same type name'),
      QuizOption(id: 'd', text: 'Nothing — == does not work on numbers'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'For value types like int, == compares the actual values, just '
        'like in Java or C++.',
  ),
  QuizQuestion(
    id: 'csharp_comparisons_q2',
    prompt: 'Does C# have a separate strict-equality operator like === in PHP or JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'No — C# only has =='),
      QuizOption(id: 'b', text: 'Yes, it is ==='),
      QuizOption(id: 'c', text: 'Yes, it is !='),
      QuizOption(id: 'd', text: 'Yes, it is equals'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'C# is strongly typed, so there is no silent type conversion during '
        'comparison — a single == is enough.',
  ),
  QuizQuestion(
    id: 'csharp_comparisons_q3',
    prompt: 'What does "5 != 3" evaluate to in C#?',
    options: [
      QuizOption(id: 'a', text: 'true'),
      QuizOption(id: 'b', text: 'false'),
      QuizOption(id: 'c', text: '1'),
      QuizOption(id: 'd', text: 'An error'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation: '5 is not equal to 3, so the != comparison returns true.',
  ),
];
