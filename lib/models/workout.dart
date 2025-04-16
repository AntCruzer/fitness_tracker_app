// WORKOUT CLASS DEFINITION
class Workout {

  // WORKOUT TYPE NAME (E.G., "UPPER BODY", "CARDIO")
  final String name;

  // LIST OF EXERCISE NAMES ASSOCIATED WITH THIS WORKOUT
  final List<String> exercises;

  // LIST OF COMPLETION STATES FOR EACH EXERCISE (TRUE IF DONE)
  List<bool> completed;

  // CONSTRUCTOR THAT INITIALIZES NAME, EXERCISES, AND SETS ALL COMPLETIONS TO FALSE
  Workout({required this.name, required this.exercises})
      : completed = List<bool>.filled(exercises.length, false);

  // RETURNS COMPLETION PERCENTAGE OF THE WORKOUT BASED ON DONE EXERCISES
  double getCompletionPercentage() {
    int completedExercises = completed.where((e) => e).length;
    return (completedExercises / exercises.length) * 100;
  }
}