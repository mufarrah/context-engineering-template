# Project Architecture

<!-- 
TODO: Customize this template for your specific project.
Replace all placeholders with your actual project details.
-->

## Overview
[YOUR PROJECT DESCRIPTION HERE]

## Tech Stack
- **Frontend Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript
- **Backend:** Firebase (Auth, Firestore, Storage, Functions)
- **Styling:** [Tailwind CSS / CSS Modules / Styled Components]
- **State Management:** [React Context / Zustand / Redux Toolkit]
- **Testing:** Jest + React Testing Library
- **Deployment:** [Vercel / Firebase Hosting]

## Firebase Services Used
- **Authentication:** [Email/Password, Google OAuth, etc.]
- **Database:** Cloud Firestore
- **Storage:** Cloud Storage (if applicable)
- **Functions:** Cloud Functions (if applicable)
- **Hosting:** Firebase Hosting (if applicable)
- **Analytics:** Google Analytics (if applicable)

## Project Structure
```
src/
├── app/                    # Next.js app router
│   ├── (auth)/            # Auth group routes
│   ├── (dashboard)/       # Protected routes
│   ├── api/               # API routes
│   └── layout.tsx         # Root layout
├── components/            # Reusable components
│   ├── ui/               # Base UI components
│   └── features/         # Feature-specific components
├── lib/                   # Utilities and configs
│   ├── firebase/         # Firebase configuration
│   │   ├── config.ts     # Firebase initialization
│   │   ├── auth.ts       # Auth utilities
│   │   ├── firestore.ts  # Firestore utilities
│   │   └── admin.ts      # Admin SDK (server only)
│   ├── hooks/            # Custom React hooks
│   └── utils/            # Helper functions
├── contexts/             # React contexts
│   └── AuthContext.tsx   # Firebase auth context
├── types/                # TypeScript types
│   ├── firebase.ts       # Firebase-specific types
│   └── index.ts          # Shared types
└── middleware.ts         # Next.js middleware
```

## Conventions

### Component Structure
- Functional components with TypeScript
- Props interfaces defined above component
- Custom hooks for complex logic
- Separate business logic from UI

### Firebase Patterns
- Initialize Firebase once in `lib/firebase/config.ts`
- Use Firebase Auth Context for auth state
- Firestore converters for type safety
- Proper error handling with try-catch

### State Management
- React Context for auth state
- [Local state / Zustand / Redux] for app state
- Server state with React Query (if applicable)

### Styling Approach
<!-- Choose one and remove others -->
- Tailwind CSS with custom components
- CSS Modules with SCSS
- Styled Components with theme

### Testing Strategy
- Unit tests for utilities and hooks
- Component tests for UI components
- Integration tests for Firebase operations
- E2E tests for critical user flows

## Key Patterns

### Authentication Flow
```typescript
// Client-side auth check
const { user, loading } = useAuth();

// Server-side auth check (API route)
const token = await getAuthToken(request);
const decodedToken = await admin.auth().verifyIdToken(token);
```

### Firestore Operations
```typescript
// Type-safe Firestore operations
const userConverter: FirestoreDataConverter<User> = {
  toFirestore: (user) => ({ ...user }),
  fromFirestore: (snapshot) => snapshot.data() as User
};
```

### Protected Routes
- Middleware checks auth state
- Redirect to login if unauthenticated
- Show loading state during auth check

## Environment Variables
```env
# Public (exposed to client)
NEXT_PUBLIC_FIREBASE_API_KEY=
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=
NEXT_PUBLIC_FIREBASE_PROJECT_ID=
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=
NEXT_PUBLIC_FIREBASE_APP_ID=

# Server-only
FIREBASE_SERVICE_ACCOUNT_KEY=
```

## Security Considerations
- Firestore security rules for data access
- API route authentication
- Environment variable security
- CORS configuration
- Rate limiting implementation

## Performance Optimizations
- Dynamic imports for Firebase services
- Firestore query optimization
- Image optimization with Next.js
- Proper caching strategies
- Bundle size monitoring

## Development Workflow
1. Feature branch from `main`
2. Implement with tests
3. Run linting and type checking
4. Test Firebase operations locally
5. Deploy to staging environment
6. Merge to main after review

## Deployment
<!-- Customize based on your deployment target -->
- Production: Vercel with Firebase backend
- Staging: Vercel preview deployments
- Firebase Functions: Deploy separately
- Environment variables: Set in Vercel dashboard