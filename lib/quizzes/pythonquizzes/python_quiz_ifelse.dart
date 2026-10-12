import '../../screens/quiz_data.dart';

const List<QuizQuestion> pythonQuizIfelse = [
  QuizQuestion(
    id: 'python_ifelse_q1',
    prompt: 'What keyword does Python use instead of "else if"?',
    options: [
      QuizOption(id: 'a', text: 'elif'),
      QuizOption(id: 'b', text: 'elseif'),
      QuizOption(id: 'c', text: 'else_if'),
      QuizOption(id: 'd', text: 'otherwise'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python\'s keyword is "elif" — a shortened form unique to Python, '
        'different from PHP\'s "elseif".',
  ),
  QuizQuestion(
    id: 'python_ifelse_q2',
    prompt: 'What punctuation is required at the end of an if line in Python?',
    options: [
      QuizOption(id: 'a', text: 'A colon :'),
      QuizOption(id: 'b', text: 'A semicolon ;'),
      QuizOption(id: 'c', text: 'A curly brace {'),
      QuizOption(id: 'd', text: 'Nothing at all'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Every if, elif, and else line in Python ends with a colon, which '
        'introduces the indented block that follows.',
  ),
  QuizQuestion(
    id: 'python_ifelse_q3',
    prompt: 'How does Python know which lines belong inside an if block?',
    options: [
      QuizOption(id: 'a', text: 'Indentation (consistent spacing)'),
      QuizOption(id: 'b', text: 'Curly braces { }'),
      QuizOption(id: 'c', text: 'The keyword "end"'),
      QuizOption(id: 'd', text: 'Parentheses'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Python uses indentation, not braces, to define code blocks — this '
        'is the biggest structural difference from Java, C++, and PHP.',
  ),
];
