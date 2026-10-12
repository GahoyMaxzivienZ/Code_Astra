import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/auth_service.dart';
import '../services/compiler_service.dart';
import 'code_editor_screen.dart';
import 'code_highlighter.dart';
import 'lesson.dart';
import 'quiz_screen.dart';
import 'structure_exercise_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  final ProgrammingLanguage language;
  final String languageLabel;
  final Color languageColor;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.language,
    required this.languageLabel,
    required this.languageColor,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  TextEditingController? _exerciseController;
  bool _isChecking = false;
  bool? _isCorrect;
  String _feedbackDetail = '';
  int _wrongAttempts = 0;

  @override
  void initState() {
    super.initState();
    if (widget.lesson.hasExercise) {
      final starter = widget.lesson.starterCode?[widget.language] ?? '';
      _exerciseController = TextEditingController(text: starter);
    }
  }

  @override
  void dispose() {
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

  Future<void> _checkAnswer() async {
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
      _wrongAttempts = isCorrect ? 0 : _wrongAttempts + 1;
    });

    final user = AuthService.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('exercise_submissions').add(
          {
            'user_id': user.uid,
            'language': _keyFor(widget.language),
            'lesson_id': widget.lesson.id,
            'submitted_code': code,
            'is_correct': isCorrect,
            'submitted_at': FieldValue.serverTimestamp(),
          },
        );

        if (isCorrect) {
          await FirebaseFirestore.instance
              .collection('progress')
              .doc(
                '${user.uid}_${_keyFor(widget.language)}_${widget.lesson.id}',
              )
              .set({
                'user_id': user.uid,
                'language': _keyFor(widget.language),
                'lesson_id': widget.lesson.id,
                'is_completed': true,
                'completed_at': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
        }
      } catch (_) {
        // hindi natin gustong ma-block ang UI kung magkaproblema ang Firestore
      }
    }
  }

  List<String> _paragraphs(String text) {
    return text
        .split('\n\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final color = widget.languageColor;
    final example = lesson.codeExample?[widget.language];
    final theoryText = lesson.theoryFor(widget.language);
    final hasBlankExercise = lesson.hasBlankExercise(widget.language);
    final hasExercise = lesson.hasExercise && !hasBlankExercise;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ---- Top nav ----
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE8EBF2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back, size: 19),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.languageLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8B92A3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---- Scrollable content ----
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  // ---- Hero ----
                  Container(
                        margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, color.withOpacity(0.75)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        lesson.icon,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        widget.languageLabel.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.7,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              lesson.title,
                              style: const TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.15,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 350.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 22),

                  // ---- CONCEPT ----
                  _SectionLabel(text: 'PALIWANAG', index: '01', color: color),
                  _ConceptCard(
                        icon: Icons.menu_book_outlined,
                        accentColor: color,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final para in _paragraphs(theoryText)) ...[
                              Text(
                                para,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.65,
                                  color: Color(0xFF2B2B36),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 400.ms,
                        delay: 100.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 25),

                  // ---- EXAMPLE ----
                  if (example != null) ...[
                    _SectionLabel(text: 'HALIMBAWA', index: '02', color: color),
                    _CodeBlock(
                          code: example,
                          language: widget.language,
                          accentColor: color,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0,
                          duration: 400.ms,
                          delay: 200.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 28),
                  ],

                  // ---- MISSION ----
                  _SectionLabel(
                    text: 'SUBUKAN MO',
                    index: example != null ? '03' : '02',
                    color: color,
                  ),

                  if (hasBlankExercise)
                    _MissionCard(
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'May dalawang hakbang ang exercise na ito: '
                            'unahin munang kumpletuhin ang mga blangko, '
                            'tapos isulat mo ang buong structure mula sa '
                            'wala.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Color(0xFFE7E9EF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 49,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StructureExerciseScreen(
                                      lesson: lesson,
                                      language: widget.language,
                                      languageColor: color,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.extension_outlined),
                              label: const Text(
                                'Simulan ang Structure Exercise',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (hasExercise)
                    _MissionCard(
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.exercisePrompt ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Color(0xFFE7E9EF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ExerciseEditor(
                            controller: _exerciseController!,
                            language: widget.language,
                            accentColor: color,
                          ),
                          const SizedBox(height: 13),
                          SizedBox(
                            width: double.infinity,
                            height: 49,
                            child: ElevatedButton.icon(
                              onPressed: _isChecking ? null : _checkAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
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
                                  : const Icon(Icons.play_arrow_rounded),
                              label: Text(
                                _isChecking ? 'Sinusuri...' : 'RUN & CHECK',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                          if (_isCorrect != null) ...[
                            const SizedBox(height: 13),
                            _FeedbackBanner(
                              key: ValueKey(
                                'feedback-$_isCorrect-$_wrongAttempts',
                              ),
                              isCorrect: _isCorrect!,
                              detail: _feedbackDetail,
                            ),
                          ],
                          if (_isCorrect == false && _wrongAttempts >= 2) ...[
                            const SizedBox(height: 12),
                            _HintBanner(accentColor: color),
                          ],

                          // ---- Quiz din bilang IKALAWANG paraan
                          // (hindi kailangan tapusin muna ang exercise) ----
                          if (lesson.hasQuiz) ...[
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 49,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuizScreen(
                                        title: lesson.title,
                                        questions: lesson.quizFor(
                                          widget.language,
                                        ),
                                        accentColor: color,
                                        languageKey: _keyFor(widget.language),
                                        lessonId: lesson.id,
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: const Icon(Icons.quiz_outlined),
                                label: const Text(
                                  'Subukan ang Quiz sa halip',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    _MissionCard(
                      color: color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.hasQuiz
                                ? 'Handa ka na ba? Sagutan ang maikling '
                                      'quiz para tignan kung gaano mo na '
                                      'naintindihan ang lesson na ito.'
                                : 'Pumunta sa Free Editor, sumulat ng '
                                      'kahit anong code, tapos pindutin '
                                      'ang "Tokens" button para makita '
                                      'mismo kung paano hinahati ng '
                                      'compiler ang code mo.',
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Color(0xFFE7E9EF),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 49,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (lesson.hasQuiz) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuizScreen(
                                        title: lesson.title,
                                        questions: lesson.quizFor(
                                          widget.language,
                                        ),
                                        accentColor: color,
                                        languageKey: _keyFor(widget.language),
                                        lessonId: lesson.id,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CodeEditorScreen(
                                        initialLanguage: widget.language,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: Icon(
                                lesson.hasQuiz
                                    ? Icons.quiz_outlined
                                    : Icons.open_in_new,
                              ),
                              label: Text(
                                lesson.hasQuiz
                                    ? 'Subukan ang Quiz'
                                    : 'Buksan ang Editor',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        color: color,
        hasExample: example != null,
      ),
    );
  }
}

// =========================================================
// SUPPORTING WIDGETS
// =========================================================

class _SectionLabel extends StatelessWidget {
  final String text;
  final String index;
  final Color color;

  const _SectionLabel({
    required this.text,
    required this.index,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: color.withOpacity(0.75),
            ),
          ),
          Text(
            index,
            style: const TextStyle(fontSize: 10, color: Color(0xFF9AA1B1)),
          ),
        ],
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final Widget child;

  const _ConceptCard({
    required this.icon,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8EBF2)),
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: accentColor, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  final ProgrammingLanguage language;
  final Color accentColor;

  const _CodeBlock({
    required this.code,
    required this.language,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF171923),
        borderRadius: BorderRadius.circular(19),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF11131B),
              border: Border(
                bottom: BorderSide(color: Color(0xFF292D39), width: 1),
              ),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const Spacer(),
                Text(
                  CodeHighlighter.labelFor(language),
                  style: TextStyle(
                    color: accentColor.withOpacity(0.85),
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Text(
              code,
              style: const TextStyle(
                color: Color(0xFFE8EAF0),
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final Color color;
  final Widget child;

  const _MissionCard({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF171923),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 38,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2E3D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.bolt, color: color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Coding Mission',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              child,
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 400.ms,
          delay: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _ExerciseEditor extends StatelessWidget {
  final TextEditingController controller;
  final ProgrammingLanguage language;
  final Color accentColor;

  const _ExerciseEditor({
    required this.controller,
    required this.language,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF11131B),
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF2B2F3D), width: 1),
              ),
            ),
            child: Text(
              CodeHighlighter.labelFor(language),
              style: TextStyle(
                color: accentColor.withOpacity(0.85),
                fontFamily: 'monospace',
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  color: Color(0xFFE8EAF0),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.65,
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
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String detail;

  const _FeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final tone = isCorrect ? Colors.green : Colors.redAccent;

    final banner = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tone.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.error_outline,
                size: 18,
                color: tone,
              ),
              const SizedBox(width: 6),
              Text(
                isCorrect ? 'Tama! 🎉' : 'Hindi pa tama, subukan ulit.',
                style: TextStyle(fontWeight: FontWeight.bold, color: tone),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
        ],
      ),
    );

    if (isCorrect) {
      return banner
          .animate()
          .scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1, 1),
            duration: 400.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(duration: 200.ms);
    }

    return banner
        .animate()
        .shake(hz: 4, duration: 400.ms)
        .fadeIn(duration: 200.ms);
  }
}

class _HintBanner extends StatelessWidget {
  final Color accentColor;

  const _HintBanner({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Hint: Sipatin ulit — eksakto ba ang spelling, malaking/maliit '
                  'na letra, at tamang quotation marks ng text na dapat mong '
                  'ilabas? Madalas dito nagkakamali kahit tama ang logic.',
                  style: TextStyle(fontSize: 12.5, height: 1.5),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _BottomBar extends StatelessWidget {
  final Color color;
  final bool hasExample;

  const _BottomBar({required this.color, required this.hasExample});

  @override
  Widget build(BuildContext context) {
    final labels = hasExample
        ? const ['Paliwanag', 'Halimbawa', 'Mission']
        : const ['Paliwanag', 'Mission'];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6E9F0), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                for (int i = 0; i < labels.length; i++) ...[
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i < labels.length - 1)
                    Container(
                      width: 14,
                      height: 2,
                      color: color.withOpacity(0.25),
                    ),
                ],
              ],
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF171923),
                side: const BorderSide(color: Color(0xFFE0E3EA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text(
                'Bumalik',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
