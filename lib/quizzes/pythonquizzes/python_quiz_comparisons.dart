import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizComparisons = [
  QuizQuestion(
    id: 'python_comparisons_q1',
    prompt: 'What does "5" == 5 evaluate to in Python?',
    options: [
      QuizOption(id: 'a', text: 'False — a string and an int are never equal'),
      QuizOption(id: 'b', text: 'True'),
      QuizOption(id: 'c', text: 'An error'),
      QuizOption(id: 'd', text: 'None'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Unlike PHP, Python\'s == does not convert types before comparing — '
        'a string and an integer are simply different types, so they\'re not '
        'equal.',
  ),
  QuizQuestion(
    id: 'python_comparisons_q2',
    prompt: 'Is there a separate strict-equality operator (like === in PHP) in Python?',
    options: [
      QuizOption(id: 'a', text: 'No — == already checks both value and type'),
      QuizOption(id: 'b', text: 'Yes, it\'s also ==='),
      QuizOption(id: 'c', text: 'Yes, it\'s =='),
      QuizOption(id: 'd', text: 'No equality operator exists in Python'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Since Python doesn\'t silently convert types for ==, there\'s no '
        'need for a separate "strict" comparison operator.',
  ),
  QuizQuestion(
    id: 'python_comparisons_q3',
    prompt: 'What does "1 < x < 10" mean in Python?',
    options: [
      QuizOption(
        id: 'a',
        text: 'True only if x is greater than 1 AND less than 10',
      ),
      QuizOption(id: 'b', text: 'Always evaluates to True'),
      QuizOption(id: 'c', text: 'A syntax error'),
      QuizOption(id: 'd', text: 'Same as just "1 < x"'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python supports chained comparisons — "1 < x < 10" is short for '
        '"1 < x and x < 10", a feature Java, C++, and PHP don\'t have.',
  ),
];
