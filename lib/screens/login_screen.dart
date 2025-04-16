// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR LOCAL SESSION STORAGE
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS USER DATABASE SERVICE
import '../services/db_service.dart';

// IMPORTS THEME AND WORKOUT PROVIDERS
import '../providers/theme_provider.dart';
import '../providers/workout_provider.dart';

// DEFINES LOGIN SCREEN AS A STATEFUL WIDGET
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// DEFINES STATE CLASS FOR LOGIN SCREEN
class _LoginScreenState extends State<LoginScreen> {
  // FORM KEY TO VALIDATE INPUT FIELDS
  final _formKey = GlobalKey<FormState>();

  // TEXT CONTROLLERS FOR EMAIL AND PASSWORD
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // TRACKS IF APP IS CURRENTLY LOGGING IN
  bool _loading = false;

  // HANDLES LOGIN ACTION
  Future<void> _submit() async {
    // VALIDATES FORM INPUTS
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // ATTEMPTS TO FETCH USER BY EMAIL
    final user = await DBService().getUserByEmail(email);

    if (!mounted) return;

    // VALIDATES USER AND PASSWORD MATCH
    if (user == null) {
      _showError('User not found'); // SHOW ERROR IF USER NOT FOUND
    } else if (user.password != password) {
      _showError('Incorrect password'); // SHOW ERROR IF PASSWORD IS WRONG
    } else {
      // STORE SESSION EMAIL IN HIVE
      Hive.box('authBox').put('loggedInEmail', user.email);

      // LOAD USER-SPECIFIC STATE (THEME + WORKOUT)
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

      themeProvider.reloadThemeForNewUser();
      await workoutProvider.loadLatestWorkout();
      await workoutProvider.loadWorkoutHistory(); // LOADS CHART DATA

      if (!mounted) return;

      // RETURN TO ROOT OF APP (MAIN SHELL)
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  // DISPLAYS ERROR MESSAGES IN SNACKBAR
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // CLEANS UP CONTROLLERS ON DISPOSE
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // BUILDS THE LOGIN SCREEN UI
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // BLOCKS BACK BUTTON TO PREVENT EXIT BEFORE LOGIN
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // REMOVES DEFAULT BACK ICON
          title: const Text('Log In'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey, // WRAPS FORM WITH VALIDATION
            child: Column(
              children: [
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

                // SHOWS LOADING INDICATOR OR LOGIN BUTTON
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Log In'),
                      ),

                const SizedBox(height: 20),

                // NAVIGATION TO SIGNUP SCREEN
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign Up",
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