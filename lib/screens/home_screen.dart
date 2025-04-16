// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS PROVIDER PACKAGE FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS FL_CHART PACKAGE FOR PIE CHART VISUALIZATION
import 'package:fl_chart/fl_chart.dart';

// IMPORTS WORKOUT PROVIDER FOR ACCESSING APP STATE
import '../providers/workout_provider.dart';

// IMPORTS CUSTOM TAB CONTROLLER FOR SCREEN NAVIGATION
import '../widgets/tab_controller_provider.dart';

// DEFINES THE HOME SCREEN AS A STATELESS WIDGET
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ACCESS WORKOUT PROVIDER FROM CONTEXT
    final provider = context.watch<WorkoutProvider>();

    // GET CURRENT WORKOUT SESSION IF ONE EXISTS
    final workout = provider.currentWorkout;

    // GET COMPLETED WORKOUT TYPE COUNTS FOR PIE CHART
    final typeCounts = provider.getWorkoutTypeCounts(completedOnly: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // HIDES BACK BUTTON
        title: const Text("Dashboard"),

        // SETTINGS ICON THAT NAVIGATES TO TAB 3 (SETTINGS)
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              TabControllerProvider.of(context).setTab(3);
            },
          ),
        ],
      ),

      // MAIN DASHBOARD CONTENT
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // SHOWS CURRENT WORKOUT CARD IF ACTIVE WORKOUT EXISTS
          if (workout != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Workout", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(workout.type, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text("Completion: ${provider.getCompletionPercentage().toStringAsFixed(1)}%"),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: provider.getCompletionPercentage() / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  
                  ],
                ),
              ),
            )
          else
            // MESSAGE IF NO ACTIVE WORKOUT IS FOUND
            const Text("No active workout. Start one to begin tracking!"),

          const SizedBox(height: 24),

          // BUTTON TO START A NEW WORKOUT - NAVIGATES TO TAB 1 (CHOOSE WORKOUT)
          ElevatedButton(
            onPressed: () {
              TabControllerProvider.of(context).setTab(1);
            },
            child: const Text("Begin a new workout"),
          ),

          const SizedBox(height: 32),

          // TITLE FOR COMPLETED WORKOUT CHART SECTION
          const Text("Completed Workouts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // IF NO DATA, DISPLAY EMPTY STATE
          if (typeCounts.isEmpty)
            const Text("No completed workout data yet.")
          else
            // RENDERS PIE CHART FOR WORKOUT TYPE COMPLETION
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: typeCounts.entries.map((entry) {
                      return PieChartSectionData(
                        title: "${entry.key} (${entry.value})", // LABEL WITH TYPE AND COUNT
                        value: entry.value.toDouble(),
                        radius: 60,
                        titleStyle: const TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}