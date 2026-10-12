import '../screens/code_editor_screen.dart' show ProgrammingLanguage;

/// Isang linya ng code kasama ang (kung meron) paliwanag dito.
///
/// `explanation` ay null para sa mga linyang wala munang partikular na
/// paliwanag (hal. tuldok-kuwit lang o simpleng closing brace na sunod
/// agad sa dati nang na-explain na block) — ipinapakita pa rin ang linya,
/// pero hindi na dinadagdagan ng redundant na text.
class LineExplanation {
  final int lineNumber;
  final String text;
  final String? explanation;
  final bool isErrorLine;

  const LineExplanation({
    required this.lineNumber,
    required this.text,
    required this.explanation,
    this.isErrorLine = false,
  });
}

/// Heuristic (pattern/regex-based) na line-by-line na "tagapaliwanag" ng
/// code — hindi ito totoong static analyzer, katulad lang ng
/// [CodeHighlighter] (regex-based rin) at [ErrorTips] (keyword-based rin).
/// Layunin ay magbigay ng mabilis, beginner-friendly na paliwanag bawat
/// linya, sa Tagalog/Taglish, katulad ng tono ng ibang parte ng app.
class CodeLineExplainer {
  CodeLineExplainer._();

  /// Sinusuri ang buong `code` at nagbabalik ng isang [LineExplanation]
  /// bawat *di-blangkong* linya. Kung may `errorLine` (kinuha mula sa error
  /// message ng compiler), yung linyang iyon ay minamarkahan bilang
  /// `isErrorLine: true` para ma-highlight ito sa UI.
  static List<LineExplanation> explain(
    String code,
    ProgrammingLanguage language, {
    int? errorLine,
  }) {
    final lines = code.split('\n');
    final result = <LineExplanation>[];
    String? openBlockLabel; // panandang "ano ang huling binuksang block"

    for (var i = 0; i < lines.length; i++) {
      final raw = lines[i];
      final line = raw.trim();
      final lineNumber = i + 1;

      if (line.isEmpty) continue;

      final explanation = _explainLine(line, language, openBlockLabel);
      if (explanation.opensBlockLabel != null) {
        openBlockLabel = explanation.opensBlockLabel;
      }

      result.add(
        LineExplanation(
          lineNumber: lineNumber,
          text: raw,
          explanation: explanation.text,
          isErrorLine: errorLine == lineNumber,
        ),
      );
    }

    return result;
  }

  /// Kinukuha ang line number mula sa isang error message ng compiler,
  /// hal. `'...sa line 4...'` o `'...line 12...'`. Nagbabalik ng null kung
  /// walang mahanap na numero.
  static int? errorLineFrom(String errorMessage) {
    final match = RegExp(
      r'line\s+(\d+)',
      caseSensitive: false,
    ).firstMatch(errorMessage);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }

