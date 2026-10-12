import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizIfelse = [
  QuizQuestion(
    id: 'php_ifelse_q1',
    prompt: 'Which keyword does PHP use for the one-word "else if" branch?',
    options: [
      QuizOption(id: 'a', text: 'elseif'),
      QuizOption(id: 'b', text: 'elif'),
      QuizOption(id: 'c', text: 'else_if'),
      QuizOption(id: 'd', text: 'otherwise'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP supports both "elseif" and "else if" — "elseif" is the common '
        'idiomatic one-word form.',
  ),
  QuizQuestion(
    id: 'php_ifelse_q2',
    prompt: 'What must surround the condition in a PHP if statement?',
    options: [
      QuizOption(id: 'a', text: 'Parentheses ( )'),
      QuizOption(id: 'b', text: 'Square brackets [ ]'),
      QuizOption(id: 'c', text: 'Nothing is needed'),
      QuizOption(id: 'd', text: 'Curly braces only'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'Like Java and C++, PHP requires the condition to be wrapped in '
        r'parentheses: if ($age >= 18) { }.',
  ),
  QuizQuestion(
    id: 'php_ifelse_q3',
    prompt: 'What marks the start and end of a PHP if block\'s body?',
    options: [
      QuizOption(id: 'a', text: 'Curly braces { }'),
      QuizOption(id: 'b', text: 'A semicolon ;'),
      QuizOption(id: 'c', text: 'The keyword "end"'),
      QuizOption(id: 'd', text: 'Indentation level'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP uses curly braces to group statements into a block, just like '
        'Java and C++ — unlike Python, which relies on indentation.',
  ),
];
