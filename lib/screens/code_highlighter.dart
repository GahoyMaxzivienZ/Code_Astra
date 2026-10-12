import 'package:flutter/material.dart';

import 'code_editor_screen.dart' show ProgrammingLanguage;

/// Munting syntax highlighter — hindi ito full parser/AST, regex-based lang
/// siya, pero sapat na para bigyan ng kulay ang code (kagaya ng editor themes
/// na nakasanayan na ng mga estudyante, tulad ng VS Code Dark+).
///
/// Layunin: gawing "buhay" ang tingin ng code examples sa app, hindi lang
/// plain-white monospace text.
class CodeHighlighter {
  // Kulay na sinusunod sa VS Code "Dark+" theme, para pamilyar agad
  // ang mga estudyante kapag nakakita sila ng totoong editor.
  static const Color colorKeyword = Color(0xFF569CD6); // asul
  static const Color colorType = Color(0xFF4EC9B0); // teal
  static const Color colorString = Color(0xFFCE9178); // orange
  static const Color colorComment = Color(0xFF6A9955); // berde-gray
  static const Color colorNumber = Color(0xFFB5CEA8); // light green
  static const Color colorMethod = Color(0xFFDCDCAA); // dilaw
  static const Color colorDefault = Color(0xFFD4D4D4); // off-white
  static const Color colorPunctuation = Color(0xFF9CA3AF); // gray

  static const Set<String> _keywords = {
    'public',
    'private',
    'protected',
    'static',
    'void',
    'class',
    'int',
    'return',
    'if',
    'else',
    'for',
    'while',
    'new',
    'const',
    'let',
    'var',
    'function',
    'def',
    'import',
    'using',
    'namespace',
    'include',
    'echo',
    'print',
    'true',
    'false',
    'null',
    'None',
    'True',
    'False',
    'this',
    'final',
    'try',
    'catch',
    'throw',
    'break',
    'continue',
    'switch',
    'case',
    'do',
    'in',
    'of',
    'as',
    'from',
    'export',
    'default',
    'async',
    'await',
  };

  static const Set<String> _types = {
    'String',
    'string',
    'int',
    'Integer',
    'double',
    'float',
    'bool',
    'boolean',
    'char',
    'long',
    'short',
    'Object',
    'Main',
    'Program',
    'iostream',
    'System',
    'Console',
    'cout',
    'cin',
    'endl',
    'std',
  };

  /// Nagbabalik ng mga TextSpan na may kulay, ipapasa lang sa isang
  /// RichText/Text.rich widget.
  static List<TextSpan> highlight(String code, ProgrammingLanguage language) {
    final spans = <TextSpan>[];
    final pattern = RegExp(
      r'(//.*?$)' // single-line comment (C-style)
      r'|(#.*?$)' // single-line comment (Python/PHP-style)
      r'|("(?:[^"\\]|\\.)*")' // double-quoted string
      r"|('(?:[^'\\]|\\.)*')" // single-quoted string
      r'|(\b\d+\.?\d*\b)' // numbers
      r'|(\b[A-Za-z_][A-Za-z0-9_]*\b)' // words (keywords/types/identifiers)
      r'|(<\?php|\?>)', // PHP tags
      multiLine: true,
    );

    int lastEnd = 0;
    for (final match in pattern.allMatches(code)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: code.substring(lastEnd, match.start),
            style: const TextStyle(color: colorDefault),
          ),
        );
      }

      final text = match[0]!;
      Color color = colorDefault;

      if (match[1] != null || match[2] != null) {
        color = colorComment;
      } else if (match[3] != null || match[4] != null) {
        color = colorString;
      } else if (match[5] != null) {
        color = colorNumber;
      } else if (match[7] != null) {
        color = colorKeyword; // <?php / ?>
      } else if (match[6] != null) {
        final word = match[6]!;
        if (_keywords.contains(word)) {
          color = colorKeyword;
        } else if (_types.contains(word)) {
          color = colorType;
        } else if (RegExp(r'^[A-Z]').hasMatch(word)) {
          color = colorType;
        } else {
          color = colorDefault;
        }
      }

      spans.add(
        TextSpan(
          text: text,
          style: TextStyle(color: color),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < code.length) {
      spans.add(
        TextSpan(
          text: code.substring(lastEnd),
          style: const TextStyle(color: colorDefault),
        ),
      );
    }

    return spans;
  }

  static String labelFor(ProgrammingLanguage language) {
    switch (language) {
      case ProgrammingLanguage.java:
        return 'Main.java';
      case ProgrammingLanguage.cpp:
        return 'main.cpp';
      case ProgrammingLanguage.python:
        return 'main.py';
      case ProgrammingLanguage.javascript:
        return 'main.js';
      case ProgrammingLanguage.csharp:
        return 'Program.cs';
      case ProgrammingLanguage.php:
        return 'index.php';
    }
  }
}

/// Code box na may "faux terminal" top bar (traffic-light dots + filename) —
/// ito yung ginagamit sa Halimbawa/Code Example section.
class HighlightedCodeBox extends StatelessWidget {
  final String code;
  final ProgrammingLanguage language;
  final Color accentColor;

  const HighlightedCodeBox({
    super.key,
    required this.code,
    required this.language,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF181825),
              border: Border(
                bottom: BorderSide(color: Color(0xFF2A2A3D), width: 1),
              ),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F56)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF27C93F)),
                const SizedBox(width: 10),
                Text(
                  CodeHighlighter.labelFor(language),
                  style: TextStyle(
                    color: accentColor.withOpacity(0.9),
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Code
          Padding(
            padding: const EdgeInsets.all(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text.rich(
                TextSpan(children: CodeHighlighter.highlight(code, language)),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
