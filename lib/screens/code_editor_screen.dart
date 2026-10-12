import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/compiler_service.dart';
import 'code_highlighter.dart';
import 'code_output_screen.dart';

enum ProgrammingLanguage { java, cpp, python, javascript, csharp, php }

/// Custom TextInputFormatter na nag-a-auto-indent kapag pinindot ang Enter.
class AutoIndentFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final isSingleNewlineInsert =
        newValue.text.length == oldValue.text.length + 1 &&
        newValue.selection.baseOffset > 0 &&
        newValue.selection.baseOffset <= newValue.text.length &&
        newValue.text[newValue.selection.baseOffset - 1] == '\n';

    if (!isSingleNewlineInsert) return newValue;

    final cursor = newValue.selection.baseOffset;
    final textBeforeNewline = newValue.text.substring(0, cursor - 1);
    final lastLineStart = textBeforeNewline.lastIndexOf('\n') + 1;
    final previousLine = textBeforeNewline.substring(lastLineStart);

    final indentMatch = RegExp(r'^[ \t]*').firstMatch(previousLine);
    var indent = indentMatch?.group(0) ?? '';

    final trimmed = previousLine.trimRight();
    if (trimmed.endsWith('{') || trimmed.endsWith(':')) {
      indent += '    ';
    }

    if (indent.isEmpty) return newValue;

    final newText =
        newValue.text.substring(0, cursor) +
        indent +
        newValue.text.substring(cursor);
    final newCursor = cursor + indent.length;

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}

class CodeEditorScreen extends StatefulWidget {
  final ProgrammingLanguage initialLanguage;

  const CodeEditorScreen({
    super.key,
    this.initialLanguage = ProgrammingLanguage.java,
  });

  @override
  State<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  late ProgrammingLanguage _selectedLanguage;

  static const String _javaSample = '''public class Main {
    public static int add(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        int x = add(5, 3);
        System.out.println(x);
    }
}''';

  static const String _cppSample = '''#include <iostream>
using namespace std;

int add(int a, int b) {
    return a + b;
}

int main() {
    int x = add(5, 3);
    cout << "Result: " << x << endl;
    return 0;
}''';

  static const String _pythonSample = '''def add(a, b):
    return a + b

x = add(5, 3)
print("Result:", x)''';

  static const String _jsSample = '''function add(a, b) {
    return a + b;
}

let x = add(5, 3);
console.log("Result:", x);''';

  static const String _csSample = '''using System;

public class Program {
    static int Add(int a, int b) {
        return a + b;
    }

    static void Main(string[] args) {
        int x = Add(5, 3);
        Console.WriteLine(x);
    }
}''';

  static const String _phpSample = '''<?php
function add(\$a, \$b) {
    return \$a + \$b;
}

\$x = add(5, 3);
echo "Result: ", \$x, "\\n";
?>''';

  late final TextEditingController _codeController;
  final ScrollController _editorScrollController = ScrollController();

  static const _violet = Color(0xFF3C3489);
  static const _bg = Color(0xFFEDE9FB);

