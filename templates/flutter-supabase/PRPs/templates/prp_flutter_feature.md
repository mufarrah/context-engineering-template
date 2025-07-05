# PRP: [Feature Name]

## Goal
[One sentence description of what we're building]

## Why
[Business value and user benefit]

## What
[Detailed description of the feature]

## Context

### Technical Stack
- Flutter
- Dart
- Supabase (Auth, Database, Storage)
- [State Management: Riverpod/Bloc/Provider]
- [UI: Material/Cupertino]
- Testing: Flutter Test + Integration Tests

### Supabase Configuration
```dart
// Required Supabase services
- Authentication: [methods used]
- Database: [tables and RLS policies needed]
- Storage: [buckets if applicable] 
- Edge Functions: [functions if applicable]
- Real-time: [subscriptions if applicable]
```

### Relevant Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart/introduction)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth/auth-helpers/flutter)
- Internal patterns: See `lib/supabase/` directory

### Existing Patterns in Codebase
```dart
// Supabase client pattern
// lib/supabase/client.dart
final supabase = Supabase.instance.client;

// Service pattern
// lib/supabase/auth_service.dart
class AuthService {
  Future<AuthResponse> signIn({required String email, required String password}) async {
    // Implementation
  }
}

// Widget pattern
// lib/features/feature/presentation/
class FeatureWidget extends StatelessWidget {
  // Implementation
}
```

## Implementation Blueprint

### 1. Data Models & Types
```dart
// Define data models
class FeatureModel {
  final String id;
  final String userId;
  final DateTime createdAt;
  // ... other fields
  
  const FeatureModel({
    required this.id,
    required this.userId,
    required this.createdAt,
  });
  
  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    return FeatureModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
```

### 2. Database Schema & RLS
```sql
-- Supabase table creation
CREATE TABLE feature_table (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  -- other columns
);

-- RLS Policies
ALTER TABLE feature_table ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own data" ON feature_table
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own data" ON feature_table
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

### 3. Service Layer
```dart
// lib/supabase/feature_service.dart
class FeatureService {
  final SupabaseClient _client = Supabase.instance.client;
  
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final response = await _client
          .from('feature_table')
          .select()
          .eq('user_id', _client.auth.currentUser?.id);
      
      return (response as List)
          .map((json) => FeatureModel.fromMap(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch features: $e');
    }
  }
  
  Future<FeatureModel> createFeature(FeatureModel feature) async {
    try {
      final response = await _client
          .from('feature_table')
          .insert(feature.toMap())
          .select()
          .single();
      
      return FeatureModel.fromMap(response);
    } catch (e) {
      throw Exception('Failed to create feature: $e');
    }
  }
}
```

### 4. State Management
```dart
// For Riverpod
final featureServiceProvider = Provider((ref) => FeatureService());

final featuresProvider = FutureProvider<List<FeatureModel>>((ref) async {
  final service = ref.read(featureServiceProvider);
  return service.getFeatures();
});

// For Bloc
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureService _service;
  
  FeatureBloc(this._service) : super(FeatureInitial()) {
    on<LoadFeatures>(_onLoadFeatures);
    on<CreateFeature>(_onCreateFeature);
  }
}
```

### 5. UI Components
```dart
// lib/features/feature/presentation/pages/feature_page.dart
class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature')),
      body: Consumer(
        builder: (context, ref, child) {
          final featuresAsync = ref.watch(featuresProvider);
          
          return featuresAsync.when(
            data: (features) => FeatureList(features: features),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ErrorWidget(error.toString()),
          );
        },
      ),
    );
  }
}
```

### 6. Real-time Subscriptions (if applicable)
```dart
// Real-time updates
StreamSubscription? _subscription;

void _listenToChanges() {
  _subscription = _client
      .from('feature_table')
      .stream(primaryKey: ['id'])
      .eq('user_id', _client.auth.currentUser?.id)
      .listen((data) {
        // Handle real-time updates
      });
}

@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

## Task Breakdown

### Phase 1: Setup & Models
- [ ] Define data models and types
- [ ] Set up database schema
- [ ] Create RLS policies
- [ ] Configure environment variables

### Phase 2: Service Layer
- [ ] Implement Supabase service functions
- [ ] Add error handling
- [ ] Create utility functions
- [ ] Add real-time subscriptions (if needed)

### Phase 3: State Management
- [ ] Set up state management solution
- [ ] Create providers/blocs/controllers
- [ ] Implement data fetching logic
- [ ] Handle loading and error states

### Phase 4: UI Implementation
- [ ] Create main feature widgets
- [ ] Implement navigation
- [ ] Add loading indicators
- [ ] Style with theme

### Phase 5: Testing
- [ ] Unit test service layer
- [ ] Widget test UI components
- [ ] Integration test full flows
- [ ] Test on multiple platforms

## Validation Loops

### Static Analysis
```bash
flutter analyze
dart format --set-exit-if-changed .
```
IF errors: Fix and re-run until clean

### Test Validation
```bash
flutter test
flutter test integration_test/
```
IF tests fail: Fix implementation and re-run

### Build Validation
```bash
flutter build apk --debug
flutter build ios --debug (if on macOS)
```
IF build fails: Fix errors and rebuild

### Manual Testing Checklist
- [ ] Feature works on Android
- [ ] Feature works on iOS (if applicable)
- [ ] Real-time updates work correctly
- [ ] Error states display properly
- [ ] Loading states work correctly
- [ ] Navigation functions properly
- [ ] No performance issues

## Common Patterns & Anti-Patterns

### DO:
- Use const constructors for performance
- Implement proper error handling
- Dispose of resources properly
- Use type-safe operations
- Follow Flutter conventions
- Test on multiple screen sizes
- Handle connectivity issues
- Use proper state management

### DON'T:
- Don't ignore dispose methods
- Don't use dynamic types unnecessarily
- Don't create memory leaks with streams
- Don't skip error handling
- Don't hardcode sensitive data
- Don't ignore platform differences
- Don't skip testing

## Error Handling Pattern
```dart
// Consistent error handling
Future<Result<T>> safeCall<T>(Future<T> Function() operation) async {
  try {
    final result = await operation();
    return Result.success(result);
  } on PostgrestException catch (e) {
    return Result.failure('Database error: ${e.message}');
  } on AuthException catch (e) {
    return Result.failure('Auth error: ${e.message}');
  } catch (e) {
    return Result.failure('Unexpected error: $e');
  }
}
```

## Performance Considerations
- Use const widgets wherever possible
- Implement proper list builders for large datasets
- Optimize image loading and caching
- Use RepaintBoundary for complex widgets
- Monitor memory usage
- Implement proper pagination

## Security Checklist
- [ ] RLS policies are properly configured
- [ ] No sensitive data in client code
- [ ] Proper input validation
- [ ] Secure storage for tokens
- [ ] Certificate pinning (if needed)
- [ ] Biometric auth (if applicable)