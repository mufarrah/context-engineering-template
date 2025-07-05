### 🔄 Project Awareness & Context
- **Always read `PLANNING.md`** at the start of a new conversation to understand the project's architecture, goals, style, and constraints.
- **Check `TASK.md`** before starting a new task. If the task isn't listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** as described in `PLANNING.md`.
- **Use Flutter/Dart commands** and follow platform-specific guidelines.

### 🧱 Code Structure & Modularity
- **Never create a file longer than 400 lines of code.** If a file approaches this limit, refactor by splitting into widgets, utilities, or services.
- **Organize code following clean architecture principles:**
  - `lib/features/` - Feature-based organization
    - `feature_name/`
      - `presentation/` - UI layer (pages, widgets)
      - `domain/` - Business logic (entities, use cases)
      - `data/` - Data layer (repositories, data sources)
  - `lib/core/` - Shared utilities and constants
  - `lib/config/` - App configuration and theme
  - `lib/supabase/` - Supabase-specific utilities
- **Supabase integration structure:**
  - `lib/supabase/client.dart` - Supabase client setup
  - `lib/supabase/auth_service.dart` - Authentication service
  - `lib/supabase/database_service.dart` - Database operations
  - `lib/supabase/storage_service.dart` - Storage operations
- **State management structure** (using your chosen solution):
  - Keep state logic separate from UI
  - Use proper folder structure for state management files

### 🧪 Testing & Reliability
- **Always create tests for new features:**
  - Widget tests for UI components
  - Unit tests for business logic
  - Integration tests for Supabase operations
  - Golden tests for complex widgets
- **Test structure mirrors lib structure:**
  - `test/features/feature_name/`
  - `test/core/`
  - `test/supabase/`
- **Include tests for:**
  - Widget rendering
  - User interactions
  - State changes
  - Supabase operations
  - Auth flows
  - Edge cases and error states
- **Use proper test utilities:**
  - `flutter_test` for widget tests
  - `mockito` or `mocktail` for mocking
  - `integration_test` for e2e tests
  - Mock Supabase client for testing

### ✅ Task Completion
- **Mark completed tasks in `TASK.md`** immediately after finishing them.
- **Run these checks before marking complete:**
  - `flutter analyze` (static analysis)
  - `flutter test` (all tests pass)
  - `flutter format .` (code formatting)
  - `flutter build apk --debug` or `flutter build ios` (builds successfully)
  - Test Supabase integration manually
- Add new sub-tasks or TODOs discovered during development to `TASK.md`.

### 📎 Style & Conventions
- **Follow Dart style guide** and use `flutter format`.
- **Use strong typing** - avoid `dynamic` unless absolutely necessary.
- **Naming conventions:**
  - Classes: `PascalCase`
  - Files: `snake_case`
  - Variables/functions: `camelCase`
  - Constants: `lowerCamelCase` or `kConstantName`
- **Widget conventions:**
  - Prefer `const` constructors
  - Use `Key` when necessary
  - Extract widgets for reusability
  - Keep build methods clean
- **Supabase-specific conventions:**
  - Use consistent error handling
  - Implement proper type safety
  - Follow Supabase Flutter best practices
  - Use RLS (Row Level Security) policies

### 📚 Documentation & Explainability
- **Document all public APIs** with DartDoc comments:
  ```dart
  /// Service for handling Supabase authentication operations.
  /// 
  /// This service provides methods for user authentication including
  /// sign in, sign up, and session management.
  class AuthService {
    /// Signs in a user with email and password.
    /// 
    /// Returns [AuthUser] on success, throws [AuthException] on failure.
    Future<AuthUser> signIn({
      required String email,
      required String password,
    }) async {
      // Implementation
    }
  }
  ```
- **Update `README.md`** with setup instructions and architecture decisions.
- **Comment complex logic** with clear explanations.
- **Document state management patterns** used in the project.

