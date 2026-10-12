import 'package:flutter/material.dart';

import '../exercises/exercises_data.dart';
import '../models/exercise.dart';
import 'code_editor_screen.dart' show ProgrammingLanguage;
import 'exercise_screen.dart';

/// Flat, matte na redesign ng Exercises screen — sinusunod yung layout ng
/// HTML mockup: violet header banner, language picker bilang grid ng mga
/// "chip" (hindi dropdown), tapos per-difficulty section na may
/// dot-labeled header at 2-column na exercise cards. Sadyang walang
/// BoxShadow kahit saan — border na lang ang ginagamit para sa depth,
/// kasi mas "flat/matte" ang peg, hindi yung malutong/glossy na drop
/// shadow look.
class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  static const _violet = Color(0xFF3C3489);
  static const _bg = Color(0xFFEDE9FB);
  static const _cardBorder = Color(0xFFE2DEF3);

  ProgrammingLanguage _selectedLanguage = ProgrammingLanguage.java;

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

  /// Maikling abbreviation na ipapakita sa language icon box — sinusunod
  /// yung eksaktong laman ng HTML mockup ("J", "C+", "Py", "JS", "C#",
  /// "PHP") imbes na gumamit ng Material icon glyphs.
  String _abbrevFor(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.java:
        return 'J';
      case ProgrammingLanguage.cpp:
        return 'C+';
      case ProgrammingLanguage.python:
        return 'Py';
      case ProgrammingLanguage.javascript:
        return 'JS';
      case ProgrammingLanguage.csharp:
        return 'C#';
      case ProgrammingLanguage.php:
        return 'PHP';
    }
  }

  Color _colorForDifficulty(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.easy:
        return const Color(0xFF2E7D32);
      case ExerciseDifficulty.medium:
        return const Color(0xFFE65100);
      case ExerciseDifficulty.hard:
        return const Color(0xFFC62828);
    }
  }

  /// Kinukuha yung unang pangungusap/linya ng `instructions` bilang
  /// maikling paglalarawan sa card — hindi kailangan magdagdag ng bagong
  /// field sa Exercise model o baguhin yung 18 data files bawat wika.
  String _shortDescription(Exercise exercise) {
    final text = exercise.instructions.trim();
    final periodIdx = text.indexOf('. ');
    final newlineIdx = text.indexOf('\n');
    var cut = text.length;
    if (periodIdx != -1) cut = periodIdx + 1;
    if (newlineIdx != -1 && newlineIdx < cut) cut = newlineIdx;
    var desc = text.substring(0, cut).trim();
    if (desc.length > 90) desc = '${desc.substring(0, 87)}...';
    return desc;
  }

  void _openExercise(Exercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ExerciseScreen(exercise: exercise, languageColor: _violet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = exercisesGroupedByDifficulty(_selectedLanguage);

    // Sunud-sunod na numbering (01, 02, ...) sa buong listahan ng wikang
    // napili, kasabay ang pagkaka-ayos ng ExerciseDifficulty.values
    // (easy -> medium -> hard) — kagaya ng ginawa sa HTML mockup.
    var runningNumber = 0;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Choose a Language',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF29235F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _languageGrid(),
                  const SizedBox(height: 18),
                  for (final difficulty in ExerciseDifficulty.values)
                    _difficultySection(
                      difficulty,
                      grouped[difficulty] ?? const [],
                      numberOffset: () {
                        final start = runningNumber;
                        runningNumber +=
                            (grouped[difficulty] ?? const []).length;
                        return start;
                      }(),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: const BoxDecoration(
        color: _violet,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercises',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Practice your programming skills through coding exercises.',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _languageGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 700 ? 6 : 3;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.95,
          children: ProgrammingLanguage.values
              .map((lang) => _languageChip(lang))
              .toList(),
        );
      },
    );
  }

  Widget _languageChip(ProgrammingLanguage lang) {
    final isActive = lang == _selectedLanguage;
    return InkWell(
      onTap: () => setState(() => _selectedLanguage = lang),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? _violet : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? _violet : _cardBorder,
            width: isActive ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withValues(alpha: 0.15) : _bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _abbrevFor(lang),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : _violet,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _labelFor(lang),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultySection(
    ExerciseDifficulty difficulty,
    List<Exercise> exercises, {
    required int numberOffset,
  }) {
    if (exercises.isEmpty) return const SizedBox.shrink();
    final color = _colorForDifficulty(difficulty);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 9),
              Text(
                difficulty.label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoCol = constraints.maxWidth >= 460;
              return GridView.count(
                crossAxisCount: twoCol ? 2 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: twoCol ? 2.7 : 4.3,
                children: [
                  for (var i = 0; i < exercises.length; i++)
                    _exerciseCard(exercises[i], numberOffset + i + 1),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _exerciseCard(Exercise exercise, int number) {
    final numberLabel = number.toString().padLeft(2, '0');
    return InkWell(
      onTap: () => _openExercise(exercise),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _cardBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                numberLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _violet,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    exercise.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF252252),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _shortDescription(exercise),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF777777),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFAAAAAA), size: 22),
          ],
        ),
      ),
    );
  }
}
