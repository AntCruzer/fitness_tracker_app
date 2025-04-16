// WORKOUT SESSION MODEL USED TO STORE WORKOUT STATE IN DATABASE

class WorkoutSession {
  
  // OPTIONAL DATABASE ID (PRIMARY KEY)
  final int? id;

  // ASSOCIATED USER'S EMAIL
  final String userEmail;

  // WORKOUT TYPE NAME (E.G., "CARDIO", "CORE")
  final String type;

  // LIST OF EXERCISE NAMES IN THIS WORKOUT
  final List<String> exercises;

  // LIST OF COMPLETION STATES FOR EACH EXERCISE (TRUE = DONE)
  final List<bool> completed;

  // TIMESTAMP WHEN THIS WORKOUT SESSION WAS STARTED
  final DateTime timestamp;

  // CONSTRUCTOR TO INITIALIZE ALL FIELDS
  WorkoutSession({
    this.id,
    required this.userEmail,
    required this.type,
    required this.exercises,
    required this.completed,
    required this.timestamp,
  });

  // CONVERTS WORKOUT SESSION TO A MAP FOR DATABASE STORAGE
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'type': type,
      'exercises': exercises.join('|'),                  // JOIN EXERCISES WITH PIPE CHARACTER
      'completed': completed.map((e) => e ? '1' : '0').join(''),  // STORE COMPLETION AS BINARY STRING
      'timestamp': timestamp.toIso8601String(),          // CONVERT TIMESTAMP TO ISO STRING
    };
  }

  // CREATES A WORKOUT SESSION INSTANCE FROM A MAP (DATABASE READ)
  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'],
      userEmail: map['userEmail'],
      type: map['type'],
      exercises: map['exercises'].toString().split('|'),               // SPLIT EXERCISES BACK TO LIST
      completed: map['completed'].toString().split('').map((e) => e == '1').toList(),  // DECODE BINARY STRING TO LIST OF BOOLS
      timestamp: DateTime.parse(map['timestamp']),                     // PARSE TIMESTAMP
    );
  }

  // CREATES A COPY OF THIS INSTANCE WITH OVERRIDDEN FIELDS
  WorkoutSession copyWith({
    int? id,
    String? userEmail,
    String? type,
    List<String>? exercises,
    List<bool>? completed,
    DateTime? timestamp,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userEmail: userEmail ?? this.userEmail,
      type: type ?? this.type,
      exercises: exercises ?? this.exercises,
      completed: completed ?? this.completed,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}