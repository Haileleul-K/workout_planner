# Workout Planner - Architecture Documentation

## Clean Architecture Implementation

This project follows **Clean Architecture** principles with a modular structure for scalability and maintainability.

## 📁 Project Structure

```
lib/
├── core/                           # Core application modules
│   └── design_system/             # Design system components
│       ├── app_colors.dart        # Color palette
│       ├── app_text_styles.dart   # Typography system
│       ├── app_assets.dart        # Asset management
│       └── app_spacing.dart       # Spacing & sizing constants
│
├── features/                       # Feature modules
│   └── home/                      # Home/Workout feature
│       ├── models/                # Data models
│       │   ├── exercise_model.dart
│       │   ├── workout_model.dart
│       │   └── exercise_state_model.dart
│       │
│       ├── repository/            # Data layer
│       │   └── workout_repo.dart
│       │
│       ├── bloc/                  # Business logic (State Management)
│       │   ├── workout_cubit.dart
│       │   └── workout_state.dart
│       │
│       └── UI/                    # Presentation layer
│           ├── pages/
│           │   └── workout_page.dart
│           └── widgets/
│               ├── exercise_item_widget.dart
│               ├── exercise_list_widget.dart
│               ├── exercise_details_panel.dart
│               ├── edit_button_widget.dart
│               ├── equipment_badge_widget.dart
│               ├── action_button_widget.dart
│               ├── primary_button_widget.dart
│               └── timer_widget.dart
│
└── main.dart                      # Application entry point
```

## 🏗️ Architecture Layers

### 1. **Design System Layer** (`core/design_system/`)
- **Purpose**: Centralized design tokens and theming
- **Components**:
  - `AppColors`: Color palette with semantic naming
  - `AppTextStyles`: Typography styles
  - `AppAssets`: Asset path management and utilities
  - `AppSpacing`: Spacing, sizing, and radius constants

### 2. **Data Layer** (`models/` & `repository/`)
- **Models**: Immutable data classes with JSON serialization
  - `WorkoutModel`: Represents a workout session
  - `ExerciseModel`: Represents an exercise
  - `ExerciseStateModel`: Tracks runtime state of exercises
  
- **Repository**: Data access abstraction
  - `WorkoutRepository`: Fetches workout data from JSON

### 3. **Business Logic Layer** (`bloc/`)
- **State Management**: Uses BLoC/Cubit pattern with `flutter_bloc`
- **WorkoutCubit**: Manages workout state and operations
  - Exercise selection
  - Play/pause control with timer
  - Edit mode (reorder, remove exercises)
  - State persistence

- **WorkoutState**: Immutable state representation
  - Current workout data
  - Exercise states map
  - Edit mode flags
  - Loading/error states

### 4. **Presentation Layer** (`UI/`)
- **Pages**: Screen-level widgets
  - `WorkoutPage`: Main workout screen

- **Widgets**: Reusable UI components
  - `ExerciseItemWidget`: Circular exercise thumbnail
  - `ExerciseListWidget`: Horizontal scrollable list
  - `ExerciseDetailsPanel`: Exercise detail view
  - `TimerWidget`: Elapsed time display
  - Custom buttons and badges

## 🎨 Design System

### Colors
```dart
- Primary: Yellow (#FDD835)
- Background: Light Gray (#F5F5F5)
- Surface: White (#FFFFFF)
- Text: Black hierarchy (Primary, Secondary, Tertiary)
- Status: Success, Error, Warning, Info
```

### Typography
- Display styles (Large, Medium, Small)
- Heading styles (Large, Medium, Small)
- Body styles (Large, Medium, Small)
- Button and label styles

### Spacing System
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- xxl: 48px

## 🔄 State Management Flow

```
User Action → UI Widget → Cubit Method → State Update → UI Rebuild
```

### Example: Playing an Exercise
1. User taps play button on exercise
2. `ExerciseDetailsPanel` calls `onPlay` callback
3. `WorkoutCubit.playExercise()` is invoked
4. Cubit updates `ExerciseStateModel` to playing state
5. Timer starts incrementing elapsed seconds
6. State emits new `WorkoutState`
7. `BlocBuilder` rebuilds affected widgets
8. UI shows animated GIF and timer

## 📊 Key Features Implementation

