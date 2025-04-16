// IMPORTS FLUTTER MATERIAL DESIGN PACKAGE
import 'package:flutter/material.dart';

// DEFINES A CUSTOM BOTTOM NAVIGATION BAR WIDGET
class AppNavBar extends StatelessWidget {
  // CURRENTLY SELECTED NAVIGATION INDEX
  final int currentIndex;

  // HANDLER FUNCTION TO SWITCH BETWEEN TABS
  final void Function(int) onTap;

  // CONSTRUCTOR TO INITIALIZE CURRENT TAB AND TAP HANDLER
  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,             // HIGHLIGHTS THE CURRENTLY SELECTED ITEM
      onTap: onTap,                           // INVOKES TAB SWITCH CALLBACK
      type: BottomNavigationBarType.fixed,    // KEEPS ALL ITEMS VISIBLE
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist),
          label: 'Current',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}