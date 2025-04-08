

class WorkoutSession {
  final int? id;
  final String userEmail;
  final String type;
  final List<String> exercises;
  final List<bool> completed;
  final DateTime timestamp;

  WorkoutSession({
    this.id,
    required this.userEmail,
    required this.type,
    required this.exercises,
    required this.completed,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'type': type,
      'exercises': exercises.join('|'),
      'completed': completed.map((e) => e ? '1' : '0').join(''),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'],
      userEmail: map['userEmail'],
      type: map['type'],
      exercises: map['exercises'].toString().split('|'),
      completed: map['completed'].toString().split('').map((e) => e == '1').toList(),
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

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
