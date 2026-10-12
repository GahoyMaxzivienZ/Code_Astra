import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../services/auth_service.dart';
import '../services/compiler_service.dart';
import '../utils/error_tips.dart';
import '../utils/language_key.dart';

/// Dedicated screen shown after running an exercise's code. Handles three
/// outcomes:
/// 1. Compiler error — shows the raw error plus a beginner-friendly tip.
/// 2. Ran fine but wrong output — shows an "expected vs. got" diff plus a
///    tip about checking exact formatting.
/// 3. Ran fine and output matches — success state, which also saves the
///    completion to Firestore (see _saveProgress below) so the Progress
///    screen can pick it up.
class ExerciseResultScreen extends StatefulWidget {
  final Exercise exercise;
  final CompilerResult result;
  final Color languageColor;

  const ExerciseResultScreen({
    super.key,
    required this.exercise,
    required this.result,
    required this.languageColor,
  });

  @override
  State<ExerciseResultScreen> createState() => _ExerciseResultScreenState();
}

class _ExerciseResultScreenState extends State<ExerciseResultScreen> {
  static const _bg = Color(0xFFF4F2FB);

  Exercise get exercise => widget.exercise;
  CompilerResult get result => widget.result;
  Color get languageColor => widget.languageColor;

  bool get _outputMatches {
    if (!result.success) return false;
    return result.output.trim() == exercise.expectedOutput.trim();
  }

  @override
  void initState() {
    super.initState();
    if (_outputMatches) {
      // Fire-and-forget — we don't want a slow/failed write to block the
      // student from seeing their result.
      _saveProgress();
    }
  }

  /// Saves this exercise as completed to Firestore, under the same
  /// 'exercise_progress' collection shape as structure_exercise_screen.dart
  /// uses for its 'progress' collection — one doc per user+language+item,
  /// so re-solving an exercise just overwrites the same doc.
  Future<void> _saveProgress() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      final langKey = exercise.language.key;
      await FirebaseFirestore.instance
          .collection('exercise_progress')
          .doc('${user.uid}_${langKey}_${exercise.id}')
          .set({
            'user_id': user.uid,
            'language': langKey,
            'exercise_id': exercise.id,
            'difficulty': exercise.difficulty.name,
            'is_completed': true,
            'completed_at': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (_) {
      // Hindi natin gustong ma-block ang UI kung magkaproblema ang
      // Firestore — nakita na ng student yung tamang result nila kahit
      // paano.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _outputMatches;
    final statusColor = isCorrect ? Colors.green : Colors.redAccent;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: languageColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Result',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatusBanner(isCorrect, statusColor),
            const SizedBox(height: 16),
            if (!result.success) ...[
              _buildSectionLabel('Error'),
              _buildCodeBlock(result.error, Colors.redAccent),
              _buildTipCard(ErrorTips.friendlyTip(result.error)),
            ] else ...[
              _buildSectionLabel('Actual Output'),
              _buildCodeBlock(
                result.output.isEmpty ? '(walang output)' : result.output,
                isCorrect ? Colors.green : Colors.black87,
              ),
              if (!isCorrect) ...[
                const SizedBox(height: 14),
                _buildSectionLabel('Inaasahang Output'),
                _buildCodeBlock(exercise.expectedOutput, languageColor),
                _buildTipCard(ErrorTips.outputMismatchTip()),
              ],
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: languageColor,
                  side: BorderSide(color: languageColor, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: Text(isCorrect ? 'Bumalik sa Editor' : 'Subukan Ulit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(bool isCorrect, Color statusColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.error_outline,
            color: statusColor,
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? 'Tama! Kumpleto ang exercise mo! 🎉'
                  : (result.success
                        ? 'Tumakbo nang maayos, pero hindi pa tugma ang output.'
                        : 'May error sa code mo.'),
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

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCodeBlock(String text, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          color: textColor == Colors.black87 ? Colors.white : textColor,
        ),
      ),
    );
  }

  Widget _buildTipCard(String? tip) {
    if (tip == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
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
      ),
    );
  }
}
