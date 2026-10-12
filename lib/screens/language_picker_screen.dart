import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../services/auth_service.dart';
import 'code_editor_screen.dart';
import 'lessons_list_screen.dart';
import 'lessons_data.dart';

class _LanguageOption {
  final ProgrammingLanguage language;
  final String label;
  final String fileName;
  final IconData icon;
  final Color color;

  const _LanguageOption(
    this.language,
    this.label,
    this.fileName,
    this.icon,
    this.color,
  );
}

const List<_LanguageOption> _languageOptions = [
  _LanguageOption(
    ProgrammingLanguage.java,
    'Java',
    'Main.java',
    Icons.coffee,
    Color(0xFFEF6C00),
  ),
  _LanguageOption(
    ProgrammingLanguage.cpp,
    'C++',
    'main.cpp',
    Icons.memory,
    Color(0xFF1976D2),
  ),
  _LanguageOption(
    ProgrammingLanguage.python,
    'Python',
    'main.py',
    Icons.code,
    Color(0xFF43A047),
  ),
  _LanguageOption(
    ProgrammingLanguage.csharp,
    'C#',
    'Program.cs',
    Icons.tag,
    Color(0xFF7C4DFF),
  ),
  _LanguageOption(
    ProgrammingLanguage.php,
    'PHP',
    'index.php',
    Icons.php,
    Color(0xFF8E44AD),
  ),
  _LanguageOption(
    ProgrammingLanguage.javascript,
    'JavaScript',
    'script.js',
    Icons.javascript,
    Color(0xFFF9A825),
  ),
];

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

class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen({super.key});

  static const _violet = Color(0xFF3C3489);
  static const _bg = Color(0xFFEDE9FB);

  void _openIntro(BuildContext context, _LanguageOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonsListScreen(
          language: option.language,
          languageLabel: option.label,
          languageColor: option.color,
        ),
      ),
    );
  }

  String _firstName(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) {
      return '';
    }

    return displayName.trim().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final firstName = _firstName(user?.displayName);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: user == null
              ? null
              : FirebaseFirestore.instance
                    .collection('progress')
                    .where('user_id', isEqualTo: user.uid)
                    .snapshots(),
          builder: (context, snapshot) {
            final isLoading =
                user != null &&
                snapshot.connectionState == ConnectionState.waiting;

            final Map<String, int> completedCounts = {};

            if (snapshot.hasData) {
              for (final doc in snapshot.data!.docs) {
                final data = doc.data() as Map<String, dynamic>;

                if (data['is_completed'] == true) {
                  final lang = data['language'] as String? ?? '';

                  completedCounts[lang] = (completedCounts[lang] ?? 0) + 1;
                }
              }
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  sliver: SliverToBoxAdapter(
                    child:
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstName.isEmpty
                                      ? 'Hello!'
                                      : 'Hello, $firstName!',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: _violet,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Select the language you want to learn',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: _violet.withOpacity(0.55),
                                  ),
                                ),
                              ],
                            )
                            .animate()
                            .fadeIn(duration: 350.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 350.ms,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  sliver: isLoading
                      ? SliverList.separated(
                          itemCount: 6,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) =>
                              const _ShimmerLanguageCard(),
                        )
                      : SliverList.separated(
                          itemCount: _languageOptions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final option = _languageOptions[index];

                            final completed =
                                completedCounts[_keyFor(option.language)] ?? 0;

                            final total = lessonsForDisplay(option.language)
                                .where((l) => l.availableFor(option.language))
                                .length;

                            return _LanguageWindowCard(
                                  option: option,
                                  completed: completed,
                                  total: total,
                                  staggerIndex: index,
                                  onTap: () => _openIntro(context, option),
                                )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: (index * 80).ms,
                                )
                                .slideY(
                                  begin: 0.15,
                                  end: 0,
                                  duration: 400.ms,
                                  delay: (index * 80).ms,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Placeholder card na lumalabas habang naghihintay pa ng Firestore data.
/// Parehong shape ng totoong card para hindi "jumpy" yung layout pag
/// pinalitan na ng totoong laman.
class _ShimmerLanguageCard extends StatelessWidget {
  const _ShimmerLanguageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 92,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 6,
                        color: Colors.grey.shade200,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.6));
  }
}

class _LanguageWindowCard extends StatefulWidget {
  final _LanguageOption option;
  final int completed;
  final int total;
  final int staggerIndex;
  final VoidCallback onTap;

  const _LanguageWindowCard({
    required this.option,
    required this.completed,
    required this.total,
    required this.staggerIndex,
    required this.onTap,
  });

  @override
  State<_LanguageWindowCard> createState() => _LanguageWindowCardState();
}

class _LanguageWindowCardState extends State<_LanguageWindowCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final option = widget.option;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Terminal window header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: const Color(0xFF1E1E2E),
                child: Row(
                  children: [
                    _dot(const Color(0xFFFF5F56)),
                    const SizedBox(width: 6),
                    _dot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 6),
                    _dot(const Color(0xFF27C93F)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.fileName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: option.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(option.icon, size: 22, color: option.color),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: option.color,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // FIXED RESPONSIVE PROGRESS — animated fill
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    for (var i = 0; i < widget.total; i++) ...[
                                      Expanded(
                                        child:
                                            Container(
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: i < widget.completed
                                                    ? option.color
                                                    : option.color.withOpacity(
                                                        0.15,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            ).animate().scaleX(
                                              begin: 0,
                                              end: 1,
                                              alignment: Alignment.centerLeft,
                                              duration: 450.ms,
                                              delay:
                                                  (widget.staggerIndex * 80 +
                                                          200 +
                                                          i * 30)
                                                      .ms,
                                              curve: Curves.easeOutCubic,
                                            ),
                                      ),
                                      if (i < widget.total - 1)
                                        const SizedBox(width: 4),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.completed}/${widget.total} lessons',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: option.color.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Icon(
                      Icons.chevron_right,
                      color: option.color.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