  static _LineVerdict _explainLine(
    String line,
    ProgrammingLanguage lang,
    String? openBlockLabel,
  ) {
    final isPython = lang == ProgrammingLanguage.python;
    final isPhp = lang == ProgrammingLanguage.php;

    // ---- Comments ----
    if (line.startsWith('//') || line.startsWith('#')) {
      return _LineVerdict(
        'Comment lang ito — hindi ito tumatakbo, paalala/paliwanag lang '
        'ito para sa nagbabasa ng code.',
      );
    }

    // ---- PHP open/close tags ----
    if (line.startsWith('<?php')) {
      return _LineVerdict('Dito nagsisimula ang PHP code block.');
    }
    if (line == '?>') {
      return _LineVerdict('Dito natatapos ang PHP code block.');
    }

    // ---- C++ "using namespace X;" ----
    final namespaceMatch = RegExp(r'^using\s+namespace\s+(\w+)')
        .firstMatch(line);
    if (namespaceMatch != null) {
      return _LineVerdict(
        'Ginagawa nitong available ang lahat ng laman ng '
        '"${namespaceMatch.group(1)}" namespace, para hindi na kailangang '
        'ilagay ang prefix nito sa bawat gamit (hal. "cout" imbes na '
        '"${namespaceMatch.group(1)}::cout").',
      );
    }

    // ---- Imports / includes ----
    final importMatch = RegExp(r'^(?:import|using|#include)\s+[<"]?([\w.\/]+)')
        .firstMatch(line);
    if (importMatch != null) {
      return _LineVerdict(
        'Ini-import/nilo-load nito ang "${importMatch.group(1)}" para '
        'magamit ang mga ready-made na tools/functions nito sa code.',
      );
    }

    // ---- Class declaration ----
    final classMatch = RegExp(r'\bclass\s+(\w+)').firstMatch(line);
    if (classMatch != null) {
      return _LineVerdict(
        'Dito nagsisimula ang class na "${classMatch.group(1)}" — parang '
        'blueprint ito na naglalaman ng mga function/data ng program.',
        opensBlockLabel: 'class',
      );
    }

    // ---- Function / method definitions ----
    final funcName = _functionDefName(line, lang);
    if (funcName != null) {
      if (funcName.toLowerCase() == 'main') {
        return _LineVerdict(
          'Ito ang "main" — dito talaga nagsisimula ang pagtakbo ng buong '
          'program pag pinatakbo ito.',
          opensBlockLabel: 'function',
        );
      }
      final params = _paramListOf(line);
      return _LineVerdict(
        'Dito dine-define ang function na "$funcName"'
        '${params == null || params.isEmpty ? '' : ' na tumatanggap ng ($params) bilang parameter'}'
        '. Hindi pa ito tumatakbo dito — tatakbo lang ito pag "tinawag/kina-call" '
        'sa ibang parte ng code.',
        opensBlockLabel: 'function',
      );
    }

    // ---- Print / output statements ----
    final printText = _printArgsOf(line, isPhp: isPhp);
    if (printText != null) {
      return _LineVerdict(
        'Nagpi-print ito papunta sa output/console'
        '${printText.isEmpty ? '' : ' ng: $printText'}.',
      );
    }

    // ---- Return statement ----
    final returnMatch = RegExp(r'^return\b\s*(.*?);?$').firstMatch(line);
    if (returnMatch != null) {
      final expr = returnMatch.group(1)?.trim() ?? '';
      return _LineVerdict(
        expr.isEmpty
            ? 'Ibinabalik/nire-return nito ang control papunta sa function '
                  'na tumawag dito, wala itong ibinabalik na value.'
            : 'Ibinabalik/nire-return nito ang value ng "$expr" papunta sa '
                  'function na tumawag dito.',
      );
    }

    // ---- If / else if / else ----
    if (RegExp(r'^(if|elif)\s*\(').hasMatch(line) ||
        (isPython && RegExp(r'^(if|elif)\b').hasMatch(line))) {
      return _LineVerdict(
        'Isang "if" condition ito — kung TAMA (true) ang sinusuri nitong '
        'kondisyon, saka lang tatakbo ang code sa loob ng block na ito.',
        opensBlockLabel: 'if',
      );
    }
    if (line.startsWith('else if') || line.startsWith('} else if')) {
      return _LineVerdict(
        'Isa pang kondisyon ito na sinusuri lang kapag mali/false ang '
        'naunang "if" (o "else if").',
        opensBlockLabel: 'if',
      );
    }
    if (line == 'else' ||
        line == 'else:' ||
        line == '} else' ||
        line == '} else {') {
      return _LineVerdict(
        'Ito ang tatakbo kapag mali/false ang lahat ng naunang '
        '"if"/"else if" na kondisyon.',
        opensBlockLabel: 'else',
      );
    }

    // ---- Loops ----
    if (RegExp(r'^for\s*\(').hasMatch(line) ||
        (isPython && line.startsWith('for '))) {
      return _LineVerdict(
        'Isang "for" loop ito — uulitin nito ang code sa loob ng block '
        'hanggang matapos ang binilang na kondisyon.',
        opensBlockLabel: 'loop',
      );
    }
    if (RegExp(r'^while\s*\(').hasMatch(line) ||
        (isPython && line.startsWith('while '))) {
      return _LineVerdict(
        'Isang "while" loop ito — patuloy na uulitin ang code sa loob ng '
        'block habang TAMA (true) pa rin ang kondisyon nito.',
        opensBlockLabel: 'loop',
      );
    }

    // ---- Lone braces (block markers) ----
    if (line == '{') {
      return _LineVerdict(
        'Nagmamarka ito ng simula ng isang code block'
        '${openBlockLabel == null ? '' : ' (yung sa "$openBlockLabel" sa taas)'}'
        '.',
      );
    }
    if (RegExp(r'^\}\s*$').hasMatch(line) ||
        RegExp(r'^\}\s*;?\s*$').hasMatch(line)) {
      return _LineVerdict('Nagmamarka ito ng dulo ng isang code block.');
    }

    // ---- Variable declaration / assignment ----
    final varMatch = _variableAssignment(line, lang);
    if (varMatch != null) {
      final (name, value) = varMatch;
      return _LineVerdict(
        value.isEmpty
            ? 'Gumagawa ito ng variable na pinangalanang "$name".'
            : 'Gumagawa ito ng variable na pinangalanang "$name" at '
                  'inilalagay dito ang resulta/value ng "$value".',
      );
    }

    // ---- Bare function call, e.g. doSomething(1, 2); ----
    final callMatch = RegExp(r'^(\w+)\s*\(([^;]*)\)\s*;?$').firstMatch(line);
    if (callMatch != null && !_keywordsAll.contains(callMatch.group(1))) {
      final args = callMatch.group(2)?.trim() ?? '';
      return _LineVerdict(
        'Tinatawag/kina-call nito ang function na "${callMatch.group(1)}"'
        '${args.isEmpty ? '' : ' gamit ang ($args) bilang argumento'}.',
      );
    }

    // ---- Fallback ----
    return const _LineVerdict(
      'Regular na statement ito na bahagi ng logic ng program.',
    );
  }

