# CONFIG.md - Flutter + Supabase Project

## 🚀 Available Commands & Workflows

### 🤖 **Claude Code Commands** (Available in project root)
```bash
/analyze-project              # Analyze project structure and patterns
/generate-prp [feature.md]    # Generate Project Requirement Plan
/execute-prp [prp-file.md]    # Execute implementation from PRP
/add-suggestions-to-tasks     # Add analysis suggestions to TASK.md
```

### 📱 **Flutter Development Commands**

#### Project Setup
```bash
# Get Flutter dependencies
flutter pub get

# Set up environment variables
cp .env.example .env
# Edit .env with your Supabase credentials

# Generate code (if using build_runner)
flutter packages pub run build_runner build

# Clean and get dependencies
flutter clean && flutter pub get
```

#### Development
```bash
# Run app in debug mode
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d device_id

# Run on Chrome (web)
flutter run -d chrome

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

#### Build Commands
```bash
# Build for Android
flutter build apk
flutter build appbundle  # For Play Store

# Build for iOS
flutter build ios

# Build for Web
flutter build web

# Build for Desktop
flutter build windows
flutter build macos
flutter build linux
```

### 🗄️ **Supabase Commands**

#### Database Management
```bash
# Initialize Supabase (if not done)
npx supabase init

# Start local Supabase
npx supabase start

# Generate Dart types from database
npx supabase gen types dart --project-id YOUR_PROJECT_ID > lib/types/supabase.dart

# Apply database migrations
npx supabase db push

# Reset local database
npx supabase db reset

# Create new migration
npx supabase migration new add_user_profiles
```

#### Authentication Commands
```bash
# Test authentication in Supabase dashboard
# Use local auth server: http://localhost:54321/auth/v1

# Reset user password (via dashboard)
# Manage users in Supabase dashboard
```

### 🧪 **Testing Commands**

#### Unit Testing
```bash
# Run all tests
flutter test

# Run tests in verbose mode
flutter test --verbose

# Run specific test file
flutter test test/unit/user_test.dart

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### Widget Testing
```bash
# Run widget tests
flutter test test/widget/

# Run specific widget test
flutter test test/widget/home_screen_test.dart
```

#### Integration Testing
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/ -d device_id

# Run integration tests on real device
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
```

### 🔧 **Code Quality Commands**

#### Analysis and Formatting
```bash
# Analyze Dart code
flutter analyze

# Format Dart code
dart format .

# Fix Dart issues
dart fix --apply

# Check for outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade
```

### 🛠️ **Context Engineering Workflow**

#### Complete Feature Development
```bash
# 1. Check current tasks
cat context-engineering/TASK.md

# 2. Create feature description
echo "# Feature: User Profile" > profile-feature.md
echo "Create user profile screen with avatar upload" >> profile-feature.md

# 3. Generate implementation plan
/generate-prp profile-feature.md

# 4. Review the generated PRP
cat context-engineering/PRPs/profile-feature.md

# 5. Execute implementation
/execute-prp context-engineering/PRPs/profile-feature.md

# 6. Test the implementation
flutter test                    # Run unit tests
flutter test test/widget/       # Run widget tests
flutter run                     # Manual testing

# 7. Add any discovered tasks
/add-suggestions-to-tasks
```

#### Project Analysis and Optimization
```bash
# Analyze current project structure
/analyze-project

# Check app size
flutter build apk --analyze-size

# Update dependencies
flutter pub upgrade

# Check for security issues
flutter pub audit
```

### 📱 **Flutter Specific Commands**

#### Screen and Widget Generation
```bash
# Create new screen
mkdir -p lib/screens/profile
echo "class ProfileScreen extends StatelessWidget { @override Widget build(context) => Scaffold(); }" > lib/screens/profile/profile_screen.dart

# Create new widget
mkdir -p lib/widgets/common
echo "class CustomButton extends StatelessWidget { @override Widget build(context) => ElevatedButton(); }" > lib/widgets/common/custom_button.dart
```

#### State Management (if using Riverpod/Bloc)
```bash
# Generate providers (if using Riverpod)
flutter packages pub run build_runner build

# Generate bloc files (if using Bloc)
mason make bloc --name user --output-dir lib/blocs/
```

### 🎨 **UI and Styling Commands**

#### Asset Management
```bash
# Generate asset classes (if using flutter_gen)
flutter packages pub run build_runner build

# Add images to pubspec.yaml and run:
flutter pub get
```

#### Theming
```bash
# Generate theme data
# Add to lib/theme/app_theme.dart

