import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'current_workout_screen.dart'; // ✅ Use screen directly

class ChooseWorkoutScreen extends StatelessWidget {
  const ChooseWorkoutScreen({super.key});

  final Map<String, List<String>> workouts = const {
    "Upper Body": ["Push-ups", "Pull-ups", "Overhead Shoulder Press", "Bent-over Rows", "Bicep Curls"],
    "Lower Body": ["Squats", "Lunges", "Calf Raises", "Deadlifts", "Hip Thrusts"],
    "Core": ["Sit-ups", "Planks", "Leg Raises", "Bicycle Crunches", "Russian Twists"],
    "Full Body": ["Burpees", "Jump Squats", "Mountain Climbers", "Kettlebell Swings", "Jumping Jacks"],
    "Cardio": ["Running", "Jump Rope", "Cycling", "Jump Squats", "Burpees"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Workout Type")),
      body: ListView(
        children: workouts.keys.map((workoutName) {
          return ListTile(
            title: Text(workoutName),
            onTap: () async {
              final provider = context.read<WorkoutProvider>();
              await provider.selectWorkout(workoutName, workouts[workoutName]!);

              if (!context.mounted || provider.currentWorkout == null) return;

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CurrentWorkoutScreen()),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
