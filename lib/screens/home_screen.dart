// // lib/screens/home_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import '../providers/workout_provider.dart';
// import '../widgets/tab_controller_provider.dart';
// import 'settings_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<WorkoutProvider>();
//     final workout = provider.currentWorkout;
//     final typeCounts = provider.getWorkoutTypeCounts();
//     final email = Hive.box('authBox').get('loggedInEmail') ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             tooltip: "Settings",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SettingsScreen(userEmail: email),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           if (workout != null) ...[
//             Text(
//               "Current: ${workout.type}",
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Completion: ${provider.getCompletionPercentage().toStringAsFixed(1)}%",
//               style: const TextStyle(fontSize: 18),
//             ),
//           ] else ...[
//             const Text(
//               "No active workout. Start one to begin tracking!",
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               TabControllerProvider.of(context).setTab(2);
//             },
//             child: const Text("Begin Workout"),
//           ),
//           const SizedBox(height: 30),
//           const Text("📊 Workout Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           if (typeCounts.isEmpty)
//             const Text("No workout sessions yet.")
//           else
//             ...typeCounts.entries.map((entry) {
//               return ListTile(
//                 title: Text(entry.key),
//                 trailing: Text("${entry.value}x"),
//               );
//             }),
//         ],
//       ),
//     );
//   }
// }




// // lib/screens/home_screen.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:fl_chart/fl_chart.dart';

// import '../providers/workout_provider.dart';
// import '../widgets/tab_controller_provider.dart';
// import 'settings_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<WorkoutProvider>();
//     final workout = provider.currentWorkout;
//     final typeCounts = provider.getWorkoutTypeCounts(completedOnly: true); // ✅ completed only
//     final email = Hive.box('authBox').get('loggedInEmail') ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             tooltip: "Settings",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SettingsScreen(userEmail: email),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           if (workout != null) ...[
//             Text(
//               "Current: ${workout.type}",
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Completion: ${provider.getCompletionPercentage().toStringAsFixed(1)}%",
//               style: const TextStyle(fontSize: 18),
//             ),
//           ] else ...[
//             const Text(
//               "No active workout. Start one to begin tracking!",
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               TabControllerProvider.of(context).setTab(2); // To workout screen
//             },
//             child: const Text("Begin Workout"),
//           ),
//           const SizedBox(height: 30),
//           const Text("📊 Completed Workout Breakdown",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           if (typeCounts.isEmpty)
//             const Text("No completed workouts yet.")
//           else
//             AspectRatio(
//               aspectRatio: 1.3,
//               child: PieChart(
//                 PieChartData(
//                   sections: typeCounts.entries
//                       .map(
//                         (entry) => PieChartSectionData(
//                           title: entry.key,
//                           value: entry.value.toDouble(),
//                           radius: 60,
//                           titleStyle: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                       .toList(),
//                   sectionsSpace: 4,
//                   centerSpaceRadius: 30,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/workout_provider.dart';
import '../widgets/tab_controller_provider.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final workout = provider.currentWorkout;
    final typeCounts = provider.getWorkoutTypeCounts(completedOnly: true);
    final email = Hive.box('authBox').get('loggedInEmail') ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(userEmail: email),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (workout != null) ...[
            Text("Current: ${workout.type}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Completion: ${provider.getCompletionPercentage().toStringAsFixed(1)}%", style: const TextStyle(fontSize: 18)),
          ] else ...[
            const Text("No active workout. Start one to begin tracking!", style: TextStyle(fontSize: 18)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              TabControllerProvider.of(context).setTab(2);
            },
            child: const Text("Begin Workout"),
          ),
          const SizedBox(height: 32),
          const Text("📊 Completed Workouts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (typeCounts.isEmpty)
            const Text("No completed workout data yet.")
          else
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: typeCounts.entries.map((entry) {
                    return PieChartSectionData(
                      title: entry.key,
                      value: entry.value.toDouble(),
                      radius: 60,
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
