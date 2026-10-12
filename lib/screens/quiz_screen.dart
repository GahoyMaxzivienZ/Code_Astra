import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/auth_service.dart';
import 'lesson.dart';

/// "Code Quiz" style na quiz screen — isang tanong sa isang pagkakataon,
/// vertical list ng options na may letter badge (A/B/C/D), opsyonal na
/// code block sa loob ng tanong, at results screen na may score breakdown.
class QuizScreen extends StatefulWidget {
  final String title;
  final List<QuizQuestion> questions;
  final Color accentColor;

  final String languageKey;
  final String lessonId;

  final double passThreshold;

  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.accentColor,
    required this.languageKey,
    required this.lessonId,
    this.passThreshold = 0.6,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _bg = Color(0xFFF4F6FB);
  static const _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

  int _index = 0;
  String? _selectedOptionId;
  bool _answered = false;
  int _score = 0;

  bool _progressSaved = false;

  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _shuffled(widget.questions);
  }

  /// Hinahalo ang pagkakasunod ng mga pagpipilian sa bawat tanong, para
  /// hindi laging "A" ang tamang sagot. Id ang ginagamit sa pag-check
  /// (hindi posisyon), kaya tama pa rin ang scoring kahit magulo ang order.
  List<QuizQuestion> _shuffled(List<QuizQuestion> source) {
    final random = Random();
    return source
        .map(
          (q) => QuizQuestion(
            id: q.id,
            prompt: q.prompt,
            code: q.code,
            options: List<QuizOption>.of(q.options)..shuffle(random),
            correctOptionId: q.correctOptionId,
            explanation: q.explanation,
            correctFeedback: q.correctFeedback,
            incorrectFeedback: q.incorrectFeedback,
          ),
        )
        .toList();
  }

  bool get _isDone => _index >= _questions.length;

  void _selectOption(QuizQuestion question, String optionId) {
    if (_answered) return;
    setState(() {
      _selectedOptionId = optionId;
      _answered = true;
      if (optionId == question.correctOptionId) _score++;
    });
  }

  void _next() {
    setState(() {
      _index++;
      _selectedOptionId = null;
      _answered = false;
    });

    if (_isDone) {
      _saveProgressIfPassed();
    }
  }

  void _restart() {
    setState(() {
      _questions = _shuffled(widget.questions);
      _index = 0;
      _selectedOptionId = null;
      _answered = false;
      _score = 0;
      _progressSaved = false;
    });
  }

  Future<void> _saveProgressIfPassed() async {
    if (_progressSaved) return;

    final total = _questions.length;
    final pct = total == 0 ? 0.0 : _score / total;
    final passed = pct >= widget.passThreshold;

    if (!passed) return;

    final user = AuthService.currentUser;
    if (user == null) return;

    _progressSaved = true;

    try {
      await FirebaseFirestore.instance
          .collection('progress')
          .doc('${user.uid}_${widget.languageKey}_${widget.lessonId}')
          .set({
            'user_id': user.uid,
            'language': widget.languageKey,
            'lesson_id': widget.lessonId,
            'is_completed': true,
            'completed_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (_) {
      _progressSaved = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: widget.title, accentColor: widget.accentColor),
            Expanded(
              child: _isDone ? _buildResults(context) : _buildQuestion(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final question = _questions[_index];
    final total = _questions.length;

    return ListView(
      key: ValueKey('question-$_index'),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        // ---- Progress ----
        Row(
          children: [
            Text(
              'TANONG ${_index + 1} NG $total',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.4,
                color: widget.accentColor,
              ),
            ),
            const Spacer(),
            Text(
              '⭐ Score: $_score',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: Color(0xFF8C93A3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: total == 0 ? 0 : _index / total),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: const Color(0xFFE5E8EF),
              valueColor: AlwaysStoppedAnimation(widget.accentColor),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // ---- Question card ----
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE7EAF1)),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '💡 KNOWLEDGE CHECK',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: widget.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    question.prompt,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: Color(0xFF1D2230),
                    ),
                  ),
                  if (question.code != null) ...[
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF171923),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            decoration: const BoxDecoration(
                              color: Color(0xFF11131B),
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF292D39),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                _dot(const Color(0xFFFF5F57)),
                                const SizedBox(width: 5),
                                _dot(const Color(0xFFFFBD2E)),
                                const SizedBox(width: 5),
                                _dot(const Color(0xFF28C840)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              question.code!,
                              style: const TextStyle(
                                color: Color(0xFFE7E9EF),
                                fontFamily: 'monospace',
                                fontSize: 12,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 350.ms)
            .slideY(
              begin: 0.06,
              end: 0,
              duration: 350.ms,
              curve: Curves.easeOutCubic,
            ),

        const SizedBox(height: 18),

        // ---- Answers ----
        for (int i = 0; i < question.options.length; i++) ...[
          _OptionRow(
                letter: _letters[i % _letters.length],
                option: question.options[i],
                accentColor: widget.accentColor,
                answered: _answered,
                isSelected: _selectedOptionId == question.options[i].id,
                isCorrect: question.options[i].id == question.correctOptionId,
                onTap: () => _selectOption(question, question.options[i].id),
              )
              .animate()
              .fadeIn(duration: 300.ms, delay: (i * 60).ms)
              .slideX(
                begin: 0.04,
                end: 0,
                duration: 300.ms,
                delay: (i * 60).ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 10),
        ],

        // ---- Feedback + Next ----
        if (_answered) ...[
          const SizedBox(height: 6),
          _FeedbackPanel(
            key: ValueKey('feedback-$_index'),
            isCorrect: _selectedOptionId == question.correctOptionId,
            feedbackLabel: _selectedOptionId == question.correctOptionId
                ? question.correctFeedback
                : question.incorrectFeedback,
            explanation: question.explanation,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 49,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _index + 1 == total ? 'TAPUSIN' : 'SUSUNOD NA TANONG →',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 250.ms),
        ],
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    final total = _questions.length;
    final pct = total == 0 ? 0.0 : _score / total;
    final passed = pct >= widget.passThreshold;
    final accuracyPct = (pct * 100).round();

    String message;
    String emoji;
    if (pct >= 0.8) {
      message = 'Ang galing! Solid ang pagkaka-intindi mo.';
      emoji = '🏆';
    } else if (pct >= 0.5) {
      message = 'Ayos, malapit ka na — balikan lang yung mga namiss.';
      emoji = '💪';
    } else {
      message = 'Okay lang yan — balikan muna natin yung lesson.';
      emoji = '📖';
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      children: [
        Center(
          child:
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.accentColor,
                      widget.accentColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.3),
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 40)),
              ).animate().scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1, 1),
                duration: 450.ms,
                curve: Curves.elasticOut,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tapos na ang Quiz!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          '$_score / $total',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: widget.accentColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Color(0xFF6D7485),
          ),
        ),
        if (!passed) ...[
          const SizedBox(height: 6),
          Text(
            'Kailangan ng ${(widget.passThreshold * 100).round()}% pataas '
            'para ma-unlock ang susunod na lesson.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
            ),
          ),
        ],
        const SizedBox(height: 22),

        // ---- Result breakdown card ----
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8EBF2)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              _resultRow('Correct Answers', '$_score'),
              _resultRow('Accuracy', '$accuracyPct%', isLast: true),
            ],
          ),
        ).animate().fadeIn(duration: 350.ms, delay: 150.ms),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.accentColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: const Text(
              'Bumalik sa Lesson →',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
            ),
          ),
        ),
        const SizedBox(height: 9),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _restart,
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.accentColor,
              side: BorderSide(color: widget.accentColor, width: 1.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 17),
            label: const Text(
              'Ulitin ang Quiz',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFEEF0F5), width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF858C9D)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF313746),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final Color accentColor;

  const _TopBar({required this.title, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8EBF2), width: 1)),
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
                color: const Color(0xFFF0F2F7),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back, size: 18),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Quick Quiz',
                  style: TextStyle(fontSize: 10, color: Color(0xFF9299A9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String letter;
  final QuizOption option;
  final Color accentColor;
  final bool answered;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;

  const _OptionRow({
    required this.letter,
    required this.option,
    required this.accentColor,
    required this.answered,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = const Color(0xFFE2E6EF);
    Color bg = Colors.white;
    Color letterBg = const Color(0xFFF0F1F6);
    Color letterColor = const Color(0xFF697184);
    double borderWidth = 1;

    if (answered && isCorrect) {
      borderColor = const Color(0xFF25A866);
      bg = const Color(0xFFEEFAF4);
      letterBg = const Color(0xFF25A866);
      letterColor = Colors.white;
      borderWidth = 2;
    } else if (answered && isSelected && !isCorrect) {
      borderColor = const Color(0xFFE05252);
      bg = const Color(0xFFFFF2F2);
      letterBg = const Color(0xFFE05252);
      letterColor = Colors.white;
      borderWidth = 2;
    } else if (!answered && isSelected) {
      borderColor = accentColor;
      bg = accentColor.withOpacity(0.06);
      letterBg = accentColor;
      letterColor = Colors.white;
      borderWidth = 2;
    }

    final dimmed = answered && !isSelected && !isCorrect;

    return Opacity(
      opacity: dimmed ? 0.4 : 1,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: answered ? null : onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: letterBg,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: letterColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: Color(0xFF3A4050),
                    ),
                  ),
                ),
                if (answered && isCorrect)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF25A866),
                    size: 18,
                  )
                else if (answered && isSelected && !isCorrect)
                  const Icon(Icons.cancel, color: Color(0xFFE05252), size: 18)
                else
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB1B7C5),
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final String feedbackLabel;
  final String explanation;

  const _FeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.feedbackLabel,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isCorrect ? const Color(0xFFEAF8F0) : const Color(0xFFFFF0F0);
    final border = isCorrect
        ? const Color(0xFFC4EAD4)
        : const Color(0xFFF3CCCC);
    final tone = isCorrect ? const Color(0xFF25A866) : const Color(0xFFE05252);

    final panel = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  size: 16,
                  color: tone,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  feedbackLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: tone,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 12,
              height: 1.55,
              color: Color(0xFF555C6D),
            ),
          ),
        ],
      ),
    );

    if (isCorrect) {
      return panel
          .animate()
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 350.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(duration: 200.ms);
    }

    return panel
        .animate()
        .shake(hz: 4, duration: 350.ms)
        .fadeIn(duration: 200.ms);
  }
}
