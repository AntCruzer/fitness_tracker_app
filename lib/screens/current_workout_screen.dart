// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS PROVIDER PACKAGE FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS WORKOUT PROVIDER TO ACCESS CURRENT WORKOUT DATA
import '../providers/workout_provider.dart';

// IMPORTS CUSTOM TAB CONTROLLER TO NAVIGATE TABS
import '../widgets/tab_controller_provider.dart';

// DEFINES CURRENT WORKOUT SCREEN AS A STATELESS WIDGET
class CurrentWorkoutScreen extends StatelessWidget {
  const CurrentWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ACCESS WORKOUT PROVIDER FROM CONTEXT
    final provider = context.watch<WorkoutProvider>();

    // GET CURRENT WORKOUT SESSION
    final workout = provider.currentWorkout;

    // IF NO WORKOUT IS ACTIVE, DISPLAY MESSAGE TO PROMPT USER
    if (workout == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Current Workout"),
        ),
        body: const Center(
          child: Text("Choose a workout to see exercises!"),
        ),
      );
    }

    // CHECK IF ALL EXERCISES ARE COMPLETED
    final allDone = workout.completed.every((e) => e);

    // CALCULATE COMPLETION PERCENTAGE (NORMALIZED TO 0–1 FOR PROGRESS BAR)
    final completion = provider.getCompletionPercentage() / 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.type), // DISPLAYS WORKOUT TYPE AS TITLE
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // SHOWS LINEAR PROGRESS BAR FOR CURRENT WORKOUT PROGRESS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LinearProgressIndicator(
              value: completion,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
            ),
          ),

          // LIST OF EXERCISES WITH CHECKBOXES FOR COMPLETION TRACKING
          Expanded(
            child: ListView.builder(
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: CheckboxListTile(
                    title: Text(workout.exercises[index]),
                    value: workout.completed[index],
                    onChanged: (_) {
                      // TOGGLES COMPLETION STATE OF EXERCISE
                      context.read<WorkoutProvider>().toggleExercise(index);
                    },
                  ),
                );
              },
            ),
          ),

          // IF ALL EXERCISES ARE COMPLETED, SHOW "DONE WORKOUT" BUTTON
          if (allDone)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Done Workout"),
                onPressed: () async {
                  // MARKS WORKOUT AS COMPLETE AND SHOWS FEEDBACK
                  await provider.completeCurrentWorkout();
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Workout completed!")),
                  );

                  // NAVIGATES BACK TO DASHBOARD TAB
                  TabControllerProvider.of(context).setTab(0);
                },
              ),
            ),
        ],
      ),
    );
  }
}