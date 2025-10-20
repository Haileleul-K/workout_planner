# Workout Planner - User Guide

## 🏋️ How to Use the Workout Planner

This guide explains how to interact with the Workout Planner application.

## 📱 Main Screen Overview

When you launch the app, you'll see:

1. **Header Bar**
   - Back button (top-left)
   - Workout name ("Chris' Full Body 1")
   - Timer (appears when exercise is selected)
   - Stop button (appears when exercise is playing)

2. **Exercise List** (Horizontal Scroll)
   - Circular exercise thumbnails
   - Exercise names below images
   - Edit button (pencil icon) at the end

3. **Details Panel** (Below exercise list)
   - Shows selected exercise details
   - Large exercise image/GIF
   - Play/Pause button
   - Equipment badge
   - Action buttons (Replace, Instructions, Warm Up, FAQ)

## 🎯 Basic Workout Flow

### 1. Select an Exercise
- **Tap** on any exercise in the horizontal list
- The exercise will be highlighted with a yellow border
- Timer appears in the header (starting at 00:00)
- Details panel shows the exercise information

### 2. Play the Exercise
- **Tap the play button** (yellow circle) on the large exercise image
- GIF animation starts playing
- Timer begins counting
- Play button changes to pause button

### 3. Pause the Exercise
- **Tap the pause button** while exercise is playing
- GIF animation stops
- Timer pauses
- Can resume by tapping play again

### 4. Auto-Complete
- After **5 seconds** of playing, the exercise automatically completes
- Green checkmark overlay appears on the exercise thumbnail
- Timer stops
- Can select next exercise to continue workout

### 5. Stop Exercise
- **Tap the red stop button** in the header
- Returns to exercise selection mode
- Timer resets

## ✏️ Edit Mode

### Entering Edit Mode

**Option 1: Tap Edit Button**
- Tap the pencil icon at the end of the exercise list

**Option 2: Long Press**
- Long press on any exercise thumbnail

### Edit Mode Actions

#### Reorder Exercises
1. **Tap and hold** on an exercise thumbnail
2. **Drag** left or right to new position
3. **Release** to drop in new position

#### Remove Exercises
1. **Tap the red minus (−) button** in the top-right of exercise thumbnail
2. Exercise is immediately removed from the list

#### Save Changes
1. Make your changes (reorder or remove exercises)
2. **Tap "Save Changes"** button (yellow, at bottom)
3. Changes are permanently applied
4. Returns to normal mode

#### Discard Changes
1. **Tap "Discard"** button (white, at bottom)
2. All changes are reverted to original state
3. Returns to normal mode

## 🎨 Visual States

### Exercise Thumbnail States

| State | Visual Indicator |
|-------|-----------------|
| **Normal** | Gray border, static image |
| **Selected** | Yellow border, play button overlay |
| **Playing** | Yellow border, animated GIF |
| **Completed** | Green checkmark overlay |
| **Edit Mode** | Red border, minus button |

### Button States

| Button | State | Appearance |
|--------|-------|-----------|
| **Save Changes** | Enabled | Yellow background |
| **Save Changes** | Disabled | Gray background |
| **Discard** | Always enabled | White with border |

## ⏱️ Timer Display

The timer appears in the header when an exercise is selected:

- **Format**: MM:SS (e.g., 00:05, 01:30)
- **Starts**: When play button is pressed
- **Stops**: When paused, completed, or stopped
- **Resets**: When deselecting exercise

## 🏷️ Equipment Badges

Each exercise shows its equipment type:

- **Barbell** - Barbell icon
- **Dumbbell** - Dumbbell icon
- **Cable** - Cable machine icon
- **Bodyweight** - Bodyweight icon

## 🎬 Action Buttons

Located below the exercise image in details panel:

1. **Replace** (Yellow button)
   - Replace current exercise with alternative
   - *(Visual state only - no action in current version)*

2. **Instructions**
   - View exercise instructions
   - *(Visual state only)*

3. **Warm Up**
   - View warm-up recommendations
   - *(Visual state only)*

4. **FAQ**
   - Frequently asked questions about exercise
   - *(Visual state only)*

## 📋 Workout Session Example

**Complete Workout Flow:**

1. Open app → See "Chris' Full Body 1" workout
2. Tap "Squat" exercise
3. Tap play button → Timer starts, GIF animates
4. Wait 5 seconds → Auto-completes with checkmark
5. Tap "Inclined Bench Press"
6. Tap play → Complete second exercise
7. Continue through all exercises
8. (Optional) Edit workout for next session

## 💡 Tips & Tricks

### Efficient Workout
- Queue up exercises mentally before starting
- Use the timer to track rest periods
- Mark exercises complete as you finish sets

### Customizing Your Workout
- Enter edit mode to personalize exercise order
- Remove exercises you want to skip
- Save changes for next session

### Navigation
- Tap back button to return to home (if implemented)
- Tap stop button to exit current exercise
- Tap outside details to deselect (if implemented)

## 🐛 Troubleshooting

### Exercise Image Not Loading
- Check internet connection
- Image will show placeholder icon if failed
- Retry by reselecting the exercise

### Timer Not Starting
- Ensure you've pressed the play button
- Check that exercise is selected (yellow border)

### Can't Save Changes
- "Save Changes" button only enables after making changes
- Try reordering or removing an exercise first

### GIF Not Animating
- Press play button to start animation
- Static image shows when paused or idle

## 🔄 Resetting the Workout

To reset all exercises to incomplete:
- Close and reopen the app
- Or tap back and re-enter the workout

## 📱 Device Compatibility

- **Optimized for**: Mobile phones (iOS & Android)
- **Screen sizes**: 4" to 7" displays
- **Orientation**: Portrait mode recommended

## 🎯 Keyboard Shortcuts (Future)

*To be implemented:*
- Space: Play/Pause
- Arrow keys: Navigate exercises
- E: Enter edit mode
- Esc: Exit edit mode

## 📊 Progress Tracking (Future)

*Planned features:*
- Workout completion percentage
- Exercise history
- Personal records
- Workout notes

---

**Need more help?** Check the ARCHITECTURE.md file for technical details or consult the inline code documentation.

