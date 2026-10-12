import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../exercises/exercises_data.dart' show exercisesFor;
import '../models/exercise.dart';
import '../services/auth_service.dart';
import '../utils/language_key.dart';
import 'code_editor_screen.dart' show ProgrammingLanguage;
import 'lessons_data.dart' show lessonsForDisplay;

/// Per-language progress summary, computed once the Firestore data comes
/// back — see _ProgressScreenState._load.
class _LanguageProgress {
  final ProgrammingLanguage language;
  final int lessonsCompleted;
  final int lessonsTotal;
  final Map<ExerciseDifficulty, int> exercisesCompletedByDifficulty;
  final Map<ExerciseDifficulty, int> exercisesTotalByDifficulty;

  const _LanguageProgress({
    required this.language,
    required this.lessonsCompleted,
    required this.lessonsTotal,
    required this.exercisesCompletedByDifficulty,
    required this.exercisesTotalByDifficulty,
  });

  int get exercisesCompleted =>
      exercisesCompletedByDifficulty.values.fold(0, (a, b) => a + b);

  int get exercisesTotal =>
      exercisesTotalByDifficulty.values.fold(0, (a, b) => a + b);

  int get itemsCompleted => lessonsCompleted + exercisesCompleted;

  int get itemsTotal => lessonsTotal + exercisesTotal;

  double get fraction => itemsTotal == 0 ? 0 : itemsCompleted / itemsTotal;
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const _violet = Color(0xFF3C3489);
  static const _bg = Color(0xFFEDE9FB);

  late Future<(List<_LanguageProgress>, DateTime?)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Pulls both the lesson completions ('progress' collection) and the
  /// exercise completions ('exercise_progress' collection, written by
  /// ExerciseResultScreen) for the current user, then combines them with
  /// the static curriculum (lessonsForDisplay / exercisesFor) to compute
  /// a completion count per language. Also returns the most recent
  /// activity timestamp across both collections, for "Last Active".
  Future<(List<_LanguageProgress>, DateTime?)> _load() async {
    final user = AuthService.currentUser;
    if (user == null) {
      return (const <_LanguageProgress>[], null);
    }

    final firestore = FirebaseFirestore.instance;

    final lessonDocs = await firestore
        .collection('progress')
        .where('user_id', isEqualTo: user.uid)
        .where('is_completed', isEqualTo: true)
        .get();

    final exerciseDocs = await firestore
        .collection('exercise_progress')
        .where('user_id', isEqualTo: user.uid)
        .where('is_completed', isEqualTo: true)
        .get();

    // language key -> set of completed lesson ids
    final completedLessonIds = <String, Set<String>>{};
    for (final doc in lessonDocs.docs) {
      final lang = doc.data()['language'] as String?;
      final lessonId = doc.data()['lesson_id'] as String?;
      if (lang == null || lessonId == null) continue;
      completedLessonIds.putIfAbsent(lang, () => {}).add(lessonId);
    }

    // language key -> set of completed exercise ids
    final completedExerciseIds = <String, Set<String>>{};
    for (final doc in exerciseDocs.docs) {
      final lang = doc.data()['language'] as String?;
      final exerciseId = doc.data()['exercise_id'] as String?;
      if (lang == null || exerciseId == null) continue;
      completedExerciseIds.putIfAbsent(lang, () => {}).add(exerciseId);
    }

    DateTime? lastActive;
    for (final doc in [...lessonDocs.docs, ...exerciseDocs.docs]) {
      final ts = doc.data()['completed_at'];
      if (ts is Timestamp) {
        final date = ts.toDate();
        if (lastActive == null || date.isAfter(lastActive)) {
          lastActive = date;
        }
      }
    }

    final results = <_LanguageProgress>[];
    for (final language in ProgrammingLanguage.values) {
      final langKey = language.key;

      final availableLessons = lessonsForDisplay(
        language,
      ).where((l) => l.availableFor(language)).toList();
      final completedForLang = completedLessonIds[langKey] ?? const {};
      final lessonsCompleted = availableLessons
          .where((l) => completedForLang.contains(l.id))
          .length;

      final exercisesTotalByDifficulty = <ExerciseDifficulty, int>{};
      final exercisesCompletedByDifficulty = <ExerciseDifficulty, int>{};
      final completedExercisesForLang =
          completedExerciseIds[langKey] ?? const {};
      for (final difficulty in ExerciseDifficulty.values) {
        final exercises = exercisesFor(language, difficulty: difficulty);
        exercisesTotalByDifficulty[difficulty] = exercises.length;
        exercisesCompletedByDifficulty[difficulty] = exercises
            .where((e) => completedExercisesForLang.contains(e.id))
            .length;
      }

      results.add(
        _LanguageProgress(
          language: language,
          lessonsCompleted: lessonsCompleted,
          lessonsTotal: availableLessons.length,
          exercisesCompletedByDifficulty: exercisesCompletedByDifficulty,
          exercisesTotalByDifficulty: exercisesTotalByDifficulty,
        ),
      );
    }

    return (results, lastActive);
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _future = future);
    await future;
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

