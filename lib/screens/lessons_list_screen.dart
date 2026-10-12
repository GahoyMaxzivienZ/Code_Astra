import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/auth_service.dart';
import 'code_editor_screen.dart';
import 'lessons_data.dart';
import 'lesson_detail_screen.dart';

class LessonsListScreen extends StatelessWidget {
  final ProgrammingLanguage language;
  final String languageLabel;
  final Color languageColor;

  const LessonsListScreen({
    super.key,
    required this.language,
    required this.languageLabel,
    required this.languageColor,
  });

  static const _bg = Color(0xFFEDE9FB);

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

  void _openLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailScreen(
          lesson: lesson,
          language: language,
          languageLabel: languageLabel,
          languageColor: languageColor,
        ),
      ),
    );
  }

  void _openFreeEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CodeEditorScreen(initialLanguage: language),
      ),
    );
  }

  bool _isUnlocked(
    int index,
    List<Lesson> displayLessons,
    Set<String> completedLessonIds,
  ) {
    if (index == 0) return true;
    for (int i = index - 1; i >= 0; i--) {
      if (!displayLessons[i].availableFor(language)) continue;
      return completedLessonIds.contains(displayLessons[i].id);
    }
    return true;
  }

  Lesson? _blockingLesson(int index, List<Lesson> displayLessons) {
    for (int i = index - 1; i >= 0; i--) {
      if (!displayLessons[i].availableFor(language)) continue;
      return displayLessons[i];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final displayLessons = lessonsForDisplay(language);
    final totalCompletable = displayLessons
        .where((l) => l.availableFor(language))
        .length;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: languageColor,
        foregroundColor: Colors.white,
        title: Text('$languageLabel Lessons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Buksan ang Free Editor',
            onPressed: () => _openFreeEditor(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: user == null
            ? null
            : FirebaseFirestore.instance
                  .collection('progress')
                  .where('user_id', isEqualTo: user.uid)
                  .where('language', isEqualTo: _keyFor(language))
                  .snapshots(),
        builder: (context, snapshot) {
          final completedLessonIds = <String>{};
          if (snapshot.hasData) {
            for (final doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              if (data['is_completed'] == true) {
                final id = data['lesson_id'] as String?;
                if (id != null) completedLessonIds.add(id);
              }
            }
          }

          final completedCount = completedLessonIds
              .where(
                (id) => displayLessons.any(
                  (l) => l.id == id && l.availableFor(language),
                ),
              )
              .length;

          final progressValue = totalCompletable == 0
              ? 0.0
              : completedCount / totalCompletable;

          return Column(
            children: [
              // Dynamic na progress bar sa itaas ng listahan — animated fill.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progressValue),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 8,
                            backgroundColor: languageColor.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation(languageColor),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$completedCount/$totalCompletable lessons tapos na',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: languageColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayLessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lesson = displayLessons[index];
                    final available = lesson.availableFor(language);
                    final unlocked =
                        available &&
                        _isUnlocked(index, displayLessons, completedLessonIds);
                    final isDone = completedLessonIds.contains(lesson.id);
                    final tappable = unlocked;

                    return _LessonCard(
                          lesson: lesson,
                          color: languageColor,
                          isDone: isDone,
                          isLocked: available && !unlocked,
                          isUnavailable: !available,
                          staggerIndex: index,
                          onTap: tappable
                              ? () => _openLesson(context, lesson)
                              : null,
                          onBlockedTap: tappable
                              ? null
                              : () {
                                  if (!available) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Malapit na ito! Wala pang laman ito '
                                          'para sa language na ito.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  final blocker = _blockingLesson(
                                    index,
                                    displayLessons,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        blocker == null
                                            ? 'Tapusin muna ang naunang lesson.'
                                            : 'Tapusin muna ang "${blocker.title}" para mabuksan ito.',
                                      ),
                                    ),
                                  );
                                },
                        )
                        .animate()
                        .fadeIn(duration: 350.ms, delay: (index * 60).ms)
                        .slideY(
                          begin: 0.12,
                          end: 0,
                          duration: 350.ms,
                          delay: (index * 60).ms,
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LessonCard extends StatefulWidget {
  final Lesson lesson;
  final Color color;
  final bool isDone;
  final bool isLocked;
  final bool isUnavailable;
  final int staggerIndex;
  final VoidCallback? onTap;
  final VoidCallback? onBlockedTap;

  const _LessonCard({
    required this.lesson,
    required this.color,
    required this.isDone,
    required this.isLocked,
    required this.isUnavailable,
    required this.staggerIndex,
    this.onTap,
    this.onBlockedTap,
  });

  @override
  State<_LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<_LessonCard> {
  bool _pressed = false;
  int _shakeCount = 0;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null) setState(() => _pressed = true);
  }

  void _handleTapCancel() {
    if (_pressed) setState(() => _pressed = false);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_pressed) setState(() => _pressed = false);
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else if (widget.onBlockedTap != null) {
      widget.onBlockedTap!();
      setState(() => _shakeCount++); // triggers shake replay
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimmed = widget.isLocked || widget.isUnavailable;
    final color = widget.color;
    final lesson = widget.lesson;

    Widget trailingIcon;
    if (widget.isDone) {
      trailingIcon =
          const Icon(
            Icons.check_circle,
            size: 20,
            color: Colors.green,
          ).animate().scale(
            begin: const Offset(0, 0),
            end: const Offset(1, 1),
            duration: 400.ms,
            curve: Curves.elasticOut,
          );
    } else if (widget.isUnavailable) {
      trailingIcon = const Icon(
        Icons.hourglass_empty,
        size: 18,
        color: Colors.black26,
      );
    } else if (widget.isLocked) {
      trailingIcon = const Icon(
        Icons.lock_outline,
        size: 18,
        color: Colors.black26,
      ).animate().fadeIn(duration: 300.ms);
    } else {
      trailingIcon = Icon(
        Icons.chevron_right,
        color: color,
      ).animate().fadeIn(duration: 300.ms);
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapCancel: _handleTapCancel,
      onTapUp: _handleTapUp,
      onTap: _handleTap,
      child:
          AnimatedScale(
                scale: _pressed ? 0.97 : 1.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: color.withOpacity(dimmed ? 0.08 : 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withOpacity(dimmed ? 0.06 : 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            lesson.icon,
                            color: dimmed ? color.withOpacity(0.3) : color,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: dimmed ? Colors.black38 : Colors.black87,
                            ),
                          ),
                        ),
                        trailingIcon,
                      ],
                    ),
                  ),
                ),
              )
              .animate(
                key: ValueKey(_shakeCount),
                target: _shakeCount > 0 ? 1 : 0,
              )
              .shake(hz: 4, duration: 350.ms, curve: Curves.easeOut),
    );
  }
}
