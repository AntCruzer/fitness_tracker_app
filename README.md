**`workout.dart`**  
- Defines the `Workout` data model with exercise lists and logic to calculate completion percentage.

**`workout_session.dart`**  
- Data model for logged workout sessions, including type, exercises, completion state, and timestamp.

**`user.dart`**  
- Represents a registered user, including credentials for authentication and profile metadata.

**`workout_provider.dart`**  
- Manages workout selection, session progress, exercise completion, and workout history.

**`theme_provider.dart`**  
- Manages app-wide theme settings (light/dark mode) per user, with persistence using Hive.

**`choose_workout_screen.dart`**  
- Workout selection screen where users choose from predefined workout types with exercise lists.

**`current_workout_screen.dart`**  
- Displays the active workout session with a checklist interface and real-time progress tracking.

**`home_screen.dart`**  
- Dashboard showing the current workout summary, a visual progress indicator, and a pie chart of completed workouts.

**`workout_history_screen.dart`**  
- Displays all past workout sessions with timestamps, progress bars, and swipe-to-delete functionality.

**`settings_screen.dart`**  
- Settings interface for toggling theme, managing notifications, logging out, clearing history, and deleting accounts.

**`main_shell.dart`**  
- Primary UI container managing the tab-based navigation between core screens using `IndexedStack`.

**`app_nav_bar.dart`**  
- Bottom navigation bar widget used for navigating between Home, Workouts, Current Session, and Settings.

**`tab_controller_provider.dart`**  
- Provides shared tab control logic across the app, allowing other widgets to change tabs programmatically.

**`main.dart`**  
- App entry point; sets up Hive, initializes state management via `MultiProvider`, and handles initial routing.

**`db_service.dart`**  
- SQLite-based service for user data operations (insert, retrieve, delete).

**`workout_db_service.dart`**  
- SQLite-based service for creating, updating, and retrieving workout session data.

**`pubspec.yaml`**  
- Project configuration file defining Flutter dependencies (`provider`, `sqflite`, `hive`, `fl_chart`, etc.), assets, and environment settings.