# Generate Material 3 theme
# Use Material Theme Builder online tool
```

### 🔐 **Environment and Security**

#### Environment Management
```bash
# Copy environment template
cp .env.example .env

# Required Supabase environment variables:
# SUPABASE_URL=your_supabase_url
# SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### Security and Obfuscation
```bash
# Build with obfuscation (Android)
flutter build apk --obfuscate --split-debug-info=debug_info/

# Build with obfuscation (iOS)
flutter build ios --obfuscate --split-debug-info=debug_info/

# Check permissions
# Review android/app/src/main/AndroidManifest.xml
# Review ios/Runner/Info.plist
```

### 📊 **Performance and Monitoring**

#### Performance Analysis
```bash
# Run performance profiling
flutter run --profile

# Analyze app startup time
flutter run --trace-startup --profile

# Generate performance report
flutter analyze --suggestions

# Check for memory leaks
flutter run --enable-checked-mode
```

#### App Size Analysis
```bash
# Analyze APK size
flutter build apk --analyze-size

# Analyze iOS app size
flutter build ios --analyze-size

# Generate size analysis
flutter build apk --target-platform android-arm64 --analyze-size
```

### 🗃️ **Database Operations**

#### Supabase Database Commands
```bash
# Connect to remote database
npx supabase db remote commit

# Seed database
npx supabase db seed

# Run SQL queries
npx supabase db query "SELECT * FROM users"

# Create database functions
# Add to supabase/functions/ directory
```

#### Local Development
```bash
# Start Supabase locally
npx supabase start

# Stop Supabase locally
npx supabase stop

# Reset local environment
npx supabase db reset
```

### 📱 **Platform-Specific Commands**

#### Android
```bash
# Run on Android device
flutter run -d android

# Build release APK
flutter build apk --release

# Build app bundle for Play Store
flutter build appbundle --release

# Install APK on device
flutter install -d device_id
```

#### iOS
```bash
# Run on iOS device
flutter run -d ios

# Build for iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace

# Archive for App Store
# Use Xcode or flutter build ipa
```

#### Web
```bash
# Run on web
flutter run -d chrome

# Build for web
flutter build web --release

# Serve web build locally
cd build/web && python -m http.server 8000
```

## 🔍 **Available Integrations**

### Supabase Features
- **Authentication**: Email/password, OAuth, magic links
- **Database**: PostgreSQL with real-time subscriptions
- **Storage**: File uploads and management
- **Edge Functions**: Serverless Dart functions
- **Real-time**: Live data synchronization

### Flutter Features
- **Cross-platform**: iOS, Android, Web, Desktop
- **Hot Reload**: Fast development iteration
- **Native Performance**: Compiled to native code
- **Rich UI**: Material Design and Cupertino widgets
- **State Management**: Provider, Riverpod, Bloc, etc.

## 📚 **Quick Reference**

### Most Common Commands
```bash
# 1. Start development
flutter run

# 2. Analyze project
/analyze-project

# 3. Generate feature plan
echo "# Feature: Push Notifications" > notifications.md && /generate-prp notifications.md

# 4. Implement feature
/execute-prp context-engineering/PRPs/notifications.md

# 5. Test and build
flutter test && flutter build apk
```

### File Structure
```
project/
├── .claude/                    # Claude Code commands
├── context-engineering/        # Context Engineering files
├── lib/
│   ├── screens/               # App screens
│   ├── widgets/               # Reusable widgets
│   ├── services/              # Business logic and API calls
│   ├── models/                # Data models
│   ├── providers/             # State management
│   ├── utils/                 # Utilities and helpers
│   └── main.dart              # App entry point
├── test/                      # Unit and widget tests
├── integration_test/          # Integration tests
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── assets/                    # Images, fonts, etc.
├── .env                       # Environment variables
└── pubspec.yaml               # Dependencies and configuration
```

### Essential Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^latest
  riverpod: ^latest  # or your state management choice
  go_router: ^latest
  json_annotation: ^latest

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^latest
  json_serializable: ^latest
  flutter_launcher_icons: ^latest
```

### Environment Variables
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 🚨 **Important Notes**

1. **Platform Permissions**: Configure permissions in AndroidManifest.xml and Info.plist
2. **State Management**: Choose consistent state management (Riverpod, Bloc, Provider)
3. **Navigation**: Use go_router for type-safe navigation
4. **Supabase Integration**: Use supabase_flutter package for seamless integration
5. **Testing**: Write tests for business logic and critical UI components
6. **Performance**: Use const constructors and avoid unnecessary rebuilds

This CONFIG.md provides all commands needed for efficient Flutter + Supabase development! 