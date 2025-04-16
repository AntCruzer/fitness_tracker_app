// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR LOCAL DATA STORAGE (SESSION HANDLING)
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS DATABASE SERVICE FOR STORING USER DATA
import '../services/db_service.dart';

// IMPORTS USER MODEL
import '../models/user.dart';

// IMPORTS PROVIDERS FOR THEME AND WORKOUT STATE
import '../providers/theme_provider.dart';
import '../providers/workout_provider.dart';

// DEFINES SIGNUP SCREEN AS A STATEFUL WIDGET
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// DEFINES STATE CLASS FOR SIGNUP SCREEN
class _SignUpScreenState extends State<SignUpScreen> {

  // FORM KEY TO VALIDATE INPUT
  final _formKey = GlobalKey<FormState>();

  // TEXT CONTROLLERS FOR INPUT FIELDS
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // LOADING STATE TO DISABLE FORM WHILE SUBMITTING
  bool _loading = false;

  // HANDLES FORM SUBMISSION AND USER REGISTRATION
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);

    final email = _emailController.text.trim();

    // CREATES A NEW USER OBJECT
    final user = User(
      username: _usernameController.text.trim(),
      email: email,
      password: _passwordController.text.trim(),
    );

    try {
      // INSERT USER INTO SQLITE DATABASE
      await DBService().insertUser(user);

      // STORE LOGGED-IN STATE USING HIVE
      Hive.box('authBox').put('loggedInEmail', email);

      if (!mounted) return;

      // LOAD USER-THEMED PREFERENCES AND WORKOUT STATE
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

      themeProvider.reloadThemeForNewUser();
      await workoutProvider.loadLatestWorkout();
      await workoutProvider.loadWorkoutHistory();

      // RETURN TO MAIN SCREEN
      navigator.popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      // SHOW ERROR IF USER ALREADY EXISTS
      scaffold.showSnackBar(
        const SnackBar(content: Text('Email already registered')),
      );
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  // CLEAN UP TEXT CONTROLLERS WHEN WIDGET IS DISPOSED
  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // BUILDS THE SIGNUP SCREEN UI
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // PREVENTS BACK NAVIGATION TO PRIOR SCREENS
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // REMOVES BACK BUTTON
          title: const Text('Sign Up'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey, // WRAPS FORM WITH VALIDATION KEY
            child: Column(
              children: [
                // USERNAME INPUT FIELD
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter username' : null,
                ),

                // EMAIL INPUT FIELD
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                ),

                // PASSWORD INPUT FIELD
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) => v == null || v.length < 6 ? 'Minimum 6 characters' : null,
                ),

                const SizedBox(height: 20),

                // SHOWS LOADING SPINNER OR CREATE ACCOUNT BUTTON
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Create Account'),
                      ),

                const SizedBox(height: 20),

                // NAVIGATION LINK TO LOGIN SCREEN
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}