### 1. Exercise Selection & Playback
- **Selection**: Tap on exercise item
- **Play/Pause**: Controlled via `ExerciseStateModel.playbackState`
- **Timer**: Dart `Timer.periodic` increments elapsed time
- **Auto-complete**: After 5 seconds, marks exercise as completed
- **GIF Animation**: Switches between static PNG and animated GIF based on playback state

### 2. Edit Mode
- **Activation**: Long press on exercise or tap Edit button
- **Reorder**: `ReorderableListView` with drag & drop
- **Remove**: Tap minus badge on exercise
- **Save/Discard**: 
  - Save: Persists changes to `originalExercises`
  - Discard: Restores from `originalExercises`

### 3. Equipment Display
- Equipment icons mapped via `AppAssets.getEquipmentIcon()`
- Badge shows icon + label (e.g., "Dumbbell", "Barbell")

### 4. Responsive Design
- Horizontal scrollable exercise list
- Expandable details panel
- Smooth transitions between modes

## 🧩 Widget Modularity

All widgets are:
- **Reusable**: Accept data via constructor parameters
- **Stateless**: Pure functions of their inputs
- **Single Responsibility**: Each widget has one clear purpose
- **Composable**: Combine to build complex UIs

### Example: `ExerciseItemWidget`
```dart
ExerciseItemWidget(
  exercise: ExerciseModel,
  exerciseState: ExerciseStateModel,
  onTap: () => selectExercise(),
  isEditMode: false,
  onRemove: null,
)
```

## 🎯 SOLID Principles Applied

1. **Single Responsibility**: Each class/widget has one reason to change
2. **Open/Closed**: Design system allows extension without modification
3. **Liskov Substitution**: Models are interchangeable where interfaces match
4. **Interface Segregation**: Widgets only depend on props they need
5. **Dependency Inversion**: Cubit depends on Repository abstraction

## 📝 JSON Data Handling

### Input JSON Structure
```json
{
  "workout_name": "Chris' Full Body 1",
  "exercises": [
    {
      "name": "Squat",
      "asset_url": "https://...",
      "gif_asset_url": "https://...",
      "equipment": "barbell"
    }
  ]
}
```

### Parsing Flow
1. Repository fetches JSON string
2. `json.decode()` converts to `Map<String, dynamic>`
3. `WorkoutModel.fromJson()` creates type-safe model
4. Models used throughout app with compile-time safety

## 🚀 Getting Started

### Run the App
```bash
cd workout_planner
flutter pub get
flutter run
```

### Update Workout Data
Modify the JSON in `lib/features/home/repository/workout_repo.dart`

## 🔧 Customization

### Add New Equipment Type
1. Add icon to `assets/icons/`
2. Update `AppAssets.getEquipmentIcon()` switch case
3. Update `AppAssets.getEquipmentDisplayName()`

### Add New Exercise State
1. Add state to `ExercisePlaybackState` enum
2. Update `ExerciseStateModel`
3. Handle in `WorkoutCubit`
4. Update UI in widgets

### Customize Colors/Styles
- Edit `lib/core/design_system/app_colors.dart`
- Edit `lib/core/design_system/app_text_styles.dart`
- Changes propagate automatically to all widgets

## 🧪 Testing Strategy

### Unit Tests
- Test models: JSON parsing, equality
- Test cubit: State transitions, business logic
- Test repository: Data fetching

### Widget Tests
- Test individual widgets in isolation
- Mock dependencies (cubit, models)
- Verify render output

### Integration Tests
- Full user flows (select → play → complete)
- Edit mode workflows
- Navigation scenarios

## 📦 Dependencies

- `flutter_bloc ^8.1.3`: State management
- `equatable ^2.0.5`: Value equality for models/states

## 🎨 UI/UX Highlights

- **Smooth Transitions**: Animated state changes
- **Visual Feedback**: Selection borders, overlays
- **Loading States**: Shimmer/spinner for async operations
- **Error Handling**: Graceful fallbacks for network images
- **Accessibility**: Semantic widgets, proper contrast

## 📚 Further Improvements

- [ ] Add exercise addition functionality
- [ ] Persist data to local storage (SharedPreferences/Hive)
- [ ] Add workout history tracking
- [ ] Implement sets/reps tracking
- [ ] Add workout timer with rest periods
- [ ] Support multiple workouts
- [ ] Add exercise search/filter

