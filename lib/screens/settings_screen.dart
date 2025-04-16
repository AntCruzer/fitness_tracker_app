// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR LOCAL PERSISTENT STORAGE
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS SERVICES FOR USER AND WORKOUT DATA OPERATIONS
import '../services/db_service.dart';
import '../services/workout_db_service.dart';

// IMPORTS THEME AND WORKOUT PROVIDERS
import '../providers/theme_provider.dart';
import '../providers/workout_provider.dart';

// IMPORTS WORKOUT HISTORY SCREEN FOR NAVIGATION
import 'workout_history_screen.dart';

// DEFINES A STATEFUL WIDGET FOR THE SETTINGS SCREEN
class SettingsScreen extends StatefulWidget {
  final String userEmail; // USER EMAIL PASSED IN FOR PERSONALIZED SETTINGS

  const SettingsScreen({super.key, required this.userEmail});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// DEFINES STATE CLASS FOR THE SETTINGS SCREEN
class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = false; // TRACKS IF LOADING SPINNER SHOULD BE SHOWN

  // SHOWS A SNACKBAR MESSAGE
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // HANDLES USER LOGOUT PROCESS
  Future<void> _logout() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final confirm = await _confirmAction("Log Out", "Are you sure you want to log out?");
    if (!confirm) return;

    setState(() => _loading = true);
    final authBox = Hive.box('authBox');

    // CLEARS ALL STORED SESSION DATA
    await authBox.delete('loggedInEmail');
    await authBox.delete('notificationsEnabled_${widget.userEmail}');
    // await authBox.delete('isDarkMode_${widget.userEmail}');

    workoutProvider.clearSession();
    themeProvider.reloadThemeForNewUser();
    themeProvider.resetToSystemTheme();


    if (!mounted) return;
    setState(() => _loading = false);

    // NAVIGATE TO WELCOME SCREEN
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // HANDLES ACCOUNT DELETION PROCESS
  Future<void> _deleteAccount() async {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final confirm = await _confirmAction("Delete Account", "Are you sure you want to delete your account?");
    if (!confirm) return;

    setState(() => _loading = true);
    final authBox = Hive.box('authBox');

    // DELETE FROM SQLITE AND HIVE
    await DBService().deleteUserByEmail(widget.userEmail);
    await authBox.delete('loggedInEmail');
    await authBox.delete('notificationsEnabled_${widget.userEmail}');
    // await authBox.delete('isDarkMode_${widget.userEmail}');

    workoutProvider.clearSession();
    themeProvider.reloadThemeForNewUser();

    if (!mounted) return;
    setState(() => _loading = false);

    // NAVIGATE TO WELCOME SCREEN
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // CLEARS ALL WORKOUT HISTORY FROM DATABASE
  Future<void> _clearHistory() async {
    final confirm = await _confirmAction("Clear History", "Clear all workout history?");
    if (!confirm) return;

    setState(() => _loading = true);

    await WorkoutDBService().deleteAllSessionsForUser(widget.userEmail);

    if (!mounted) return;

    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    await provider.loadWorkoutHistory();

    if (!mounted) return;

    setState(() => _loading = false);
    _showSnack("Workout history cleared.");
  }

  // SHOWS A CONFIRMATION DIALOG FOR SENSITIVE ACTIONS
  Future<bool> _confirmAction(String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
            ],
          ),
        ) ??
        false;
  }

  // BUILDS THE SETTINGS SCREEN UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authBox = Hive.box('authBox');
    final notifKey = 'notificationsEnabled_${widget.userEmail}';
    final isNotifsEnabled = authBox.get(notifKey) ?? false;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // REMOVES BACK BUTTON
            title: const Text("Settings"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // PREFERENCES SECTION
              const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    // NOTIFICATION TOGGLE
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active),
                      title: const Text("Enable Notifications"),
                      value: isNotifsEnabled,
                      onChanged: (val) => authBox.put(notifKey, val),
                    ),
                    const Divider(height: 0),

                    // DARK MODE TOGGLE
                    ListTile(
                      leading: Icon(
                        themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Dark Mode: ${themeProvider.themeMode == ThemeMode.dark ? 'On' : 'Off'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Switch(
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (enabled) {
                          final mode = enabled ? ThemeMode.dark : ThemeMode.light;
                          themeProvider.setThemeMode(mode);
                          Hive.box('authBox').put('isDarkMode_${widget.userEmail}', enabled);
                        },
                      ),
                      onTap: () {
                        final enabled = themeProvider.themeMode != ThemeMode.dark;
                        final mode = enabled ? ThemeMode.dark : ThemeMode.light;
                        themeProvider.setThemeMode(mode);
                        Hive.box('authBox').put('isDarkMode_${widget.userEmail}', enabled);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ACCOUNT SECTION
              const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    // LOGOUT OPTION
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Log Out"),
                      onTap: _logout,
                    ),
                    const Divider(height: 0),

                    // DELETE ACCOUNT OPTION
                    ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text("Delete Account"),
                      onTap: _deleteAccount,
                    ),
                    const Divider(height: 0),

                    // VIEW WORKOUT HISTORY
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text("Workout History"),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen()),
                        );
                      },
                    ),
                    const Divider(height: 0),

                    // CLEAR WORKOUT HISTORY
                    ListTile(
                      leading: const Icon(Icons.delete_outline),
                      title: const Text("Clear Workout History"),
                      onTap: _clearHistory,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // LOADING OVERLAY WHILE OPERATIONS ARE RUNNING
        if (_loading)
          Container(
            color: const Color.fromRGBO(0, 0, 0, 0.25),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}