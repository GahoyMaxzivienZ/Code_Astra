import 'package:flutter/material.dart';

import 'code_editor_screen.dart';
import 'lessons_list_screen.dart';

class LanguageIntroContent {
  final String creator;
  final String year;
  final String description;
  final List<String> funFacts;
  final List<String> commonUses;

  const LanguageIntroContent({
    required this.creator,
    required this.year,
    required this.description,
    required this.funFacts,
    required this.commonUses,
  });
}

const Map<ProgrammingLanguage, LanguageIntroContent> languageIntros = {
  ProgrammingLanguage.java: LanguageIntroContent(
    creator: 'James Gosling (Sun Microsystems)',
    year: '1995',
    description:
        'Ginawa si Java noong 1990s bilang isang language na "write once, run '
        'anywhere" — ibig sabihin, ang isang Java program ay pwedeng tumakbo '
        'sa halos kahit anong device (Windows, Mac, Linux, Android), basta '
        'may Java Virtual Machine (JVM) ito. Ito ay isang object-oriented '
        'language na may strict na type system.',
    funFacts: [
      'Orihinal na pangalan ni Java ay "Oak", pinangalanan sa isang puno sa labas ng opisina ni Gosling.',
      'Isa sa pinaka-ginagamit na language para sa Android app development.',
    ],
    commonUses: [
      'Android apps',
      'Enterprise/banking systems',
      'Server-side backends',
    ],
  ),
  ProgrammingLanguage.cpp: LanguageIntroContent(
    creator: 'Bjarne Stroustrup',
    year: '1985',
    description:
        'Si C++ ay ginawa bilang extension ng C language — noong una, '
        'literal na tinawag itong "C with Classes". Idinagdag nito ang '
        'object-oriented programming sa C, habang pinapanatili ang '
        'kakayahang direktang kontrolin ang memory ng computer.',
    funFacts: [
      'Ginagamit ang C++ sa halos lahat ng malalaking video game engines (Unreal Engine, halimbawa).',
      'Kilala ang C++ sa "performance" — mabilis itong tumakbo dahil malapit ito sa hardware.',
    ],
    commonUses: [
      'Game engines',
      'Operating systems',
      'High-performance software',
    ],
  ),
  ProgrammingLanguage.python: LanguageIntroContent(
    creator: 'Guido van Rossum',
    year: '1991',
    description:
        'Ginawa si Python noong 1980s-1990s dahil gusto ni Guido van Rossum '
        'ng isang language na madaling basahin at isulat, tulad ng '
        'English pseudocode. Ito ang dahilan kung bakit walang { } braces '
        'si Python — indentation (spacing) na lang ang gumagawa ng blocks.',
    funFacts: [
      'Pinangalanan si Python sa "Monty Python\'s Flying Circus", isang British comedy show — hindi sa ahas!',
      'Isa sa pinaka-ginagamit na language ngayon sa Artificial Intelligence at Data Science.',
    ],
    commonUses: ['Data science / AI', 'Automation scripts', 'Web development'],
  ),
  ProgrammingLanguage.csharp: LanguageIntroContent(
    creator: 'Anders Hejlsberg (Microsoft)',
    year: '2000',
    description:
        'Ginawa ni Microsoft si C# bilang bahagi ng .NET framework nila, '
        'bilang alternatibo sa Java. Malapit ang structure nito sa Java '
        '(parehong object-oriented, parehong may class-based na organisasyon), '
        'pero may sarili itong ecosystem at features.',
    funFacts: [
      'Ang "#" sa pangalan ay tumutukoy sa musical na "sharp" — parang C na "pinataas" ang antas.',
      'Ang Unity, isa sa pinaka-sikat na game engines, ay gumagamit ng C# bilang scripting language.',
    ],
    commonUses: [
      'Windows applications',
      'Game development (Unity)',
      'Enterprise software',
    ],
  ),
  ProgrammingLanguage.php: LanguageIntroContent(
    creator: 'Rasmus Lerdorf',
    year: '1994',
    description:
        'Nagsimula si PHP bilang isang simpleng set ng tools na ginawa ni '
        'Rasmus Lerdorf para sa sarili niyang personal na website — ang '
        'orihinal na ibig sabihin ng PHP ay "Personal Home Page". Kalaunan, '
        'naging isa ito sa pinaka-ginagamit na server-side scripting language '
        'sa buong internet.',
    funFacts: [
      'Malaking bahagi ng web ay gumagamit ng PHP sa likod ng eksena — kasama na ang WordPress.',
      'Lahat ng variables sa PHP ay may "\$" sa unahan ng pangalan.',
    ],
    commonUses: [
      'Web backend development',
      'Content management systems',
      'Server-side scripting',
    ],
  ),
  ProgrammingLanguage.javascript: LanguageIntroContent(
    creator: 'Brendan Eich (Netscape)',
    year: '1995',
    description:
        'Kakaiba ang kwento ni JavaScript — ginawa ito ni Brendan Eich sa '
        'loob lamang ng SAMPUNG ARAW noong 1995! Orihinal itong ginawa para '
        'lang gumana sa loob ng web browser (Netscape), pero ngayon '
        'ginagamit na rin ito sa server-side (via Node.js).',
    funFacts: [
      'Kahit magkatulad ang pangalan, WALANG kaugnayan sina JavaScript at Java sa isa\'t isa.',
      'Isa lang si JavaScript sa mga language na kayang tumakbo direkta sa loob ng web browser.',
    ],
    commonUses: [
      'Web development (frontend)',
      'Server-side (Node.js)',
      'Mobile apps',
    ],
  ),
};

class LanguageIntroScreen extends StatelessWidget {
  final ProgrammingLanguage language;
  final String languageLabel;
  final IconData languageIcon;
  final Color languageColor;

  const LanguageIntroScreen({
    super.key,
    required this.language,
    required this.languageLabel,
    required this.languageIcon,
    required this.languageColor,
  });

  static const _bg = Color(0xFFEDE9FB);

  @override
  Widget build(BuildContext context) {
    final content = languageIntros[language]!;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: languageColor,
        foregroundColor: Colors.white,
        title: Text(languageLabel),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: languageColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(languageIcon, size: 48, color: languageColor),
            ),
          ),
          const SizedBox(height: 20),

          _infoCard(
            icon: Icons.history_edu,
            title: 'Kasaysayan',
            color: languageColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoLine('Ginawa ni:', content.creator),
                _infoLine('Taon:', content.year),
                const SizedBox(height: 10),
                Text(
                  content.description,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          _infoCard(
            icon: Icons.lightbulb_outline,
            title: 'Fun Facts',
            color: languageColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.funFacts
                  .map(
                    (fact) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 13)),
                          Expanded(
                            child: Text(
                              fact,
                              style: const TextStyle(fontSize: 13, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),

          _infoCard(
            icon: Icons.build_outlined,
            title: 'Ginagamit Para Sa',
            color: languageColor,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: content.commonUses
                  .map(
                    (use) => Chip(
                      label: Text(use, style: const TextStyle(fontSize: 12)),
                      backgroundColor: languageColor.withOpacity(0.1),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonsListScreen(
                      language: language,
                      languageLabel: languageLabel,
                      languageColor: languageColor,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: languageColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Magsimula sa mga Lessons'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
