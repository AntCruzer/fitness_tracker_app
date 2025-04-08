import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/workout_session.dart';
import '../services/workout_db_service.dart';
import '../providers/workout_provider.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<WorkoutSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final email = Hive.box('authBox').get('loggedInEmail') ?? '';
    final sessions = await WorkoutDBService().getSessionsForUser(email);
    if (!mounted) return;
    setState(() => _sessions = sessions);
  }

  Future<void> _deleteSession(BuildContext context, int id) async {
    final messenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<WorkoutProvider>(context, listen: false);

    await WorkoutDBService().deleteSession(id);
    await provider.loadWorkoutHistory();
    await _loadSessions();

    if (!mounted) return;
    messenger.showSnackBar(const SnackBar(content: Text("Workout deleted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: _sessions.isEmpty
          ? const Center(child: Text('No workout history yet.'))
          : ListView.builder(
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
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteSession(context, session.id!),
                  child: ListTile(
                    title: Text(session.type),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$done of $total done • $formatted'),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: percent),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
