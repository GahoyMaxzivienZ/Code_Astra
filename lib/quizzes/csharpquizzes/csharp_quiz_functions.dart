import '../../screens/quiz_data.dart';

const List<QuizQuestion> csharpQuizFunctions = [
  QuizQuestion(
    id: 'csharp_functions_q1',
    prompt: 'What must you declare before a method name in C#?',
    options: [
      QuizOption(id: 'a', text: 'Its return type (e.g. int, string, void)'),
      QuizOption(id: 'b', text: 'Nothing at all'),
      QuizOption(id: 'c', text: 'The "function" keyword'),
      QuizOption(id: 'd', text: 'The "def" keyword'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'Just like Java, every C# method needs a declared return type, or '
        '"void" if it returns nothing.',
  ),
  QuizQuestion(
    id: 'csharp_functions_q2',
    prompt: 'Why is "static" often used on methods called directly from Main() in C#?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'Because Main() itself is static and can only directly call '
            'other static members',
      ),
      QuizOption(id: 'b', text: 'It makes the method run faster'),
      QuizOption(id: 'c', text: 'It is required for all methods in C#'),
      QuizOption(id: 'd', text: 'It hides the method from other classes'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'A static Main() method can call other static methods directly '
        'without needing to create an object first.',
  ),
  QuizQuestion(
    id: 'csharp_functions_q3',
    prompt: 'What does "return" do inside a C# method?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Sends a value back to the caller and ends the method',
      ),
      QuizOption(id: 'b', text: 'Prints a value to the console'),
      QuizOption(id: 'c', text: 'Starts the method over'),
      QuizOption(id: 'd', text: 'Declares a new variable'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Correct!',
    incorrectFeedback: 'Not quite.',
    explanation:
        'return exits the method immediately and hands the given value '
        'back to whoever called it.',
  ),
];
