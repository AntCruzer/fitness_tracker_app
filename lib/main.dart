
// // main.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// // Providers
// import 'providers/workout_provider.dart';
// import 'providers/theme_provider.dart';

// // Screens (aliased to avoid naming conflict)
// import 'screens/main_shell.dart';
// import 'screens/signup_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/welcome_screen.dart';
// import 'screens/settings_screen.dart' as settings;
// import 'screens/workout_history_screen.dart' as history;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await Hive.openBox('authBox');

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => WorkoutProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _initialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
//       final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//       await workoutProvider.loadLatestWorkout();
//       themeProvider.reloadThemeForNewUser();
//     } catch (e) {
//       debugPrint("Initialization error: $e");
//     } finally {
//       setState(() => _initialized = true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authBox = Hive.box('authBox');
//     final savedEmail = authBox.get('loggedInEmail');
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     if (!_initialized) {
//       return const MaterialApp(
//         home: Scaffold(
//           body: Center(child: CircularProgressIndicator()),
//         ),
//       );
//     }

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'FlutterFit',
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       themeMode: themeProvider.themeMode,
//       home: savedEmail != null ? const MainShell() : const WelcomeScreen(),
//       routes: {
//         '/signup': (context) => const SignUpScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/settings': (context) {
//           final email = Hive.box('authBox').get('loggedInEmail') ?? '';
//           return settings.SettingsScreen(userEmail: email);
//         },
//         '/history': (context) => const history.WorkoutHistoryScreen(),
//       },
//     );
//   }
// }



// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Providers
import 'providers/workout_provider.dart';
import 'providers/theme_provider.dart';

// Screens (aliased to avoid naming conflict)
import 'screens/main_shell.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/settings_screen.dart' as settings;
import 'screens/workout_history_screen.dart' as history;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      await workoutProvider.loadLatestWorkout();
      await workoutProvider.loadWorkoutHistory(); // ✅ Load history for pie chart
      themeProvider.reloadThemeForNewUser();
    } catch (e) {
      debugPrint("Initialization error: $e");
    } finally {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('authBox');
    final savedEmail = authBox.get('loggedInEmail');
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterFit',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: savedEmail != null ? const MainShell() : const WelcomeScreen(),
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/settings': (context) {
          final email = Hive.box('authBox').get('loggedInEmail') ?? '';
          return settings.SettingsScreen(userEmail: email);
        },
        '/history': (context) => const history.WorkoutHistoryScreen(),
      },
    );
  }
}