### 🏗️ Framework-Specific Rules

#### Flutter + Supabase Integration:
- **Initialize Supabase** in `main.dart` before `runApp()`
- **Use Supabase client** consistently throughout app
- **Authentication patterns:**
  - Use `supabase.auth.onAuthStateChange` for state management
  - Implement proper session handling
  - Use route guards for protected pages
- **Database operations:**
  - Use proper error handling with try-catch
  - Implement optimistic updates where appropriate
  - Use Supabase's real-time subscriptions for live data
- **Storage operations:**
  - Handle file uploads with proper progress indicators
  - Implement image caching for better performance
  - Use Supabase Storage for media files

#### State Management Integration:
**For Riverpod:**
- Use `StateNotifierProvider` for auth state
- Use `FutureProvider` for async Supabase operations
- Implement proper disposal

**For Bloc:**
- Create separate blocs for auth and data operations
- Use proper event/state patterns
- Implement proper error handling

### 🧠 AI Behavior Rules
- **Never assume package availability** - check `pubspec.yaml` first.
- **Always verify Supabase setup** before implementing features.
- **Follow existing patterns** in the codebase.
- **Check for analyzer warnings** before completing tasks.
- **Test on both platforms** when making platform-specific changes.
- **Always implement proper error handling** for Supabase operations.

### 🚀 Performance & Best Practices
- **Optimize app performance:**
  - Use `const` widgets wherever possible
  - Implement `ListView.builder` for long lists
  - Use `RepaintBoundary` for complex widgets
  - Implement proper image caching
- **Supabase optimizations:**
  - Use `select()` to limit returned columns
  - Implement proper pagination
  - Cache frequently accessed data
  - Use database indexes for better query performance
- **Memory management:**
  - Dispose controllers and streams properly
  - Cancel subscriptions in `dispose()`
  - Use proper widget lifecycle management

### 📱 Platform-Specific Considerations
- **Android specific:**
  - Handle Android permissions properly
  - Follow Material Design guidelines
  - Test on different Android versions
- **iOS specific:**
  - Handle iOS permissions
  - Follow iOS design guidelines
  - Test on different iOS versions
- **Deep linking:**
  - Configure proper URL schemes
  - Handle Supabase auth redirects
  - Test deep link functionality

### 🔐 Security & Best Practices
- **Supabase security:**
  - Never expose service role key in client
  - Use RLS policies for data access
  - Implement proper authentication checks
  - Validate all user inputs
- **Flutter security:**
  - Use secure storage for sensitive data
  - Implement proper certificate pinning
  - Handle biometric authentication properly
  - Sanitize user inputs

### 📊 Supabase Integration Patterns
- **Authentication flow:**
  ```dart
  // Sign in example
  final response = await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
  
  if (response.user != null) {
    // Success
  }
  ```

- **Database operations:**
  ```dart
  // Type-safe database operations
  final data = await supabase
      .from('table_name')
      .select('column1, column2')
      .eq('user_id', userId);
  ```

- **Real-time subscriptions:**
  ```dart
  // Listen to changes
  final subscription = supabase
      .from('table_name')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .listen((data) {
        // Handle updates
      });
  ```

### 🧪 Testing Patterns
- **Mock Supabase client:**
  ```dart
  class MockSupabaseClient extends Mock implements SupabaseClient {}
  ```

- **Widget test setup:**
  ```dart
  testWidgets('should display user data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: UserProfile(user: testUser),
      ),
    );
    
    expect(find.text(testUser.email), findsOneWidget);
  });
  ```

### 🔄 Error Handling Patterns
- **Consistent error handling:**
  ```dart
  try {
    final result = await supabaseOperation();
    return Success(result);
  } on PostgrestException catch (e) {
    return Failure(e.message);
  } on AuthException catch (e) {
    return Failure(e.message);
  } catch (e) {
    return Failure('An unexpected error occurred');
  }
  ```