  Color _difficultyColor(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.easy:
        return const Color(0xFF43A047);
      case ExerciseDifficulty.medium:
        return const Color(0xFFEF6C00);
      case ExerciseDifficulty.hard:
        return const Color(0xFFD32F2F);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _violet,
        foregroundColor: Colors.white,
        title: const Text('Progress'),
      ),
      body: FutureBuilder<(List<_LanguageProgress>, DateTime?)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildMessage(
              icon: Icons.error_outline,
              title: 'May Problema',
              subtitle: 'Hindi ma-load ang progress mo. Subukan ulit.',
            );
          }

          final (progressList, lastActive) = snapshot.data!;

          if (AuthService.currentUser == null) {
            return _buildMessage(
              icon: Icons.lock_outline,
              title: 'Mag-log In Muna',
              subtitle: 'Kailangan naka-log in para makita ang progress mo.',
            );
          }

          final startedLanguages = progressList
              .where((p) => p.itemsCompleted > 0)
              .length;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOverviewCard(startedLanguages, lastActive),
                const SizedBox(height: 16),
                for (final progress in progressList) ...[
                  _buildLanguageCard(progress),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: _violet.withValues(alpha: 0.35)),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _violet.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _violet.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    return '${_monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildOverviewCard(int startedLanguages, DateTime? lastActive) {
    final lastActiveLabel = lastActive == null
        ? 'Wala pang aktibidad'
        : _formatDate(lastActive);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _violet,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOverviewStat(
              icon: Icons.school_outlined,
              label: 'Languages Started',
              value: '$startedLanguages / ${ProgrammingLanguage.values.length}',
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _buildOverviewStat(
              icon: Icons.calendar_today_outlined,
              label: 'Last Active',
              value: lastActiveLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageCard(_LanguageProgress progress) {
    final percent = (progress.fraction * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _violet.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconFor(progress.language), color: _violet, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  progress.language.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _violet,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.fraction,
              minHeight: 8,
              backgroundColor: _violet.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation(_violet),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.menu_book_outlined, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(
                'Lessons: ${progress.lessonsCompleted}/${progress.lessonsTotal}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 14,
                color: Colors.black45,
              ),
              const SizedBox(width: 4),
              Text(
                'Exercises: ${progress.exercisesCompleted}/${progress.exercisesTotal}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          if (progress.exercisesTotal > 0) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final difficulty in ExerciseDifficulty.values)
                  if ((progress.exercisesTotalByDifficulty[difficulty] ?? 0) >
                      0)
                    _buildDifficultyChip(
                      difficulty,
                      progress.exercisesCompletedByDifficulty[difficulty] ??
                          0,
                      progress.exercisesTotalByDifficulty[difficulty] ?? 0,
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(
    ExerciseDifficulty difficulty,
    int completed,
    int total,
  ) {
    final color = _difficultyColor(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '${difficulty.label}: $completed/$total',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
