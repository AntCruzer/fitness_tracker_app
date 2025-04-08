
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout_session.dart';

class WorkoutDBService {
  static final WorkoutDBService _instance = WorkoutDBService._internal();
  factory WorkoutDBService() => _instance;
  WorkoutDBService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'workouts.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workout_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userEmail TEXT NOT NULL,
            type TEXT NOT NULL,
            exercises TEXT NOT NULL,
            completed TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertSession(WorkoutSession session) async {
    final db = await database;
    return db.insert('workout_sessions', session.toMap());
  }

  Future<int> updateSession(WorkoutSession session) async {
    final db = await database;
    return db.update(
      'workout_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<List<WorkoutSession>> getSessionsForUser(String email) async {
    final db = await database;
    final maps = await db.query(
      'workout_sessions',
      where: 'userEmail = ?',
      whereArgs: [email],
      orderBy: 'timestamp DESC',
    );
    return maps.map((e) => WorkoutSession.fromMap(e)).toList();
  }

  Future<WorkoutSession?> getLatestSessionForUser(String email) async {
    final db = await database;
    final maps = await db.query(
      'workout_sessions',
      where: 'userEmail = ?',
      whereArgs: [email],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return WorkoutSession.fromMap(maps.first);
  }

  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete('workout_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllSessionsForUser(String email) async {
    final db = await database;
    await db.delete('workout_sessions', where: 'userEmail = ?', whereArgs: [email]);
  }
}
