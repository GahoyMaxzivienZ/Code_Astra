import 'package:flutter/material.dart';

import 'language_picker_screen.dart';
import 'code_editor_screen.dart';
import 'exercises_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _violet = Color(0xFF3C3489);

  // Ginagamit ang IndexedStack para hindi mawala ang "state" ng bawat
  // tab kapag lumipat-lipat ang user (hal. hindi mawawala ang code na
  // kasalukuyang tine-type sa Compiler tab kahit pumunta muna sa Profile).
  static const List<Widget> _screens = [
    LanguagePickerScreen(),
    CodeEditorScreen(),
    ExercisesScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: Colors.white,
        indicatorColor: _violet.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: _violet),
            label: 'Lessons',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal, color: _violet),
            label: 'Compiler',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment, color: _violet),
            label: 'Exercises',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: _violet),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: _violet),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
