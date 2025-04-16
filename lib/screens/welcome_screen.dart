// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// DEFINES THE WELCOME SCREEN AS A STATELESS WIDGET
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,                                                  // PREVENTS BACK NAVIGATION FROM THIS SCREEN

      child: Scaffold(
        backgroundColor: Colors.white,                              // SETS BACKGROUND COLOR TO WHITE

        // ADDS HORIZONTAL PADDING AND CENTERS THE CONTENT
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,                         // SHRINKS COLUMN TO FIT CHILDREN

              children: [
                const Text(
                  'Welcome to...',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // LOGO IMAGE
                Image.asset(
                  'assets/images/appLogo.png',
                  height: 300,
                ),
                const SizedBox(height: 5),

                // BUTTON TO NAVIGATE TO SIGNUP SCREEN
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text('Sign Up'),
                ),

                const SizedBox(height: 20), // VERTICAL SPACING

                // BUTTON TO NAVIGATE TO LOGIN SCREEN
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