  static const Set<String> _keywordsAll = {
    'if',
    'else',
    'for',
    'while',
    'switch',
    'return',
    'class',
  };

  static String? _functionDefName(String line, ProgrammingLanguage lang) {
    if (lang == ProgrammingLanguage.python) {
      final m = RegExp(r'^def\s+(\w+)\s*\(').firstMatch(line);
      return m?.group(1);
    }
    if (lang == ProgrammingLanguage.javascript) {
      final m1 = RegExp(r'^function\s+(\w+)\s*\(').firstMatch(line);
      if (m1 != null) return m1.group(1);
    }
    if (lang == ProgrammingLanguage.php) {
      final m = RegExp(r'^function\s+(\w+)\s*\(').firstMatch(line);
      if (m != null) return m.group(1);
    }
    // Java / C++ / C# style: [modifiers] returnType name(params) {
    final m = RegExp(
      r'^(?:public\s+|private\s+|protected\s+|static\s+|final\s+)*'
      r'[\w<>\[\]]+\s+(\w+)\s*\([^;]*\)\s*\{?\s*$',
    ).firstMatch(line);
    if (m != null) {
      final name = m.group(1)!;
      // Huwag i-match ang mga if/for/while na naka-espasyo bago ng "(".
      if (!_keywordsAll.contains(name)) return name;
    }
    return null;
  }

  static String? _paramListOf(String line) {
    final m = RegExp(r'\(([^)]*)\)').firstMatch(line);
    return m?.group(1)?.trim();
  }

  static String? _printArgsOf(String line, {required bool isPhp}) {
    final patterns = <RegExp>[
      RegExp(r'^System\.out\.println?\s*\((.*)\)\s*;?$'),
      RegExp(r'^console\.log\s*\((.*)\)\s*;?$'),
      RegExp(r'^print\s*\((.*)\)\s*:?$'), // python print(...)
      RegExp(r'^cout\s*<<\s*(.*?)\s*;?$'), // C++ cout << ...
      RegExp(r'^Console\.Write(?:Line)?\s*\((.*)\)\s*;?$'), // C#
    ];
    for (final p in patterns) {
      final m = p.firstMatch(line);
      if (m != null) return m.group(1)?.trim() ?? '';
    }
    if (isPhp && line.startsWith('echo')) {
      return line.substring(4).trim().replaceAll(RegExp(r';\s*$'), '');
    }
    return null;
  }

  /// Sinusubukang tukuyin kung declaration/assignment ang linya, at
  /// ibinabalik ang (variable name, value expression) kung meron.
  static (String, String)? _variableAssignment(
    String line,
    ProgrammingLanguage lang,
  ) {
    // PHP: $x = value;
    final php = RegExp(r'^\$(\w+)\s*=\s*(.*?);?$').firstMatch(line);
    if (php != null) {
      return (php.group(1)!, php.group(2)?.trim() ?? '');
    }

    // let/var/const x = value;  (JS)
    final jsDecl = RegExp(r'^(?:let|var|const)\s+(\w+)\s*=\s*(.*?);?$')
        .firstMatch(line);
    if (jsDecl != null) {
      return (jsDecl.group(1)!, jsDecl.group(2)?.trim() ?? '');
    }

    // Typed decl (Java/C++/C#): int x = value;  or  int x;
    final typed = RegExp(
      r'^(?:final\s+|static\s+|const\s+)*[A-Za-z_][\w<>\[\],\s]*?\s+(\w+)\s*=\s*(.*?);?$',
    ).firstMatch(line);
    if (typed != null && !_keywordsAll.contains(typed.group(1))) {
      return (typed.group(1)!, typed.group(2)?.trim() ?? '');
    }
    final typedNoInit = RegExp(
      r'^(?:final\s+|static\s+|const\s+)*[A-Za-z_][\w<>\[\]]*\s+(\w+)\s*;$',
    ).firstMatch(line);
    if (typedNoInit != null) {
      return (typedNoInit.group(1)!, '');
    }

    // Python / plain reassignment: x = value  (walang tuldok-kuwit, may "=" pero hindi "==")
    if (lang == ProgrammingLanguage.python ||
        !line.contains('(') && line.contains('=') && !line.contains('==')) {
      final plain = RegExp(r'^(\w+)\s*=\s*(.*?)$').firstMatch(line);
      if (plain != null && !_keywordsAll.contains(plain.group(1))) {
        return (plain.group(1)!, plain.group(2)?.trim() ?? '');
      }
    }

    return null;
  }
}

class _LineVerdict {
  final String text;
  final String? opensBlockLabel;
  const _LineVerdict(this.text, {this.opensBlockLabel});
}
