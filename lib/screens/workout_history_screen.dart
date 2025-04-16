// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../models/workout_session.dart';
// import '../services/workout_db_service.dart';
// import '../providers/workout_provider.dart';

// class WorkoutHistoryScreen extends StatefulWidget {
//   const WorkoutHistoryScreen({super.key});

//   @override
//   State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
// }

// class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
//   List<WorkoutSession> _sessions = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSessions();
//   }

//   Future<void> _loadSessions() async {
//     final email = Hive.box('authBox').get('loggedInEmail') ?? '';
//     final sessions = await WorkoutDBService().getSessionsForUser(email);
//     if (!mounted) return;
//     setState(() => _sessions = sessions);
//   }

//   Future<void> _deleteSession(BuildContext context, int id) async {
//     final messenger = ScaffoldMessenger.of(context);
//     final provider = Provider.of<WorkoutProvider>(context, listen: false);

//     await WorkoutDBService().deleteSession(id);
//     await provider.loadWorkoutHistory();
//     await _loadSessions();

//     if (!mounted) return;
//     messenger.showSnackBar(const SnackBar(content: Text("Workout deleted")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Workout History')),
//       body: _sessions.isEmpty
//           ? const Center(child: Text('No workout history yet.'))
//           : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: _sessions.length,
//               itemBuilder: (context, index) {
//                 final session = _sessions[index];
//                 final done = session.completed.where((e) => e).length;
//                 final total = session.exercises.length;
//                 final percent = total == 0 ? 0.0 : done / total;
//                 final formatted = DateFormat('MMM d, y • h:mm a').format(session.timestamp);

//                 return Dismissible(
//                   key: Key(session.id.toString()),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   onDismissed: (_) => _deleteSession(context, session.id!),
//                   child: Card(
//                     elevation: 2,
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         session.type,
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       subtitle: Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '$done of $total completed • $formatted',
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                             const SizedBox(height: 8),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: LinearProgressIndicator(
//                                 value: percent,
//                                 minHeight: 8,
//                                 backgroundColor: Colors.grey[300],
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }



// IMPORTS FLUTTER MATERIAL PACKAGE FOR UI COMPONENTS
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR ACCESSING STORED USER SESSION
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS INTL FOR FORMATTING TIMESTAMPS
import 'package:intl/intl.dart';

// IMPORTS PROVIDER FOR STATE MANAGEMENT
import 'package:provider/provider.dart';

// IMPORTS THE WORKOUT SESSION MODEL
import '../models/workout_session.dart';

// IMPORTS WORKOUT DATABASE SERVICE FOR PERSISTENCE
import '../services/workout_db_service.dart';

// IMPORTS WORKOUT PROVIDER FOR APP STATE
import '../providers/workout_provider.dart';

// DEFINES A STATEFUL WIDGET FOR THE WORKOUT HISTORY SCREEN
class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

// DEFINES THE STATE FOR THE WORKOUT HISTORY SCREEN
class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  // LOCAL LIST TO HOLD LOADED WORKOUT SESSIONS
  List<WorkoutSession> _sessions = [];

  // INITIALIZATION FUNCTION - LOADS SESSIONS WHEN SCREEN IS FIRST BUILT
  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  // LOADS ALL WORKOUT SESSIONS FOR THE LOGGED-IN USER FROM THE DATABASE
  Future<void> _loadSessions() async {
    final email = Hive.box('authBox').get('loggedInEmail') ?? '';
    final sessions = await WorkoutDBService().getSessionsForUser(email);
    if (!mounted) return;
    setState(() => _sessions = sessions);
  }

  // HANDLES DELETION OF A SESSION FROM THE LIST AND DATABASE
  Future<void> _deleteSession(BuildContext context, int id) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<WorkoutProvider>(context, listen: false);

    // DELETES SESSION FROM DATABASE
    await WorkoutDBService().deleteSession(id);

    // REFRESHES PROVIDER AND SCREEN STATE
    await provider.loadWorkoutHistory();
    await _loadSessions();

    if (!mounted) return;

    // DISPLAYS FEEDBACK MESSAGE
    messenger.showSnackBar(const SnackBar(content: Text("Workout deleted")));
  }

  // BUILDS THE WORKOUT HISTORY SCREEN UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),

      // IF NO SESSIONS, DISPLAY A PLACEHOLDER MESSAGE
      body: _sessions.isEmpty
          ? const Center(child: Text('No workout history yet.'))

          // ELSE DISPLAY LIST OF PAST WORKOUT SESSIONS
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                final done = session.completed.where((e) => e).length;
                final total = session.exercises.length;
                final percent = total == 0 ? 0.0 : done / total;
                final formatted = DateFormat('MMM d, y • h:mm a').format(session.timestamp);

                return Dismissible(
                  key: Key(session.id.toString()),
                  direction: DismissDirection.endToStart,

                  // RED DELETE BACKGROUND ON SWIPE
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  // HANDLE DELETE WHEN DISMISSED
                  onDismissed: (_) => _deleteSession(context, session.id!),

                  // DISPLAY CARD FOR EACH SESSION
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        session.type,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // DISPLAYS COMPLETION SUMMARY AND TIMESTAMP
                            Text(
                              '$done of $total completed • $formatted',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),

                            // DISPLAYS PROGRESS BAR FOR SESSION
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor: Colors.grey[300],
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
