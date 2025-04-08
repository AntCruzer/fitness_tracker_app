workout.dart
- Defines the Workout data model, including attributes and 
methods for managing exercises and tracking completion.

workout_provider.dart
- State manager that handles workout selection, exercise 
completion, and state updates for UI changes.

choose_workout_screen.dart
- Workout selection screen, allows users to select a 
workout type, which updates the current workout state.

current_workout_screen.dart
- Displays a list of exercises from the selected workout, 
allowing users to toggle completion status.

home_screen.dart
- Dashboard that dynamically displays workout completion 
percentage and prompts users to begin a workout.

nav_bar.dart
- Defines the bottom navigation bar, allowing users to 
switch between screens.

main.dart
- Entry point of the app, sets up the ChangeNotifierProvider 
for state management and initializes the navigation structure.

pubspec.yaml
- Project configuration file that defines dependencies, 
environment settings, and metadata such as the app’s name, 
version, and asset management.