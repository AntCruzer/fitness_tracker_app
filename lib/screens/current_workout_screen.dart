// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../providers/workout_provider.dart';

// // class CurrentWorkoutScreen extends StatelessWidget {
// //   const CurrentWorkoutScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final provider = context.watch<WorkoutProvider>();
// //     final workout = provider.currentWorkout;

// //     if (workout == null) {
// //       return Scaffold(
// //         appBar: AppBar(title: const Text("Current Workout")),
// //         body: const Center(child: Text("Choose a workout to see exercises!")),
// //       );
// //     }

// //     return Scaffold(
// //       appBar: AppBar(title: Text(workout.type)),
// //       body: ListView.builder(
// //         itemCount: workout.exercises.length,
// //         itemBuilder: (context, index) {
// //           return CheckboxListTile(
// //             title: Text(workout.exercises[index]),
// //             value: workout.completed[index],
// //             onChanged: (_) {
// //               context.read<WorkoutProvider>().toggleExercise(index);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/workout_provider.dart';
// import '../widgets/tab_controller_provider.dart';

// class CurrentWorkoutScreen extends StatelessWidget {
//   const CurrentWorkoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<WorkoutProvider>();
//     final workout = provider.currentWorkout;

//     if (workout == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Current Workout")),
//         body: const Center(child: Text("Choose a workout to see exercises!")),
//       );
//     }

//     final allDone = workout.completed.every((e) => e);

//     return Scaffold(
//       appBar: AppBar(title: Text(workout.type)),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: workout.exercises.length,
//               itemBuilder: (context, index) {
//                 return CheckboxListTile(
//                   title: Text(workout.exercises[index]),
//                   value: workout.completed[index],
//                   onChanged: (_) {
//                     context.read<WorkoutProvider>().toggleExercise(index);
//                   },
//                 );
//               },
//             ),
//           ),
//           if (allDone)
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: ElevatedButton.icon(
//                 icon: const Icon(Icons.check),
//                 label: const Text("Done Workout"),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Workout completed!")),
//                   );
//                   TabControllerProvider.of(context).setTab(0); // back to Dashboard
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../widgets/tab_controller_provider.dart';

class CurrentWorkoutScreen extends StatelessWidget {
  const CurrentWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final workout = provider.currentWorkout;

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Current Workout")),
        body: const Center(child: Text("Choose a workout to see exercises!")),
      );
    }

    final allDone = workout.completed.every((e) => e);

    return Scaffold(
      appBar: AppBar(title: Text(workout.type)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(workout.exercises[index]),
                  value: workout.completed[index],
                  onChanged: (_) {
                    context.read<WorkoutProvider>().toggleExercise(index);
                  },
                );
              },
            ),
          ),
          if (allDone)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Done Workout"),
                // onPressed: () {
                //   final provider = context.read<WorkoutProvider>();
                //   provider.clearSession(); // ✅ clear it
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("Workout completed!")),
                //   );
                //   TabControllerProvider.of(context).setTab(0); // Dashboard
                // },
                // onPressed: () async {
                //   final provider = context.read<WorkoutProvider>();
                //   await provider.completeCurrentWorkout(); // ✅ persist + update history
                //   provider.clearSession(); // ✅ then clear from memory
                //   if (context.mounted) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text("Workout completed!")),
                //     );
                //     TabControllerProvider.of(context).setTab(0); // Dashboard
                //   }
                // }
                onPressed: () async {
                  final provider = context.read<WorkoutProvider>();
                  provider.clearSession(); // Clear current workout
                  await provider.loadWorkoutHistory(); // ✅ Refresh history for pie chart
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Workout completed!")),
                  );
                  TabControllerProvider.of(context).setTab(0); // Navigate home
                }


              ),
            ),
        ],
      ),
    );
  }
}
