import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../services/compiler_service.dart';
import 'code_editor_screen.dart' show AutoIndentFormatter, ProgrammingLanguage;
import 'exercise_result_screen.dart';

/// Solve-from-scratch exercise screen: instructions on top, a code editor
/// below. Running the code takes the student to a separate
/// [ExerciseResultScreen] that shows the output, whether it matched, and
/// beginner-friendly tips if something went wrong.
class ExerciseScreen extends StatefulWidget {
  final Exercise exercise;
  final Color languageColor;

  const ExerciseScreen({
    super.key,
    required this.exercise,
    required this.languageColor,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  static const _bg = Color(0xFFF4F2FB);

  late final TextEditingController _codeController;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.exercise.starterCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  CompilerResult _runCode(String code) {
    switch (widget.exercise.language) {
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

  Future<void> _runAndCheck() async {
    final code = _codeController.text;
    if (code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wala pang code na i-ru-run. Mag-type ka muna.')),
      );
      return;
    }

    setState(() => _isRunning = true);
    final result = _runCode(code);
    setState(() => _isRunning = false);

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseResultScreen(
          exercise: widget.exercise,
          result: result,
          languageColor: widget.languageColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.languageColor;
    final exercise = widget.exercise;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          exercise.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                constraints: const BoxConstraints(maxHeight: 180),
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.menu_book_outlined, size: 18, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exercise.instructions,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.55,
                            color: Color(0xFF2B2B36),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _codeController,
                    inputFormatters: [AutoIndentFormatter()],
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 14,
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      hintText: 'Isulat ang solusyon mo dito...',
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? null : _runAndCheck,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isRunning
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_isRunning ? 'Tumatakbo...' : 'Run Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
