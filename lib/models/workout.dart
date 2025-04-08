// WORKOUT CLASS DEFINITION
class Workout {

  // ATTRIBUTES
  final String name;                                              // WORKOUT TYPE
  final List<String> exercises;                                   // LIST OF EXERCISES ASSOCIATED WITH WORKOUT TYPE
  List<bool> completed;                                           // LIST OF COMPLETION STATUSES OF EACH EXERCISE OF THE CHOSEN WORKOUT

  // CONSTRUCTOR
  Workout({required this.name, required this.exercises})
      : completed = List<bool>.filled(exercises.length, false);   // SET EXERCISE COMPLETIONS TO FALSE

  // CALCULATE COMPLETION PERCENTAGE
  double getCompletionPercentage() {
    int completedExercises = completed.where((e) => e).length;
    return (completedExercises / exercises.length) * 100;
  }
}