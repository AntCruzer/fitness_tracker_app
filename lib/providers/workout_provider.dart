

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_session.dart';
import '../services/workout_db_service.dart';

class WorkoutProvider extends ChangeNotifier {
  WorkoutSession? _currentSession;
  List<WorkoutSession> _workoutHistory = [];

  WorkoutSession? get currentWorkout => _currentSession;
  List<WorkoutSession> get workoutHistory => _workoutHistory;

  String get _userEmail => Hive.box('authBox').get('loggedInEmail') ?? '';

  Future<void> loadLatestWorkout() async {
    if (_userEmail.isEmpty) return;
    final session = await WorkoutDBService().getLatestSessionForUser(_userEmail);
    debugPrint("📦 Loaded workout for $_userEmail => ${session?.type}");
    _currentSession = session;
    notifyListeners();
  }

  Future<void> selectWorkout(String name, List<String> exercises) async {
    final session = WorkoutSession(
      userEmail: _userEmail,
      type: name,
      exercises: exercises,
      completed: List<bool>.filled(exercises.length, false),
      timestamp: DateTime.now(),
    );
    final id = await WorkoutDBService().insertSession(session);
    _currentSession = session.copyWith(id: id);
    await loadWorkoutHistory(); 
    notifyListeners();
  }

  Future<void> toggleExercise(int index) async {
    if (_currentSession != null &&
        index >= 0 &&
        index < _currentSession!.completed.length) {
      _currentSession!.completed[index] = !_currentSession!.completed[index];
      await WorkoutDBService().updateSession(_currentSession!);
      notifyListeners();
    }
  }

  double getCompletionPercentage() {
    if (_currentSession == null) return 0.0;
    final total = _currentSession!.completed.length;
    final done = _currentSession!.completed.where((e) => e).length;
    return total == 0 ? 0.0 : (done / total) * 100;
  }

  Future<void> loadWorkoutHistory() async {
    if (_userEmail.isEmpty) return;
    _workoutHistory = await WorkoutDBService().getSessionsForUser(_userEmail);
    notifyListeners();
  }

  Map<String, int> getWorkoutTypeCounts({bool completedOnly = false}) {
    final filtered = completedOnly
        ? _workoutHistory.where((s) => s.completed.every((e) => e)).toList()
        : _workoutHistory;

    final Map<String, int> typeCounts = {};
    for (var session in filtered) {
      typeCounts[session.type] = (typeCounts[session.type] ?? 0) + 1;
    }
    return typeCounts;
  }

  void clearSession() {
    _currentSession = null;
    _workoutHistory.clear();
    notifyListeners();
  }

  Future<void> completeCurrentWorkout() async {
  if (_currentSession == null) return;
  if (_currentSession!.completed.every((e) => e)) {
    await WorkoutDBService().updateSession(_currentSession!);
    await loadWorkoutHistory(); 
    notifyListeners();
  }
}

}
