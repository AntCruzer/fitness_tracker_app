
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import '../models/workout_session.dart';

// class WorkoutDBService {
//   static final WorkoutDBService _instance = WorkoutDBService._internal();
//   factory WorkoutDBService() => _instance;
//   WorkoutDBService._internal();

//   static Database? _db;

//   Future<Database> get database async {
//     if (_db != null) return _db!;
//     _db = await _initDB();
//     return _db!;
//   }

//   Future<Database> _initDB() async {
//     final path = join(await getDatabasesPath(), 'workouts.db');
//     return openDatabase(
//       path,
//       version: 2,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE workout_sessions (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             userEmail TEXT NOT NULL,
//             type TEXT NOT NULL,
//             exercises TEXT NOT NULL,
//             completed TEXT NOT NULL,
//             timestamp TEXT NOT NULL
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertSession(WorkoutSession session) async {
//     final db = await database;
//     return db.insert('workout_sessions', session.toMap());
//   }

//   Future<int> updateSession(WorkoutSession session) async {
//     final db = await database;
//     return db.update(
//       'workout_sessions',
//       session.toMap(),
//       where: 'id = ?',
//       whereArgs: [session.id],
//     );
//   }

//   Future<List<WorkoutSession>> getSessionsForUser(String email) async {
//     final db = await database;
//     final maps = await db.query(
//       'workout_sessions',
//       where: 'userEmail = ?',
//       whereArgs: [email],
//       orderBy: 'timestamp DESC',
//     );
//     return maps.map((e) => WorkoutSession.fromMap(e)).toList();
//   }

//   Future<WorkoutSession?> getLatestSessionForUser(String email) async {
//     final db = await database;
//     final maps = await db.query(
//       'workout_sessions',
//       where: 'userEmail = ?',
//       whereArgs: [email],
//       orderBy: 'timestamp DESC',
//       limit: 1,
//     );
//     if (maps.isEmpty) return null;
//     return WorkoutSession.fromMap(maps.first);
//   }

//   // ✅ FIXED: ADDED BACK THE DELETE METHOD
//   Future<void> deleteSession(int id) async {
//     final db = await database;
//     await db.delete('workout_sessions', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteAllSessionsForUser(String email) async {
//     final db = await database;
//     await db.delete('workout_sessions', where: 'userEmail = ?', whereArgs: [email]);
//   }
// }



// IMPORTS SQLITE PACKAGE FOR DATABASE OPERATIONS
import 'package:sqflite/sqflite.dart';

// IMPORTS PATH PACKAGE FOR BUILDING FILE PATHS
import 'package:path/path.dart';

// IMPORTS THE WORKOUT SESSION MODEL
import '../models/workout_session.dart';

// DEFINES A DATABASE SERVICE CLASS FOR WORKOUT SESSIONS
class WorkoutDBService {
  
  // SINGLETON INSTANCE OF THIS SERVICE
  static final WorkoutDBService _instance = WorkoutDBService._internal();

  // FACTORY CONSTRUCTOR TO RETURN THE SAME INSTANCE
  factory WorkoutDBService() => _instance;

  // PRIVATE CONSTRUCTOR
  WorkoutDBService._internal();

  // HOLDS THE DATABASE INSTANCE
  static Database? _db;

  // ASYNC GETTER THAT INITIALIZES THE DATABASE IF NOT ALREADY OPEN
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // INITIALIZES THE WORKOUT DATABASE AND CREATES TABLE IF NEEDED
  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'workouts.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        // CREATES THE workout_sessions TABLE
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

  // INSERTS A NEW WORKOUT SESSION INTO THE DATABASE
  Future<int> insertSession(WorkoutSession session) async {
    final db = await database;
    return db.insert('workout_sessions', session.toMap());
  }

  // UPDATES AN EXISTING WORKOUT SESSION BASED ON ITS ID
  Future<int> updateSession(WorkoutSession session) async {
    final db = await database;
    return db.update(
      'workout_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  // FETCHES ALL WORKOUT SESSIONS FOR A SPECIFIC USER (MOST RECENT FIRST)
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

  // FETCHES ONLY THE MOST RECENT SESSION FOR A USER
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

  // DELETES A SINGLE WORKOUT SESSION BY ID
  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete('workout_sessions', where: 'id = ?', whereArgs: [id]);
  }

  // DELETES ALL WORKOUT SESSIONS ASSOCIATED WITH A SPECIFIC USER
  Future<void> deleteAllSessionsForUser(String email) async {
    final db = await database;
    await db.delete('workout_sessions', where: 'userEmail = ?', whereArgs: [email]);
  }
}
