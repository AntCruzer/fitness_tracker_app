// IMPORTS MATERIAL DESIGN WIDGETS FOR UI
import 'package:flutter/material.dart';

// IMPORTS HIVE FOR LOCAL STORAGE ACCESS
import 'package:hive_flutter/hive_flutter.dart';

// IMPORTS WORKOUT SESSION MODEL
import '../models/workout_session.dart';

// IMPORTS DATABASE SERVICE FOR WORKOUT PERSISTENCE
import '../services/workout_db_service.dart';


// DEFINES A PROVIDER CLASS FOR WORKOUT-RELATED STATE
class WorkoutProvider extends ChangeNotifier {

  // HOLDS THE CURRENT ACTIVE WORKOUT SESSION
  WorkoutSession? _currentSession;

  // STORES THE LIST OF HISTORICAL WORKOUT SESSIONS
  List<WorkoutSession> _workoutHistory = [];

  // EXPOSES THE CURRENT WORKOUT SESSION
  WorkoutSession? get currentWorkout => _currentSession;

  // EXPOSES THE STORED WORKOUT HISTORY
  List<WorkoutSession> get workoutHistory => _workoutHistory;

  // GETS THE LOGGED-IN USER'S EMAIL FROM HIVE
  String get _userEmail => Hive.box('authBox').get('loggedInEmail') ?? '';

  // LOADS THE MOST RECENT WORKOUT SESSION FROM THE DATABASE
  Future<void> loadLatestWorkout() async {
    if (_userEmail.isEmpty) return;
    final session = await WorkoutDBService().getLatestSessionForUser(_userEmail);
    debugPrint("📦 Loaded workout for $_userEmail => ${session?.type}");
    _currentSession = session;
    notifyListeners(); // NOTIFIES UI TO REFRESH
  }

  // CREATES A NEW WORKOUT SESSION AND PERSISTS IT
  Future<void> selectWorkout(String name, List<String> exercises) async {
    final session = WorkoutSession(
      userEmail: _userEmail,
      type: name,
      exercises: exercises,
      completed: List<bool>.filled(exercises.length, false),
      timestamp: DateTime.now(),
    );
    final id = await WorkoutDBService().insertSession(session);   // STORES SESSION
    _currentSession = session.copyWith(id: id);                   // SETS CURRENT SESSION WITH ID
    await loadWorkoutHistory();                                   // LOADS UPDATED HISTORY
    notifyListeners();                                            // TRIGGERS UI UPDATE
  }

  // TOGGLES AN EXERCISE'S COMPLETION STATUS
  Future<void> toggleExercise(int index) async {
    if (_currentSession != null &&
        index >= 0 &&
        index < _currentSession!.completed.length) {
      _currentSession!.completed[index] = !_currentSession!.completed[index]; // TOGGLES VALUE
      await WorkoutDBService().updateSession(_currentSession!);               // SAVES CHANGES
      notifyListeners();                                                      // NOTIFIES UI
    }
  }

  // RETURNS THE COMPLETION PERCENTAGE OF THE CURRENT WORKOUT
  double getCompletionPercentage() {
    if (_currentSession == null) return 0.0;
    final total = _currentSession!.completed.length;
    final done = _currentSession!.completed.where((e) => e).length;
    return total == 0 ? 0.0 : (done / total) * 100;
  }

  // FETCHES ALL SAVED WORKOUT SESSIONS FOR THE USER
  Future<void> loadWorkoutHistory() async {
    if (_userEmail.isEmpty) return;
    _workoutHistory = await WorkoutDBService().getSessionsForUser(_userEmail);
    notifyListeners(); // TRIGGERS REFRESH
  }

  // RETURNS A MAP OF WORKOUT TYPE TO COUNT, FILTERED IF REQUESTED
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

  // CLEARS THE CURRENT SESSION AND HISTORY STATE
  void clearSession() {
    _currentSession = null;
    _workoutHistory.clear();
    notifyListeners();
  }

  // MARKS CURRENT WORKOUT COMPLETE IF ALL EXERCISES ARE DONE
  // Future<void> completeCurrentWorkout() async {
  //   if (_currentSession == null) return;
  //   if (_currentSession!.completed.every((e) => e)) {
  //     await WorkoutDBService().updateSession(_currentSession!);                 // SAVES FINAL STATE
  //     await loadWorkoutHistory();                                               // RELOADS HISTORY
  //     notifyListeners();                                                        // NOTIFIES UI
  //   }
  // }
  Future<void> completeCurrentWorkout() async {
  if (_currentSession == null) return;
  if (_currentSession!.completed.every((e) => e)) {
    await WorkoutDBService().updateSession(_currentSession!);
    _currentSession = null;
    await loadWorkoutHistory();
    notifyListeners();
  }
}

}