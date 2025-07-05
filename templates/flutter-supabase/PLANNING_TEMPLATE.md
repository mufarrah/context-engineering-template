# Project Architecture

<!-- 
TODO: Customize this template for your specific Flutter project.
Replace all placeholders with your actual project details.
-->

## Overview
[YOUR PROJECT DESCRIPTION HERE]

## Tech Stack
- **Framework:** Flutter
- **Language:** Dart
- **Backend:** Supabase (Auth, Database, Storage, Functions)
- **State Management:** [Riverpod / Bloc / Provider / GetX]
- **UI Library:** [Material Design / Cupertino / Custom]
- **Testing:** Flutter Test + Integration Tests
- **Platforms:** [Android / iOS / Web / Desktop]

## Supabase Services Used
- **Authentication:** [Email/Password, OAuth providers]
- **Database:** PostgreSQL with Row Level Security
- **Storage:** Supabase Storage (if applicable)
- **Edge Functions:** Serverless functions (if applicable)
- **Real-time:** Live data subscriptions (if applicable)

## Project Structure
```
lib/
├── core/                   # Core utilities and constants
│   ├── constants/         # App constants
│   ├── error/            # Error handling
│   ├── network/          # Network utilities
│   └── utils/            # Helper functions
├── config/               # App configuration
│   ├── theme/           # App theming
│   └── routes/          # Route definitions
├── features/            # Feature-based organization
│   ├── auth/           # Authentication feature
│   │   ├── data/       # Data layer
│   │   ├── domain/     # Business logic
│   │   └── presentation/ # UI layer
│   └── [feature_name]/ # Other features
├── supabase/           # Supabase integration
│   ├── client.dart    # Supabase client setup
│   ├── auth_service.dart # Auth operations
│   └── database_service.dart # Database operations
├── shared/             # Shared components
│   ├── widgets/       # Reusable widgets
│   └── models/        # Shared data models
└── main.dart          # App entry point
```

## Conventions

### Widget Structure
- Stateless widgets when possible
- StatefulWidget for local state
- Custom hooks for reusable logic
- Separate business logic from UI

### Supabase Patterns
- Single Supabase client instance
- Service classes for different operations
- Proper error handling with Result types
- Real-time subscriptions with proper disposal

### State Management Approach
<!-- Choose one and remove others -->
- **Riverpod:** Provider-based reactive state
- **Bloc:** Event-driven state management
- **Provider:** Simple state management
- **GetX:** All-in-one solution

### File Naming
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `lowerCamelCase` or `kConstantName`

### Testing Strategy
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for full flows
- Golden tests for visual regression

## Key Patterns

### Authentication Flow
```dart
// Listen to auth state changes
supabase.auth.onAuthStateChange.listen((data) {
  final AuthState state = data.state;
  final User? user = data.user;
  // Handle auth state
});

// Sign in
final response = await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

### Database Operations
```dart
// Type-safe operations
final response = await supabase
    .from('table_name')
    .select('column1, column2')
    .eq('user_id', userId);

if (response.error == null) {
  final data = response.data as List<dynamic>;
  // Handle success
}
```

### Navigation
- Use named routes for navigation
- Pass data through route arguments
- Handle deep linking appropriately

## Environment Configuration
```dart
// Environment variables
class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}
```

## Platform Considerations
- **Android**: Material Design, permissions, app signing
- **iOS**: Cupertino design, App Store guidelines, provisioning
- **Web**: Browser compatibility, responsive design
- **Desktop**: Window management, platform-specific features

## Security Considerations
- Row Level Security (RLS) policies in Supabase
- Secure storage for sensitive data
- Input validation and sanitization
- Certificate pinning for production
- Biometric authentication support

## Performance Optimizations
- Use const constructors for immutable widgets
- Implement ListView.builder for long lists
- Optimize image loading and caching
- Use RepaintBoundary for complex widgets
- Proper state management to avoid rebuilds

## Development Workflow
1. Feature branch from `main`
2. Implement following clean architecture
3. Write tests for new functionality
4. Run `flutter analyze` and fix issues
5. Test on multiple platforms
6. Create pull request with proper description

## Build & Deployment
- **Development:** `flutter run`
- **Testing:** `flutter test` and `flutter integration_test`
- **Android:** `flutter build apk` or `flutter build appbundle`
- **iOS:** `flutter build ios`
- **Web:** `flutter build web`

## Dependencies Management
- Keep dependencies up to date
- Use `flutter pub deps` to check dependency tree
- Pin major versions to avoid breaking changes
- Regularly audit dependencies for security

## Internationalization (if applicable)
- Use `flutter_localizations`
- Implement proper text scaling
- Support RTL languages if needed
- Test with different locales