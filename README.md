# 🏋️ Workout Planner

A modern, intuitive workout tracking application built with Flutter, following clean architecture principles and BLoC state management.

## ✨ Features

- **Interactive Exercise List**: Horizontal scrollable exercise thumbnails with real-time GIF previews
- **Smart Selection**: Tap to select and auto-play exercises with animated GIFs
- **Auto-Complete Timer**: Exercises automatically complete after 5 seconds with visual feedback
- **Edit Mode**: Long-press any exercise to enter edit mode
  - Drag & drop to reorder exercises
  - Remove exercises with one tap
  - Save or discard changes
- **Visual Indicators**: 
  - Yellow border highlights selected exercises
  - Play icon badge for active exercises
  - Green checkmark for completed exercises
- **Equipment Tracking**: Display equipment type (Barbell, Dumbbell, Cable, Bodyweight)
- **Clean UI**: Minimalist design matching modern fitness app standards

## 🏗️ Architecture

- **Clean Architecture**: Separated layers (UI, BLoC, Models, Repository)
- **State Management**: BLoC/Cubit pattern with `flutter_bloc`
- **Design System**: Centralized colors, typography, spacing, and assets
- **Modular Widgets**: Reusable, composable UI components

## 🛠️ Tech Stack

- **Flutter SDK** `^3.8.1`
- **flutter_bloc** `^8.1.3` - State management
- **equatable** `^2.0.5` - Value equality for models

## 🚀 Getting Started


### Installation

1. **Clone the repository**
   ```bash
   git clone <https://github.com/Haileleul-K/workout_planner>
   cd workout_planner
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 How to Use

1. **Select Exercise**: Tap any exercise thumbnail to select it
2. **Auto-Play**: Selected exercise automatically starts playing with timer
3. **Complete**: Exercise auto-completes after 5 seconds (shows checkmark)
4. **Edit Mode**: Long-press any exercise to enter edit mode
5. **Reorder**: Drag exercises left/right to reorder
6. **Remove**: Tap the red minus button to remove an exercise
7. **Save**: Tap "Save Changes" to keep your edits

## 📂 Project Structure

```
lib/
├── core/
│   └── design_system/          # Colors, typography, spacing, assets
├── features/
│   └── home/
│       ├── models/             # Data models (Exercise, Workout)
│       ├── repository/         # Data layer
│       ├── bloc/               # State management (Cubit/State)
│       └── UI/
│           ├── pages/          # Main screens
│           └── widgets/        # Reusable components
└── main.dart
```

## 🎨 Design System

The app uses a centralized design system:
- **Colors**: Primary yellow (#FDD835), surface white, text black
- **Typography**: Consistent text styles for headings, body, buttons
- **Spacing**: 4/8/16/24/32/48px scale
- **Components**: Modular widgets (buttons, badges, cards)

## 📝 JSON Data Format

Workout data is defined in JSON format: found under a repository drirectory


### Commit Convention

- `feat:` New features
- `fix:` Bug fixes
- `refactor:` Code refactoring
- `docs:` Documentation updates
- `style:` UI/styling changes
