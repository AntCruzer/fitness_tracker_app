// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'providers/workout_provider.dart';
// import 'providers/theme_provider.dart';

// import 'screens/main_shell.dart';
// import 'screens/welcome_screen.dart';
// import 'screens/settings_screen.dart' as settings;
// import 'screens/workout_history_screen.dart' as history;
// import 'screens/login_screen.dart' as login_screen;
// import 'screens/signup_screen.dart' as signup_screen;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   await Hive.openBox('authBox');
//   await Hive.openBox('workoutBox');

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

//   final lightTheme = ThemeData(
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//     useMaterial3: true,
//     cardTheme: const CardTheme(
//       elevation: 2,
//       margin: EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.indigo,
//       foregroundColor: Colors.white,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     ),
//   );

//   final darkTheme = ThemeData(
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
//     useMaterial3: true,
//   );

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
//       await workoutProvider.loadWorkoutHistory();
//       themeProvider.reloadThemeForNewUser();
//     } catch (e) {
//       debugPrint("Initialization error: $e");
//     } finally {
//       setState(() => _initialized = true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final authBox = Hive.box('authBox');

//     if (!_initialized) {
//       return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
//     }

//     return ValueListenableBuilder(
//       valueListenable: authBox.listenable(keys: ['loggedInEmail']),
//       builder: (context, Box box, _) {
//         final loggedInEmail = box.get('loggedInEmail');
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'FlutterFit',
//           theme: lightTheme,
//           darkTheme: darkTheme,
//           themeMode: themeProvider.themeMode,
//           home: loggedInEmail != null ? const MainShell() : const WelcomeScreen(),
//           routes: {
//             '/signup': (context) => const signup_screen.SignUpScreen(),
//             '/login': (context) => const login_screen.LoginScreen(),
//             '/settings': (context) {
//               final email = Hive.box('authBox').get('loggedInEmail') ?? '';
//               return settings.SettingsScreen(userEmail: email);
//             },
//             '/history': (context) => const history.WorkoutHistoryScreen(),
//           },
//         );
//       },
//     );
//   }
// }


// IMPORTS FLUTTER CORE UI PACKAGE
import 'package:flutter/material.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS HIVE FOR LOCAL PERSISTENT STORAGE
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS WORKOUT AND THEME PROVIDERS
import 'providers/workout_provider.dart';
import 'providers/theme_provider.dart';

// IMPORTS MAIN SCREEN COMPONENTS
import 'screens/main_shell.dart';
import 'screens/welcome_screen.dart';
import 'screens/settings_screen.dart' as settings;
import 'screens/workout_history_screen.dart' as history;
import 'screens/login_screen.dart' as login_screen;
import 'screens/signup_screen.dart' as signup_screen;

// MAIN FUNCTION - APP ENTRY POINT
void main() async {
  // ENSURES FLUTTER BINDINGS ARE INITIALIZED BEFORE ASYNC CALLS
  WidgetsFlutterBinding.ensureInitialized();

  // INITIALIZE HIVE AND OPEN STORAGE BOXES
  await Hive.initFlutter();
  await Hive.openBox('authBox');      // STORES LOGIN STATE AND USER PREFS
  await Hive.openBox('workoutBox');   // STORES WORKOUT SESSIONS

  // RUN THE APP WITH MULTIPLE PROVIDERS
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),  // WORKOUT STATE PROVIDER
        ChangeNotifierProvider(create: (_) => ThemeProvider()),    // THEME MODE PROVIDER
      ],
      child: const MyApp(),
    ),
  );
}

// ROOT WIDGET FOR THE APPLICATION
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// STATE CLASS FOR MYAPP
class _MyAppState extends State<MyApp> {
  bool _initialized = false;                      // TRACKS IF APP INITIALIZATION IS COMPLETE

  // DEFINES CUSTOM LIGHT THEME
  final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    useMaterial3: true,
    cardTheme: const CardTheme(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  // DEFINES CUSTOM DARK THEME
  final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
    useMaterial3: true,
  );

  // INITIALIZATION LOGIC RUN ONCE AT STARTUP
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  // ASYNC INITIALIZATION - LOADS WORKOUT DATA AND USER THEME
  Future<void> _initializeApp() async {
    try {
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      // LOADS CURRENT WORKOUT SESSION AND HISTORY
      await workoutProvider.loadLatestWorkout();
      await workoutProvider.loadWorkoutHistory();

      // LOADS SAVED THEME FOR LOGGED-IN USER
      themeProvider.reloadThemeForNewUser();
    } catch (e) {
      debugPrint("INITIALIZATION ERROR: $e");
    } finally {
      setState(() => _initialized = true); // MARK APP AS INITIALIZED
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);     // GET CURRENT THEME SETTING
    final authBox = Hive.box('authBox');                           // ACCESS AUTH STORAGE BOX

    // SHOW LOADING SPINNER UNTIL INITIALIZATION COMPLETES
    if (!_initialized) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    // LISTENS FOR CHANGES TO LOGIN STATE
    return ValueListenableBuilder(
      valueListenable: authBox.listenable(keys: ['loggedInEmail']),
      builder: (context, Box box, _) {
        final loggedInEmail = box.get('loggedInEmail');

        // DEFINES ROOT MATERIALAPP
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterFit',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode, // LIGHT OR DARK MODE

          // IF LOGGED IN, GO TO MAIN SHELL; ELSE GO TO WELCOME SCREEN
          home: loggedInEmail != null ? const MainShell() : const WelcomeScreen(),

          // ROUTE DEFINITIONS
          routes: {
            '/signup': (context) => const signup_screen.SignUpScreen(),
            '/login': (context) => const login_screen.LoginScreen(),
            '/settings': (context) {
              final email = Hive.box('authBox').get('loggedInEmail') ?? '';
              return settings.SettingsScreen(userEmail: email);
            },
            '/history': (context) => const history.WorkoutHistoryScreen(),
          },
        );
      },
    );
  }
}