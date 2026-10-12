import 'code_editor_screen.dart' show ProgrammingLanguage;

/// Isang pagpipilian sa isang quiz question.
class QuizOption {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});
}

/// Isang tanong sa quiz — multiple choice, may explanation na ipinapakita
/// pagkatapos sumagot (tama man o mali).
class QuizQuestion {
  final String id;
  final String prompt;
  final String? code; // opsyonal — kung may laman, ipapakita bilang code block
  final List<QuizOption> options;
  final String correctOptionId;
  final String explanation;
  final String correctFeedback;
  final String incorrectFeedback;

  const QuizQuestion({
    required this.id,
    required this.prompt,
    this.code,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    this.correctFeedback = 'Tama!',
    this.incorrectFeedback = 'Hindi pa tama.',
  });
}

// =======================================================================
// Quiz: "Paano Gumagana ang Compiler?" — PAREHO sa lahat ng languages,
// dahil universal ang konsepto ng tokens/lexical analysis.
// =======================================================================
const List<QuizQuestion> compilerIntroQuiz = [
  QuizQuestion(
    id: 'ci_q1',
    prompt:
        'Ano ang tawag sa pagpapahati ng code sa maliliit na piraso '
        'bago ito intindihin ng compiler?',
    options: [
      QuizOption(id: 'a', text: 'Lexical Analysis'),
      QuizOption(id: 'b', text: 'Syntax Analysis'),
      QuizOption(id: 'c', text: 'Code Generation'),
      QuizOption(id: 'd', text: 'Compilation'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Lexical Analysis nga!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang Lexical Analysis ang unang hakbang ng compiler, kung saan '
        'hinahati ang code sa mga tokens — parang paghahati ng '
        'pangungusap sa mga salita.',
  ),
  QuizQuestion(
    id: 'ci_q2',
    prompt: 'Sa code na "int x = 5;", ano ang klase ng token ng "x"?',
    options: [
      QuizOption(id: 'a', text: 'Keyword'),
      QuizOption(id: 'b', text: 'Identifier'),
      QuizOption(id: 'c', text: 'Literal'),
      QuizOption(id: 'd', text: 'Operator'),
    ],
    correctOptionId: 'b',
    correctFeedback: 'Tama! Identifier nga!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang "x" ay identifier dahil ito ang pangalan ng variable, hindi '
        'ito built-in na salita (keyword) o value (literal).',
  ),
];

// =======================================================================
// Quiz: "Ang Balangkas ng Isang Programa" — PER LANGUAGE, dahil magkaiba
// ang boilerplate ng bawat isa.
// =======================================================================

const List<QuizQuestion> _programStructureQuizJava = [
  QuizQuestion(
    id: 'ps_java_q1',
    prompt:
        'Sa Java, ano ang tawag sa "public static void main(String[] args)"?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Entry point — dito nagsisimula ang pagtakbo ng program',
      ),
      QuizOption(id: 'b', text: 'Isang comment lang, hindi importante'),
      QuizOption(id: 'c', text: 'Pangalan ng variable'),
      QuizOption(id: 'd', text: 'Isang uri ng loop'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama, entry point nga!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang "main" method ang entry point ng bawat Java program — dito '
        'nagsisimula ang pagtakbo. Ang "static" ay nangangahulugang hindi na '
        'kailangang gumawa ng object para ito patakbuhin, at ang "void" ay '
        'nangangahulugang walang ibinabalik na value.',
  ),
  QuizQuestion(
    id: 'ps_java_q2',
    prompt: 'Ano ang ibig sabihin ng "public" sa "public class Main"?',
    options: [
      QuizOption(id: 'a', text: 'Puwedeng ma-access mula kahit saan'),
      QuizOption(id: 'b', text: 'Pribado lang, hindi ma-access sa labas'),
      QuizOption(id: 'c', text: 'Isang uri ng loop'),
      QuizOption(id: 'd', text: 'Walang kahulugan, decorative lang'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang "public" ay nangangahulugang puwedeng ma-access ang class o '
        'method mula kahit saan, hindi restricted.',
  ),
];

const List<QuizQuestion> _programStructureQuizCpp = [
  QuizQuestion(
    id: 'ps_cpp_q1',
    prompt: 'Sa C++, ano ang ginagawa ng linyang "#include <iostream>"?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'Isinasama nito ang library na may mga tools para sa input/output',
      ),
      QuizOption(id: 'b', text: 'Tinatapos nito ang program'),
      QuizOption(id: 'c', text: 'Gumagawa ito ng bagong variable'),
      QuizOption(id: 'd', text: 'Nagpi-print ito ng "Hello, World!"'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama, library ito para sa input/output!',
    incorrectFeedback: 'Hindi pa tama, subukan ulit.',
    explanation:
        'Ang "#include <iostream>" ay "isinasama" ang library na tinatawag '
        'na "iostream", na naglalaman ng mga tools para sa input/output '
        'tulad ng "cout" (para sa pag-print) at "cin" (para sa pag-input).',
  ),
  QuizQuestion(
    id: 'ps_cpp_q2',
    prompt: 'Ano ang ginagawa ng "return 0;" sa dulo ng main()?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Nagsasabing successful ang pagtakbo ng program',
      ),
      QuizOption(id: 'b', text: 'May error sa program'),
      QuizOption(id: 'c', text: 'Nag-uulit ulit ang program'),
      QuizOption(id: 'd', text: 'Nagpi-print lang ng zero'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang 0 ay nagsasabi sa operating system na walang problema/'
        'successful ang pagtakbo ng program.',
  ),
];

const List<QuizQuestion> _programStructureQuizPython = [
  QuizQuestion(
    id: 'ps_py_q1',
    prompt:
        'Bakit walang kailangang class o entry point declaration sa Python?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'Dahil sinusunod lang ng Python ang code nang sunud-sunod '
            'mula taas hanggang baba',
      ),
      QuizOption(
        id: 'b',
        text: 'Dahil hindi totoong programming language ang Python',
      ),
      QuizOption(id: 'c', text: 'Dahil bawal ang functions sa Python'),
      QuizOption(id: 'd', text: 'Dahil laging may error ang Python'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Sinusunod lang ng Python ang code sequentially, kaya walang '
        'kailangang special na "entry point" tulad ng ibang languages.',
  ),
  QuizQuestion(
    id: 'ps_py_q2',
    prompt: 'Alin sa mga sumusunod ang VALID at KUMPLETONG Python program?',
    options: [
      QuizOption(id: 'a', text: 'print("Hello")'),
      QuizOption(id: 'b', text: 'public class Main { print("Hello"); }'),
      QuizOption(id: 'c', text: 'int main() { print("Hello"); }'),
      QuizOption(id: 'd', text: 'function main() { print("Hello"); }'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Sapat na ang isang linya sa Python — walang kailangang wrapper o '
        'entry point declaration.',
  ),
];

const List<QuizQuestion> _programStructureQuizJs = [
  QuizQuestion(
    id: 'ps_js_q1',
    prompt:
        'Kailan lang natin kailangan gamitin ang "function" keyword sa '
        'JavaScript?',
    options: [
      QuizOption(id: 'a', text: 'Kapag gagawa ng reusable/custom na function'),
      QuizOption(id: 'b', text: 'Palagi, sa bawat linya ng code'),
      QuizOption(id: 'c', text: 'Kapag magpi-print lang'),
      QuizOption(id: 'd', text: 'Hindi ito ginagamit kailanman'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Optional lang ang function declarations sa JavaScript, ginagamit '
        'lang kapag kailangan ng reusable code.',
  ),
  QuizQuestion(
    id: 'ps_js_q2',
    prompt: 'Ano ang ginagamit sa JavaScript para mag-print sa console?',
    options: [
      QuizOption(id: 'a', text: 'console.log()'),
      QuizOption(id: 'b', text: 'print()'),
      QuizOption(id: 'c', text: 'echo'),
      QuizOption(id: 'd', text: 'System.out.println()'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang console.log() ang standard na paraan ng pag-print sa '
        'JavaScript.',
  ),
];

const List<QuizQuestion> _programStructureQuizCs = [
  QuizQuestion(
    id: 'ps_cs_q1',
    prompt: 'Alin sa mga sumusunod ang TAMANG pagsulat ng entry point sa C#?',
    options: [
      QuizOption(id: 'a', text: 'static void main(string[] args)'),
      QuizOption(id: 'b', text: 'static void Main(string[] args)'),
      QuizOption(id: 'c', text: 'public void MAIN(string[] args)'),
      QuizOption(id: 'd', text: 'void main()'),
    ],
    correctOptionId: 'b',
    correctFeedback: 'Tama! Napansin mo yung malaking "M"!',
    incorrectFeedback: 'Halos tama, pero tignan ulit ang capitalization.',
    explanation:
        'Sa C#, malaking letrang "M" ang "Main" — hindi tulad ng Java na '
        'maliit na "m" lang. Case-sensitive ang programming languages, kaya '
        'mahalaga na eksakto ang pagkasulat.',
  ),
  QuizQuestion(
    id: 'ps_cs_q2',
    prompt: 'Ano ang function ng "using System;" sa C#?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Isinasama ang System namespace na naglalaman ng Console',
      ),
      QuizOption(id: 'b', text: 'Nagpapatakbo ng system commands'),
      QuizOption(id: 'c', text: 'Gumagawa ng bagong operating system'),
      QuizOption(id: 'd', text: 'Nagde-delete ng mga files'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Katulad ng #include sa C++, ang "using" ay nag-i-import ng '
        'namespace para magamit ang mga tools nito.',
  ),
];

const List<QuizQuestion> _programStructureQuizPhp = [
  QuizQuestion(
    id: 'ps_php_q1',
    prompt:
        'Sa PHP, ano ang ginagamit para markahan kung saan NAGSISIMULA at '
        'NATATAPOS ang PHP code sa loob ng isang file?',
    options: [
      QuizOption(id: 'a', text: '// simula at // tapos'),
      QuizOption(id: 'b', text: '<?php at ?>'),
      QuizOption(id: 'c', text: 'BEGIN at END'),
      QuizOption(id: 'd', text: '{ at }'),
    ],
    correctOptionId: 'b',
    correctFeedback: 'Tama, yan yung PHP tags!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Sa PHP, ang "<?php" at "?>" ay ginagamit para markahan kung saan '
        'nagsisimula at natatapos ang PHP code, dahil sa totoong mundo '
        'madalas naghahalo ang PHP at HTML sa parehong file.',
  ),
  QuizQuestion(
    id: 'ps_php_q2',
    prompt:
        'Bakit kailangan ng PHP ng ganitong tags samantalang wala nito '
        'ang Python?',
    options: [
      QuizOption(
        id: 'a',
        text:
            'Dahil karaniwang naghahalo ang PHP ng code at HTML sa '
            'parehong file',
      ),
      QuizOption(id: 'b', text: 'Dahil mas mahina ang PHP'),
      QuizOption(id: 'c', text: 'Dahil walang variables ang PHP'),
      QuizOption(id: 'd', text: 'Dahil hindi totoong language ang PHP'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Sa totoong mundo, madalas gamitin ang PHP sa loob ng HTML files, '
        'kaya kailangan ng malinaw na hangganan kung saan nagsisimula/'
        'natatapos ang code.',
  ),
];

/// Pinagsama-samang quiz para sa "Ang Balangkas ng Isang Programa" — isang
/// Map na kinukuha ng lesson.dart at ipinapasa bilang "quizByLanguage".
const Map<ProgrammingLanguage, List<QuizQuestion>>
programStructureQuizByLanguage = {
  ProgrammingLanguage.java: _programStructureQuizJava,
  ProgrammingLanguage.cpp: _programStructureQuizCpp,
  ProgrammingLanguage.python: _programStructureQuizPython,
  ProgrammingLanguage.javascript: _programStructureQuizJs,
  ProgrammingLanguage.csharp: _programStructureQuizCs,
  ProgrammingLanguage.php: _programStructureQuizPhp,
};
const List<QuizQuestion> _languageIntroQuizJava = [
  QuizQuestion(
    id: 'li_java_q1',
    prompt: 'Sino ang gumawa ng Java?',
    options: [
      QuizOption(id: 'a', text: 'James Gosling'),
      QuizOption(id: 'b', text: 'Guido van Rossum'),
      QuizOption(id: 'c', text: 'Bjarne Stroustrup'),
      QuizOption(id: 'd', text: 'Brendan Eich'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Si James Gosling nga!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ginawa ni James Gosling ang Java noong 1995 sa Sun Microsystems.',
  ),
  QuizQuestion(
    id: 'li_java_q2',
    prompt: 'Ano ang orihinal na pangalan ng Java bago ito naging "Java"?',
    options: [
      QuizOption(id: 'a', text: 'Oak'),
      QuizOption(id: 'b', text: 'Coffee'),
      QuizOption(id: 'c', text: 'Beans'),
      QuizOption(id: 'd', text: 'Sun'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! "Oak" nga ang unang pangalan!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang orihinal na pangalan ni Java ay "Oak", pinangalanan sa isang '
        'puno sa labas ng opisina ni Gosling.',
  ),
];

const List<QuizQuestion> _languageIntroQuizCpp = [
  QuizQuestion(
    id: 'li_cpp_q1',
    prompt: 'Sino ang gumawa ng C++?',
    options: [
      QuizOption(id: 'a', text: 'Bjarne Stroustrup'),
      QuizOption(id: 'b', text: 'James Gosling'),
      QuizOption(id: 'c', text: 'Anders Hejlsberg'),
      QuizOption(id: 'd', text: 'Rasmus Lerdorf'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ginawa ni Bjarne Stroustrup ang C++ noong 1985 bilang extension ng '
        'C language.',
  ),
  QuizQuestion(
    id: 'li_cpp_q2',
    prompt: 'Ano ang orihinal na tawag sa C++ bago ito naging "C++"?',
    options: [
      QuizOption(id: 'a', text: '"C with Classes"'),
      QuizOption(id: 'b', text: '"Super C"'),
      QuizOption(id: 'c', text: '"New C"'),
      QuizOption(id: 'd', text: '"C Plus"'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Noong una, literal na tinawag itong "C with Classes" bago naging '
        'C++.',
  ),
];

const List<QuizQuestion> _languageIntroQuizPython = [
  QuizQuestion(
    id: 'li_py_q1',
    prompt: 'Saan hango ang pangalang "Python"?',
    options: [
      QuizOption(
        id: 'a',
        text: '"Monty Python\'s Flying Circus" (British comedy show)',
      ),
      QuizOption(id: 'b', text: 'Sa hayop na ahas'),
      QuizOption(id: 'c', text: 'Sa pangalan ni Guido van Rossum'),
      QuizOption(id: 'd', text: 'Walang kahulugan, random lang'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Hindi nga sa ahas!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Pinangalanan si Python sa "Monty Python\'s Flying Circus", isang '
        'British comedy show — hindi sa ahas!',
  ),
  QuizQuestion(
    id: 'li_py_q2',
    prompt: 'Bakit walang { } braces si Python para sa blocks ng code?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Ginagamit nito ang indentation (spacing) sa halip',
      ),
      QuizOption(id: 'b', text: 'Hindi pa updated si Python'),
      QuizOption(id: 'c', text: 'Bawal ang braces sa lahat ng languages'),
      QuizOption(id: 'd', text: 'Kailangan pa itong i-install'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Dinisenyo si Python para madaling basahin, kaya indentation na '
        'lang ang gumagawa ng blocks, hindi braces.',
  ),
];

const List<QuizQuestion> _languageIntroQuizCs = [
  QuizQuestion(
    id: 'li_cs_q1',
    prompt: 'Sinong kompanya ang gumawa ng C#?',
    options: [
      QuizOption(id: 'a', text: 'Microsoft'),
      QuizOption(id: 'b', text: 'Sun Microsystems'),
      QuizOption(id: 'c', text: 'Google'),
      QuizOption(id: 'd', text: 'Netscape'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ginawa ni Anders Hejlsberg ang C# bilang bahagi ng .NET framework '
        'ng Microsoft.',
  ),
  QuizQuestion(
    id: 'li_cs_q2',
    prompt: 'Ano ang tinutukoy ng "#" sa pangalang "C#"?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Musical na "sharp" — parang C na "pinataas" ang antas',
      ),
      QuizOption(id: 'b', text: 'Bilang ng features nito'),
      QuizOption(id: 'c', text: 'Walang kahulugan, symbol lang'),
      QuizOption(id: 'd', text: 'Version number'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ang "#" ay tumutukoy sa musical na "sharp", parang C na pinataas '
        'ang antas.',
  ),
];

const List<QuizQuestion> _languageIntroQuizPhp = [
  QuizQuestion(
    id: 'li_php_q1',
    prompt: 'Ano ang orihinal na ibig sabihin ng "PHP"?',
    options: [
      QuizOption(id: 'a', text: 'Personal Home Page'),
      QuizOption(id: 'b', text: 'Programming Hypertext Processor'),
      QuizOption(id: 'c', text: 'Public Hosting Platform'),
      QuizOption(id: 'd', text: 'Private Home Program'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Nagsimula si PHP bilang tools ni Rasmus Lerdorf para sa sarili '
        'niyang personal na website, kaya "Personal Home Page" ang ibig '
        'sabihin nito noong una.',
  ),
  QuizQuestion(
    id: 'li_php_q2',
    prompt:
        'Anong sikat na CMS (content management system) ang gumagamit ng PHP?',
    options: [
      QuizOption(id: 'a', text: 'WordPress'),
      QuizOption(id: 'b', text: 'Photoshop'),
      QuizOption(id: 'c', text: 'Excel'),
      QuizOption(id: 'd', text: 'Unity'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Malaking bahagi ng web ay gumagamit ng PHP sa likod ng eksena — '
        'kasama na ang WordPress.',
  ),
];

const List<QuizQuestion> _languageIntroQuizJs = [
  QuizQuestion(
    id: 'li_js_q1',
    prompt: 'Ilang araw lang ginawa ni Brendan Eich ang JavaScript?',
    options: [
      QuizOption(id: 'a', text: '10 araw'),
      QuizOption(id: 'b', text: '1 taon'),
      QuizOption(id: 'c', text: '1 buwan'),
      QuizOption(id: 'd', text: '100 araw'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Sampung araw lang talaga!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Ginawa ni Brendan Eich ang JavaScript sa loob lamang ng SAMPUNG '
        'ARAW noong 1995.',
  ),
  QuizQuestion(
    id: 'li_js_q2',
    prompt: 'May kaugnayan ba sina JavaScript at Java sa isa\'t isa?',
    options: [
      QuizOption(
        id: 'a',
        text: 'Wala, magkaiba silang language kahit magkatulad ang pangalan',
      ),
      QuizOption(id: 'b', text: 'Oo, parehong kompanya ang gumawa'),
      QuizOption(id: 'c', text: 'Oo, si Java ay bahagi ng JavaScript'),
      QuizOption(id: 'd', text: 'Oo, pareho silang tumatakbo sa JVM'),
    ],
    correctOptionId: 'a',
    correctFeedback: 'Tama! Iba talaga sila kahit magkatulad ang pangalan!',
    incorrectFeedback: 'Hindi pa tama.',
    explanation:
        'Kahit magkatulad ang pangalan, WALANG kaugnayan sina JavaScript '
        'at Java sa isa\'t isa.',
  ),
];

/// Pinagsama-samang quiz para sa "Kilalanin ang Language" lesson.
const Map<ProgrammingLanguage, List<QuizQuestion>> languageIntroQuizByLanguage =
    {
      ProgrammingLanguage.java: _languageIntroQuizJava,
      ProgrammingLanguage.cpp: _languageIntroQuizCpp,
      ProgrammingLanguage.python: _languageIntroQuizPython,
      ProgrammingLanguage.csharp: _languageIntroQuizCs,
      ProgrammingLanguage.php: _languageIntroQuizPhp,
      ProgrammingLanguage.javascript: _languageIntroQuizJs,
    };
