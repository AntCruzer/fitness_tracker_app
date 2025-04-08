import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../services/db_service.dart';
import '../services/workout_db_service.dart';
import '../providers/theme_provider.dart';
import '../providers/workout_provider.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String userEmail;
  const SettingsScreen({super.key, required this.userEmail});

  void _logout(BuildContext context) {
    Hive.box('authBox').delete('loggedInEmail');
    Provider.of<WorkoutProvider>(context, listen: false).clearSession();
    Provider.of<ThemeProvider>(context, listen: false).reloadThemeForNewUser();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    await DBService().deleteUserByEmail(userEmail);
    Hive.box('authBox').delete('loggedInEmail');

    messenger.showSnackBar(
      const SnackBar(content: Text('Account deleted.')),
    );

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _clearHistory(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<WorkoutProvider>(context, listen: false);

    await WorkoutDBService().deleteAllSessionsForUser(userEmail);
    await provider.loadWorkoutHistory();

    messenger.showSnackBar(
      const SnackBar(content: Text('Workout history cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authBox = Hive.box('authBox');
    final notifKey = 'notificationsEnabled_$userEmail';
    final isNotifsEnabled = authBox.get(notifKey) ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: const Text("Enable Notifications"),
            value: isNotifsEnabled,
            onChanged: (val) => authBox.put(notifKey, val),
          ),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),

          const Divider(height: 32),
          const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log Out"),
            onTap: () => _logout(context),
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Delete Account"),
            onTap: () => _deleteAccount(context),
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Workout History"),
            onTap: () => Navigator.pushNamed(context, '/history'),
          ),

          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Clear Workout History"),
            onTap: () => _clearHistory(context),
          ),
        ],
      ),
    );
  }
}