  static const TextStyle _codeTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'monospace',
    fontSize: 14,
    height: 1.5,
  );

  static const TextStyle _lineNumberStyle = TextStyle(
    color: Colors.white38,
    fontFamily: 'monospace',
    fontSize: 14,
    height: 1.5,
  );

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
    _codeController = TextEditingController(
      text: _sampleFor(_selectedLanguage),
    );
    _codeController.addListener(_onCodeChanged);
  }

  void _onCodeChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _codeController.removeListener(_onCodeChanged);
    _codeController.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  String _sampleFor(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.java:
        return _javaSample;
      case ProgrammingLanguage.cpp:
        return _cppSample;
      case ProgrammingLanguage.python:
        return _pythonSample;
      case ProgrammingLanguage.javascript:
        return _jsSample;
      case ProgrammingLanguage.csharp:
        return _csSample;
      case ProgrammingLanguage.php:
        return _phpSample;
    }
  }

  String _keyFor(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.java:
        return 'java';
      case ProgrammingLanguage.cpp:
        return 'cpp';
      case ProgrammingLanguage.python:
        return 'python';
      case ProgrammingLanguage.javascript:
        return 'javascript';
      case ProgrammingLanguage.csharp:
        return 'csharp';
      case ProgrammingLanguage.php:
        return 'php';
    }
  }

  void _onLanguageChanged(ProgrammingLanguage lang) {
    setState(() {
      _selectedLanguage = lang;
      _codeController.text = _sampleFor(lang);
    });
  }

  void _runCode() {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Walang code na i-ru-run. Mag-type ka muna.'),
        ),
      );
      return;
    }

    final CompilerResult result;
    switch (_selectedLanguage) {
      case ProgrammingLanguage.java:
        result = CompilerService.runJavaCode(code);
        break;
      case ProgrammingLanguage.cpp:
        result = CompilerService.runCppCode(code);
        break;
      case ProgrammingLanguage.python:
        result = CompilerService.runPythonCode(code);
        break;
      case ProgrammingLanguage.javascript:
        result = CompilerService.runJsCode(code);
        break;
      case ProgrammingLanguage.csharp:
        result = CompilerService.runCsCode(code);
        break;
      case ProgrammingLanguage.php:
        result = CompilerService.runPhpCode(code);
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CodeOutputScreen(
          code: code,
          language: _selectedLanguage,
          result: result,
          accentColor: _violet,
        ),
      ),
    );
  }

  void _clearCode() {
    setState(() {
      _codeController.clear();
    });
  }

  String _labelFor(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.java:
        return 'Java';
      case ProgrammingLanguage.cpp:
        return 'C++';
      case ProgrammingLanguage.python:
        return 'Python';
      case ProgrammingLanguage.javascript:
        return 'JavaScript';
      case ProgrammingLanguage.csharp:
        return 'C#';
      case ProgrammingLanguage.php:
        return 'PHP';
    }
  }

  IconData _iconFor(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.java:
        return Icons.coffee;
      case ProgrammingLanguage.cpp:
        return Icons.memory;
      case ProgrammingLanguage.python:
        return Icons.code;
      case ProgrammingLanguage.javascript:
        return Icons.javascript;
      case ProgrammingLanguage.csharp:
        return Icons.tag;
      case ProgrammingLanguage.php:
        return Icons.php;
    }
  }

  // ---------- Token Visualizer ----------

  static const Set<String> _operatorTypeNames = {
    'plus',
    'minus',
    'star',
    'slash',
    'assign',
    'equals',
    'notEquals',
    'greater',
    'less',
    'greaterEqual',
    'lessEqual',
    'shiftLeft',
  };

  static const Set<String> _symbolTypeNames = {
    'lparen',
    'rparen',
    'lbrace',
    'rbrace',
    'lbracket',
    'rbracket',
    'semicolon',
    'comma',
    'dot',
    'colon',
  };

  static const Set<String> _structuralTypeNames = {
    'newline',
    'indent',
    'dedent',
  };

  (String, Color) _categoryFor(String typeName) {
    if (typeName == 'eof') return ('special', Colors.grey);
    if (_structuralTypeNames.contains(typeName)) {
      return ('structural', Colors.teal);
    }
    if (typeName.endsWith('Kw')) return ('keyword', const Color(0xFF7C4DFF));
    if (typeName == 'identifier')
      return ('identifier', const Color(0xFF2196F3));
    if (typeName.contains('Literal'))
      return ('literal', const Color(0xFF43A047));
    if (_operatorTypeNames.contains(typeName)) {
      return ('operator', const Color(0xFFEF6C00));
    }
    if (_symbolTypeNames.contains(typeName)) return ('symbol', Colors.blueGrey);
    return ('iba pa', Colors.grey);
  }

  void _showTokenVisualizer() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wala pang code na i-a-analyze.')),
      );
      return;
    }

    List<TokenDisplay> tokens;
    try {
      tokens = CompilerService.tokenizeForLanguage(
        code,
        _keyFor(_selectedLanguage),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Hindi na-tokenize: $e')));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.token, color: _violet),
                      const SizedBox(width: 8),
                      Text(
                        'Mga Token (${tokens.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _violet,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _violet.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Ito ang unang hakbang ng compiler — tinatawag na "Lexical '
                      'Analysis". Hinahati muna ng compiler ang code mo sa mga '
                      'maliliit na "piraso" (tinatawag na tokens) bago pa man '
                      'niya subukang intindihin ang buong kahulugan nito.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _legendChip('keyword', const Color(0xFF7C4DFF)),
                      _legendChip('identifier', const Color(0xFF2196F3)),
                      _legendChip('literal', const Color(0xFF43A047)),
                      _legendChip('operator', const Color(0xFFEF6C00)),
                      _legendChip('symbol', Colors.blueGrey),
                    ],
                  ),
                ),
                const Divider(height: 20),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: tokens.length,
                    itemBuilder: (context, index) {
                      final token = tokens[index];
                      final (category, color) = _categoryFor(token.typeName);
                      return ListTile(
                        dense: true,
                        leading: SizedBox(
                          width: 36,
                          child: Text(
                            '${token.line}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          token.lexeme.isEmpty
                              ? '(walang laman)'
                              : token.lexeme,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${token.typeName} • $category',
                          style: TextStyle(fontSize: 11, color: color),
                        ),
                        trailing: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _legendChip(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = _codeController.text.split('\n').length;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _violet,
        foregroundColor: Colors.white,
        title: const Text('Code Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.token),
            tooltip: 'Tingnan ang Tokens',
            onPressed: _showTokenVisualizer,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear',
            onPressed: _clearCode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _violet.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProgrammingLanguage>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: _violet),
                  items: ProgrammingLanguage.values.map((lang) {
                    return DropdownMenuItem(
                      value: lang,
                      child: Row(
                        children: [
                          Icon(_iconFor(lang), size: 20, color: _violet),
                          const SizedBox(width: 10),
                          Text(_labelFor(lang)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (lang) {
                    if (lang != null) _onLanguageChanged(lang);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: _violet.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRect(
                        child: AnimatedBuilder(
                          animation: _editorScrollController,
                          builder: (context, child) {
                            final offset = _editorScrollController.hasClients
                                ? _editorScrollController.offset
                                : 0.0;
                            return Transform.translate(
                              offset: Offset(0, -offset),
                              child: child,
                            );
                          },
                          child: OverflowBox(
                            alignment: Alignment.topRight,
                            minHeight: 0,
                            maxHeight: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                lineCount,
                                (i) =>
                                    Text('${i + 1}', style: _lineNumberStyle),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: Colors.white12),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Stack(
                        children: [
                          // Naka-ilalim na highlighted na text (CodeHighlighter)
                          // — hindi ito interactive (IgnorePointer), sinisync
                          // lang ang scroll offset nito sa TextField sa itaas.
                          Positioned.fill(
                            child: ClipRect(
                              child: IgnorePointer(
                                child: AnimatedBuilder(
                                  animation: _editorScrollController,
                                  builder: (context, child) {
                                    final offset =
                                        _editorScrollController.hasClients
                                        ? _editorScrollController.offset
                                        : 0.0;
                                    return Transform.translate(
                                      offset: Offset(0, -offset),
                                      child: child,
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text.rich(
                                      TextSpan(
                                        children: CodeHighlighter.highlight(
                                          _codeController.text,
                                          _selectedLanguage,
                                        ),
                                      ),
                                      style: _codeTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Yung totoong TextField — transparent ang text
                          // color nito para lumabas yung may-kulay na text
                          // sa ilalim, pero buo pa rin ang cursor/selection.
                          TextField(
                            controller: _codeController,
                            scrollController: _editorScrollController,
                            inputFormatters: [AutoIndentFormatter()],
                            maxLines: null,
                            expands: true,
                            cursorColor: Colors.white,
                            style: _codeTextStyle.copyWith(
                              color: Colors.transparent,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Isulat ang code mo dito...',
                              hintStyle: TextStyle(color: Colors.white38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _runCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _violet,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Code'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _showTokenVisualizer,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _violet,
                      side: BorderSide(color: _violet),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.token),
                    label: const Text('Tokens'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
