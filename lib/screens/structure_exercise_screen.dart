import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/compiler_service.dart';
import 'code_editor_screen.dart';
import 'code_highlighter.dart';
import 'lesson.dart';

/// Dalawang hakbang na exercise:
/// 1. Fill in the blanks — kumpletuhin ang mga nawawalang parte ng
///    structure (case-sensitive, exact match).
/// 2. Isulat ang BUONG structure mula sa wala, tapos patakbuhin ito —
///    kagaya ng normal na exercise checker (compiler + output match).
class StructureExerciseScreen extends StatefulWidget {
  final Lesson lesson;
  final ProgrammingLanguage language;
  final Color languageColor;

  const StructureExerciseScreen({
    super.key,
    required this.lesson,
    required this.language,
    required this.languageColor,
  });

  @override
  State<StructureExerciseScreen> createState() =>
      _StructureExerciseScreenState();
}

class _StructureExerciseScreenState extends State<StructureExerciseScreen> {
  static const _bg = Color(0xFFF4F2FB);

  late final StructureBlankExercise _blanks;
  late final List<TextEditingController> _blankControllers;
  List<bool?> _blankResults = [];
  bool _blanksSubmitted = false;
  bool get _blanksAllCorrect =>
      _blankResults.isNotEmpty && _blankResults.every((r) => r == true);

  int _step = 0; // 0 = fill in the blanks, 1 = type the whole structure

  TextEditingController? _exerciseController;
  bool _isChecking = false;
  bool? _isCorrect;
  String _feedbackDetail = '';

  @override
  void initState() {
    super.initState();
    _blanks = widget.lesson.blankExercise![widget.language]!;
    _blankControllers = List.generate(
      _blanks.correctAnswers.length,
      (_) => TextEditingController(),
    );
    _blankResults = List.filled(_blanks.correctAnswers.length, null);

    final starter = widget.lesson.starterCode?[widget.language] ?? '';
    _exerciseController = TextEditingController(text: starter);
  }

  @override
  void dispose() {
    for (final c in _blankControllers) {
      c.dispose();
    }
    _exerciseController?.dispose();
    super.dispose();
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

  CompilerResult _runCode(String code) {
    switch (widget.language) {
      case ProgrammingLanguage.java:
        return CompilerService.runJavaCode(code);
      case ProgrammingLanguage.cpp:
        return CompilerService.runCppCode(code);
      case ProgrammingLanguage.python:
        return CompilerService.runPythonCode(code);
      case ProgrammingLanguage.javascript:
        return CompilerService.runJsCode(code);
      case ProgrammingLanguage.csharp:
        return CompilerService.runCsCode(code);
      case ProgrammingLanguage.php:
        return CompilerService.runPhpCode(code);
    }
  }

  void _checkBlanks() {
    final results = <bool>[];
    for (int i = 0; i < _blankControllers.length; i++) {
      final userAnswer = _blankControllers[i].text.trim();
      final correct = _blanks.correctAnswers[i].trim();
      results.add(userAnswer == correct); // case-sensitive, exact match
    }
    setState(() {
      _blankResults = results;
      _blanksSubmitted = true;
    });
  }

  void _goToStep2() {
    setState(() => _step = 1);
  }

  Future<void> _checkStructure() async {
    if (_exerciseController == null) return;

    setState(() {
      _isChecking = true;
      _isCorrect = null;
    });

    final code = _exerciseController!.text;
    final result = _runCode(code);
    final expected = widget.lesson.expectedOutput?.trim() ?? '';
    final actual = result.output.trim();
    final isCorrect = result.success && actual == expected;

    setState(() {
      _isChecking = false;
      _isCorrect = isCorrect;
      _feedbackDetail = result.success
          ? 'Output mo: "$actual"'
          : 'Error: ${result.error}';
    });

    final user = AuthService.currentUser;
    if (user != null && isCorrect) {
      try {
        await FirebaseFirestore.instance
            .collection('progress')
            .doc('${user.uid}_${_keyFor(widget.language)}_${widget.lesson.id}')
            .set({
              'user_id': user.uid,
              'language': _keyFor(widget.language),
              'lesson_id': widget.lesson.id,
              'is_completed': true,
              'completed_at': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
      } catch (_) {
        // hindi natin gustong ma-block ang UI kung magkaproblema ang Firestore
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.languageColor;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Structure Exercise',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StepDot(
                    active: _step == 0,
                    done: _step > 0,
                    color: color,
                    label: '1',
                  ),
                  Expanded(
                    child: Container(height: 2, color: color.withOpacity(0.25)),
                  ),
                  _StepDot(
                    active: _step == 1,
                    done: false,
                    color: color,
                    label: '2',
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fill in the Blanks',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    'Isulat ang Buo',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _step == 0
                    ? _buildBlanksStep(color)
                    : _buildFullStructureStep(color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlanksStep(Color color) {
    return ListView(
      children: [
        Text(
          _blanks.instruction,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.6,
            color: Color(0xFF2B2B36),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _buildTemplateWidgets(color),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _checkBlanks,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'I-check ang mga Sagot',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (_blanksSubmitted) ...[
          const SizedBox(height: 14),
          if (_blanksAllCorrect)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: Colors.green),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tama lahat! Handa ka na sa susunod na hakbang.',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.error_outline, size: 18, color: Colors.redAccent),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'May mali pa — tignan ang mga naka-red na blanks.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_blanksAllCorrect) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _goToStep2,
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Susunod: Isulat ang Buong Structure'),
              ),
            ),
          ],
        ],
      ],
    );
  }

  List<Widget> _buildTemplateWidgets(Color color) {
    final widgets = <Widget>[];
    for (int i = 0; i < _blanks.templateParts.length; i++) {
      widgets.add(
        Text(
          _blanks.templateParts[i],
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 13,
            height: 1.6,
          ),
        ),
      );
      if (i < _blanks.correctAnswers.length) {
        final result = i < _blankResults.length ? _blankResults[i] : null;
        final Color borderColor = !_blanksSubmitted
            ? color
            : (result == true ? Colors.green : Colors.redAccent);

        widgets.add(
          Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: TextField(
              controller: _blankControllers[i],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                filled: true,
                fillColor: const Color(0xFF2A2A3D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  Widget _buildFullStructureStep(Color color) {
    return ListView(
      children: [
        Text(
          widget.lesson.exercisePrompt ?? '',
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.6,
            color: Color(0xFF2B2B36),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF181825),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF2A2A3D), width: 1),
                  ),
                ),
                child: Text(
                  CodeHighlighter.labelFor(widget.language),
                  style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _exerciseController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isChecking ? null : _checkStructure,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: _isChecking
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_isChecking ? 'Sinusuri...' : 'Patakbuhin at I-check'),
          ),
        ),
        if (_isCorrect != null) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (_isCorrect! ? Colors.green : Colors.redAccent)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (_isCorrect! ? Colors.green : Colors.redAccent)
                    .withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _isCorrect! ? Icons.check_circle : Icons.error_outline,
                      size: 18,
                      color: _isCorrect! ? Colors.green : Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isCorrect!
                          ? 'Tama! Kumpleto ang structure mo! 🎉'
                          : 'Hindi pa tama, subukan ulit.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isCorrect! ? Colors.green : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _feedbackDetail,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final bool done;
  final Color color;
  final String label;

  const _StepDot({
    required this.active,
    required this.done,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final bg = done ? Colors.green : (active ? color : color.withOpacity(0.2));
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
    );
  }
}
