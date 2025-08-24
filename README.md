# Habit Tracker Flutter App

A beautiful habit tracking mobile application built with Flutter, featuring a clean, minimal design with a calming light blue color scheme.

## Features

- **4 Main Screens:**
  - 🏠 **Home** - Dashboard with daily overview and quick stats
  - ✅ **Habits** - Track your daily habits with weekly progress
  - 📊 **Analyze** - AI insights and performance analytics
  - 👤 **Profile** - User settings and preferences

- **Clean Design System:**
  - Soft light blue gradient backgrounds
  - Material Design 3 components
  - Smooth animations and transitions
  - Mobile-first responsive design

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.0)
- Dart SDK
- Android Studio / VS Code with Flutter extension
- iOS Simulator / Android Emulator

### Installation

1. **Clone or download this project**

2. **Navigate to the project directory:**
   ```bash
   cd habit_tracker
   ```

3. **Get Flutter dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── constants/
│   └── app_constants.dart      # Colors, sizes, and text styles
├── screens/
│   ├── home_screen.dart        # Dashboard and overview
│   ├── habit_tracker_screen.dart # Main habit tracking
│   ├── analyze_screen.dart     # AI insights and analytics
│   └── profile_screen.dart     # User profile and settings
├── widgets/
│   ├── header_widget.dart      # Reusable header component
│   └── habit_card_widget.dart  # Individual habit cards
└── main.dart                   # App entry point with navigation
```

## Key Features

### Home Screen
- Personal greeting with motivational quotes
- Daily completion stats and streaks
- Quick action buttons
- Recent activity feed

### Habits Screen
- Individual habit cards with weekly progress
- Visual progress bars and day indicators
- Add new habit functionality
- Completion tracking

### Analyze Screen
- AI-powered insights and recommendations
- Performance metrics and trends
- Weekly progress visualization
- Personalized suggestions

### Profile Screen
- User profile with stats
- Settings sections (Account, Preferences, Support)
- Theme and notification preferences
- App information and support

## Design System

The app uses a carefully crafted design system with:

- **Primary Colors:** Light blues (#3B82F6, #6366F1)
- **Background:** Soft gradients (#FAFBFF to #EEFF2FF)
- **Typography:** System fonts with consistent sizing
- **Spacing:** 8px grid system for consistent layouts
- **Border Radius:** Rounded corners (8px to 16px)

## Development

### Adding New Features
1. Create new widgets in `/lib/widgets/`
2. Add new screens in `/lib/screens/`
3. Update constants in `/lib/constants/app_constants.dart`
4. Use existing design system for consistency

### Customization
- Modify colors in `AppColors` class
- Adjust spacing in `AppSizes` class
- Update text styles in `AppTextStyles` class

## Dependencies

- `flutter`: Flutter SDK
- `cupertino_icons`: iOS-style icons
- `flutter_lints`: Linting rules for code quality

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the project
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is for educational and demonstration purposes.
