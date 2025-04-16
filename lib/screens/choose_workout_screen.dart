// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/workout_provider.dart';
// import '../widgets/tab_controller_provider.dart';

// class ChooseWorkoutScreen extends StatefulWidget {
//   const ChooseWorkoutScreen({super.key});

//   @override
//   State<ChooseWorkoutScreen> createState() => _ChooseWorkoutScreenState();
// }

// class _ChooseWorkoutScreenState extends State<ChooseWorkoutScreen> {
//   bool _loading = false;

//   final Map<String, List<String>> workouts = const {
//     "Upper Body": ["Push-ups", "Pull-ups", "Overhead Shoulder Press", "Bent-over Rows", "Bicep Curls"],
//     "Lower Body": ["Squats", "Lunges", "Calf Raises", "Deadlifts", "Hip Thrusts"],
//     "Core": ["Sit-ups", "Planks", "Leg Raises", "Bicycle Crunches", "Russian Twists"],
//     "Full Body": ["Burpees", "Jump Squats", "Mountain Climbers", "Kettlebell Swings", "Jumping Jacks"],
//     "Cardio": ["Running", "Jump Rope", "Cycling", "Jump Squats", "Burpees"]
//   };

//   void _goToWorkoutTab() {
//     TabControllerProvider.of(context).setTab(2);
//   }

//   Future<void> _onSelectWorkout(BuildContext context, String type) async {
//     setState(() => _loading = true);
//     final provider = context.read<WorkoutProvider>();
//     await provider.selectWorkout(type, workouts[type]!);
//     if (!mounted || provider.currentWorkout == null) return;
//     setState(() => _loading = false);
//     _goToWorkoutTab();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text("Select Workout Type"),
//       ),
//       body: Stack(
//         children: [
//           ListView(
//             children: workouts.keys.map((workoutName) {
//               return Card(
//                 elevation: 2,
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 child: ListTile(
//                   title: Text(workoutName),
//                   trailing: const Icon(Icons.arrow_forward_ios),
//                   onTap: () => _onSelectWorkout(context, workoutName),
//                 ),
//               );
//             }).toList(),
//           ),
//           if (_loading)
//             Container(
//               color: const Color.fromRGBO(0, 0, 0, 0.2),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }
// }



// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS WORKOUT PROVIDER TO ACCESS STATE
import '../providers/workout_provider.dart';

// IMPORTS TAB CONTROLLER PROVIDER FOR TAB NAVIGATION
import '../widgets/tab_controller_provider.dart';

// DEFINES CHOOSE WORKOUT SCREEN AS A STATEFUL WIDGET
class ChooseWorkoutScreen extends StatefulWidget {
  const ChooseWorkoutScreen({super.key});

  @override
  State<ChooseWorkoutScreen> createState() => _ChooseWorkoutScreenState();
}

// DEFINES STATE FOR THE WORKOUT SELECTION SCREEN
class _ChooseWorkoutScreenState extends State<ChooseWorkoutScreen> {
  // TRACKS WHETHER A WORKOUT IS CURRENTLY LOADING
  bool _loading = false;

  // MAP OF WORKOUT TYPES TO THEIR EXERCISE LISTS
  final Map<String, List<String>> workouts = const {
    "Upper Body": ["Push-ups", "Pull-ups", "Overhead Shoulder Press", "Bent-over Rows", "Bicep Curls"],
    "Lower Body": ["Squats", "Lunges", "Calf Raises", "Deadlifts", "Hip Thrusts"],
    "Core": ["Sit-ups", "Planks", "Leg Raises", "Bicycle Crunches", "Russian Twists"],
    "Full Body": ["Burpees", "Jump Squats", "Mountain Climbers", "Kettlebell Swings", "Jumping Jacks"],
    "Cardio": ["Running", "Jump Rope", "Cycling", "Jump Squats", "Burpees"]
  };

  // NAVIGATES TO THE CURRENT WORKOUT TAB (TAB 2)
  void _goToWorkoutTab() {
    TabControllerProvider.of(context).setTab(2);
  }

  // HANDLES WORKOUT SELECTION
  Future<void> _onSelectWorkout(BuildContext context, String type) async {
    setState(() => _loading = true); // SHOW LOADING SPINNER

    final provider = context.read<WorkoutProvider>();

    // SELECT WORKOUT AND LOAD EXERCISES INTO PROVIDER STATE
    await provider.selectWorkout(type, workouts[type]!);

    // IF UNMOUNTED OR DATA IS NULL, DO NOTHING
    if (!mounted || provider.currentWorkout == null) return;

    setState(() => _loading = false); // HIDE LOADING SPINNER

    _goToWorkoutTab(); // NAVIGATE TO CURRENT WORKOUT SCREEN
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // DISABLE BACK BUTTON
        title: const Text("Select Workout Type"),
      ),
      body: Stack(
        children: [
          // DISPLAY A LIST OF WORKOUT TYPES
          ListView(
            children: workouts.keys.map((workoutName) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                // TAP TO SELECT A WORKOUT TYPE
                child: ListTile(
                  title: Text(workoutName),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _onSelectWorkout(context, workoutName),
                ),
              );
            }).toList(),
          ),

          // SHOW OVERLAY SPINNER IF LOADING
          if (_loading)
            Container(
              color: const Color.fromRGBO(0, 0, 0, 0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}