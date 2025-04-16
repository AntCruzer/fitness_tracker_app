// IMPORTS SQLITE PACKAGE FOR DATABASE OPERATIONS
import 'package:sqflite/sqflite.dart';

// IMPORTS PATH PACKAGE FOR FILE PATH CONSTRUCTION
import 'package:path/path.dart';

// IMPORTS THE USER MODEL
import '../models/user.dart';

// DEFINES THE DATABASE SERVICE CLASS FOR USER MANAGEMENT
class DBService {
  // HOLDS THE SQLITE DATABASE INSTANCE
  static Database? _db;

  // ASYNC GETTER FOR THE DATABASE INSTANCE
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // INITIALIZES THE SQLITE DATABASE AND CREATES THE USER TABLE IF NEEDED
  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // CREATES THE USERS TABLE WITH ID, USERNAME, EMAIL, AND PASSWORD
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // INSERTS A NEW USER RECORD INTO THE USERS TABLE
  Future<int> insertUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  // RETRIEVES A USER BY EMAIL FROM THE DATABASE
  Future<User?> getUserByEmail(String email) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  // DELETES A USER RECORD BASED ON THE GIVEN EMAIL
  Future<int> deleteUserByEmail(String email) async {
    final dbClient = await db;
    return await dbClient.delete(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}