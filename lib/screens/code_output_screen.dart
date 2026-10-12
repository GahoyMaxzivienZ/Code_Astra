import 'package:flutter/material.dart';

import '../services/compiler_service.dart';
import '../utils/code_line_explainer.dart';
import '../utils/error_tips.dart';
import '../utils/language_key.dart';
import 'code_editor_screen.dart' show ProgrammingLanguage;
import 'code_highlighter.dart';

/// Separate na screen na pinapakita matapos pindutin ang "Run Code" sa
/// [CodeEditorScreen] — katulad ng ginagawa na ng exercises
/// (`exercise_result_screen.dart`), pero dagdag dito ang isang
/// line-by-line na paliwanag ng buong code, at kung may error, tinuturo
/// nito kung anong linya ito at bakit.
class CodeOutputScreen extends StatelessWidget {
  final String code;
  final ProgrammingLanguage language;
  final CompilerResult result;
  final Color accentColor;

  const CodeOutputScreen({
    super.key,
    required this.code,
    required this.language,
    required this.result,
    this.accentColor = const Color(0xFF3C3489),
  });

  static const _bg = Color(0xFFF4F2FB);
  static const _codeBg = Color(0xFF1E1E2E);

  bool get _isError => !result.success;

  @override
  Widget build(BuildContext context) {
    final errorLine = _isError
        ? CodeLineExplainer.errorLineFrom(result.error)
        : null;
    final lineExplanations = CodeLineExplainer.explain(
      code,
      language,
      errorLine: errorLine,
    );
    final tip = _isError ? ErrorTips.friendlyTip(result.error) : null;
    final statusColor = _isError ? Colors.redAccent : Colors.green;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Resulta — ${language.label}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _statusBanner(statusColor),
            const SizedBox(height: 16),
            _sectionLabel(_isError ? 'Error' : 'Output'),
            _outputBlock(statusColor),
            if (tip != null) ...[const SizedBox(height: 10), _tipCard(tip)],
            const SizedBox(height: 22),
            _sectionLabel('Ang Code Mo'),
            const SizedBox(height: 8),
            _sectionLabel(
              'Line-by-line na Paliwanag',
              icon: Icons.menu_book_outlined,
            ),
            const SizedBox(height: 8),
            ...lineExplanations.map(_lineCard),
            const SizedBox(height: 22),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Bumalik sa Editor'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBanner(Color statusColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(
            _isError ? Icons.error_outline : Icons.check_circle,
            color: statusColor,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isError
                  ? 'May error sa code mo.'
                  : 'Tumakbo nang maayos ang code mo! 🎉',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.black54),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outputBlock(Color statusColor) {
    final text = _isError
        ? result.error
        : (result.output.isEmpty ? '(walang output)' : result.output);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _codeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          color: _isError ? Colors.redAccent[100] : Colors.white,
        ),
      ),
    );
  }

  Widget _tipCard(String tip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineCard(LineExplanation line) {
    final isErr = line.isErrorLine;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isErr ? Colors.red.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isErr
              ? Colors.redAccent.withOpacity(0.55)
              : accentColor.withOpacity(0.12),
          width: isErr ? 1.4 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              padding: const EdgeInsets.symmetric(vertical: 3),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isErr ? Colors.redAccent : accentColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${line.lineNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _codeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text.rich(
                        TextSpan(
                          children: CodeHighlighter.highlight(
                            line.text,
                            language,
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                  if (isErr) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.arrow_right_alt,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Dito nangyari ang error.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (line.explanation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      line.explanation!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
