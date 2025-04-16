// IMPORTS FLUTTER WIDGETS FOR UI
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS SCREENS USED FOR EACH TAB
import '../screens/home_screen.dart';
import '../screens/choose_workout_screen.dart';
import '../screens/current_workout_screen.dart';
import '../screens/settings_screen.dart' as settings;

// IMPORTS NAVIGATION BAR AND TAB CONTROLLER PROVIDER
import '../widgets/app_nav_bar.dart';
import '../widgets/tab_controller_provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userEmail = Hive.box('authBox').get('loggedInEmail') ?? '';

    // LIST OF PER-TAB NAVIGATORS TO PRESERVE STATE
    final List<Widget> screens = [
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      ),
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const ChooseWorkoutScreen(),
        ),
      ),
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const CurrentWorkoutScreen(),
        ),
      ),
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => settings.SettingsScreen(userEmail: userEmail),
        ),
      ),
    ];

    return TabControllerProvider(
      setTab: (index) => setState(() => _currentIndex = index),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: AppNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}