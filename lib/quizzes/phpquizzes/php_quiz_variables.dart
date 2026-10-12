import '../../screens/quiz_data.dart';

const List<QuizQuestion> phpQuizVariables = [
  QuizQuestion(
    id: 'php_variables_q1',
    prompt: 'What symbol must come before every variable name in PHP?',
    options: [
      QuizOption(id: 'a', text: r'$ (dollar sign)'),
      QuizOption(id: 'b', text: '@ (at sign)'),
      QuizOption(id: 'c', text: '# (hash)'),
      QuizOption(id: 'd', text: '& (ampersand)'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'In PHP, every variable name starts with a dollar sign, e.g. $age = 25;. '
        'This is different from Java or C++, where you write a type before the name '
        'instead.',
  ),
  QuizQuestion(
    id: 'php_variables_q2',
    prompt: "Do you need to declare a variable's type before using it in PHP?",
    options: [
      QuizOption(id: 'a', text: 'No — PHP figures out the type automatically'),
      QuizOption(id: 'b', text: 'Yes, always write int, string, etc. first'),
      QuizOption(id: 'c', text: 'Only for numbers'),
      QuizOption(id: 'd', text: 'Only inside functions'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'PHP is loosely typed — it determines a variable\'s type automatically '
        'based on the value you assign, with no type keyword needed.',
  ),
  QuizQuestion(
    id: 'php_variables_q3',
    prompt: 'Which of these is a valid PHP variable declaration?',
    options: [
      QuizOption(id: 'a', text: r'$total_score = 100;'),
      QuizOption(id: 'b', text: 'total_score = 100;'),
      QuizOption(id: 'c', text: r'int $total_score = 100;'),
      QuizOption(id: 'd', text: 'var total_score = 100;'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        r'A PHP variable needs the $ sign and no type keyword — just '
        r'$total_score = 100;.',
  ),
];
