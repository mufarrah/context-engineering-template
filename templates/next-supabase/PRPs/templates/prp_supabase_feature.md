# PRP: [Feature Name]

## Goal
[One sentence description of what we're building]

## Why
[Business value and user benefit]

## What
[Detailed description of the feature]

## Context

### Technical Stack
- Next.js 14+ (App Router)
- TypeScript
- Supabase (Auth, Database, Storage, Functions)
- [UI Library: Tailwind/MUI/Chakra]
- [State Management: Context/Zustand]
- Testing: Jest + React Testing Library

### Supabase Configuration
```typescript
// Required Supabase services
- Authentication: [methods used]
- Database: [tables and RLS policies needed]
- Storage: [buckets if applicable]
- Edge Functions: [functions if applicable]
```

### Relevant Documentation
- [Supabase Auth Docs](https://supabase.com/docs/guides/auth)
- [Supabase Database Docs](https://supabase.com/docs/guides/database)
- [Next.js Docs](https://nextjs.org/docs)
- Internal patterns: See `lib/supabase/` directory

### Existing Patterns in Codebase
```typescript
// Firebase initialization pattern
// lib/firebase/config.ts
import { initializeApp, getApps } from 'firebase/app';

// Auth context pattern
// contexts/AuthContext.tsx
export const useAuth = () => useContext(AuthContext);

// Firestore converter pattern
// lib/firebase/converters.ts
const converter: FirestoreDataConverter<T> = { ... };
```

### Environment Variables Needed
```env
NEXT_PUBLIC_FIREBASE_API_KEY=
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=
NEXT_PUBLIC_FIREBASE_PROJECT_ID=
# ... other Firebase config
```

## Implementation Blueprint

### 1. Firebase Security Rules
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Add specific rules for this feature
    match /collection/{docId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### 2. Data Models & Types
```typescript
// types/feature.ts
export interface FeatureData {
  id: string;
  userId: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
  // ... other fields
}

// Firestore converter
export const featureConverter: FirestoreDataConverter<FeatureData> = {
  toFirestore: (data) => ({
    ...data,
    updatedAt: serverTimestamp()
  }),
  fromFirestore: (snapshot) => {
    const data = snapshot.data();
    return {
      id: snapshot.id,
      ...data
    } as FeatureData;
  }
};
```

### 3. Firebase Service Layer
```typescript
// lib/firebase/services/featureService.ts
import { 
  collection, 
  query, 
  where, 
  getDocs,
  addDoc,
  updateDoc,
  deleteDoc 
} from 'firebase/firestore';
import { db } from '../config';
import { featureConverter } from '../converters';

export const featureService = {
  async create(data: Omit<FeatureData, 'id'>): Promise<string> {
    try {
      const docRef = await addDoc(
        collection(db, 'features').withConverter(featureConverter),
        data
      );
      return docRef.id;
    } catch (error) {
      console.error('Error creating feature:', error);
      throw error;
    }
  },
  
  async getByUser(userId: string): Promise<FeatureData[]> {
    const q = query(
      collection(db, 'features').withConverter(featureConverter),
      where('userId', '==', userId)
    );
    const snapshot = await getDocs(q);
    return snapshot.docs.map(doc => doc.data());
  }
};
```

### 4. API Routes (with Admin SDK)
```typescript
// app/api/feature/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';
import { initAdmin } from '@/lib/firebase/admin';

initAdmin();

export async function GET(request: NextRequest) {
  try {
    // Verify auth token
    const token = request.headers.get('authorization')?.split('Bearer ')[1];
    if (!token) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }
    
    const decodedToken = await getAuth().verifyIdToken(token);
    const userId = decodedToken.uid;
    
    // Fetch data with Admin SDK
    const db = getFirestore();
    const snapshot = await db
      .collection('features')
      .where('userId', '==', userId)
      .get();
    
    const data = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
    
    return NextResponse.json({ data });
  } catch (error) {
    console.error('API Error:', error);
    return NextResponse.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    );
  }
}
```

### 5. React Components
```typescript
// Client Component with Firebase
'use client';
import { useEffect, useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { featureService } from '@/lib/firebase/services/featureService';
import { onSnapshot, query, where } from 'firebase/firestore';

export function FeatureList() {
  const { user } = useAuth();
  const [features, setFeatures] = useState<FeatureData[]>([]);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    if (!user) return;
    
    // Real-time listener
    const q = query(
      collection(db, 'features'),
      where('userId', '==', user.uid)
    );
    
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const data = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      } as FeatureData));
      setFeatures(data);
      setLoading(false);
    });
    
    return () => unsubscribe();
  }, [user]);
  
  // Component implementation
}
```

### 6. Authentication Flow
```typescript
// For protected pages
import { redirect } from 'next/navigation';
import { getServerSession } from '@/lib/firebase/auth-server';

export default async function ProtectedPage() {
  const session = await getServerSession();
  
  if (!session) {
    redirect('/login');
  }
  
  // Page implementation
}
```

## Task Breakdown

### Phase 1: Firebase Setup
- [ ] Define Firestore data structure
- [ ] Write security rules
- [ ] Create type definitions
- [ ] Set up Firebase converters

### Phase 2: Service Layer
- [ ] Implement Firebase service functions
- [ ] Add error handling
- [ ] Create utility functions
- [ ] Set up Admin SDK for server

### Phase 3: API Implementation
- [ ] Create API routes with auth
- [ ] Implement CRUD operations
- [ ] Add request validation
- [ ] Handle Firebase Admin operations

### Phase 4: UI Components
- [ ] Create React components
- [ ] Implement real-time listeners
- [ ] Add loading states
- [ ] Handle errors gracefully

### Phase 5: Testing
- [ ] Unit test Firebase services
- [ ] Test security rules
- [ ] Component tests with mocked Firebase
- [ ] Integration tests

## Validation Loops

### Syntax & Type Validation
```bash
npm run lint
npm run type-check
npm run format:check
```
IF errors: Fix and re-run until clean

### Firebase Validation
```bash
# Test security rules
npm run firebase:rules:test

# Check Firebase setup
firebase projects:list
firebase apps:list
```
IF errors: Fix configuration

### Test Validation
```bash
npm test
npm test -- --coverage
```
IF tests fail: Fix implementation and re-run

### Build Validation
```bash
npm run build
npm run start
```
IF build fails: Fix errors and rebuild

### Manual Testing Checklist
- [ ] Authentication flow works
- [ ] Firestore operations succeed
- [ ] Real-time updates work
- [ ] Error states display correctly
- [ ] Security rules prevent unauthorized access
- [ ] Performance is acceptable

## Common Patterns & Anti-Patterns

### DO:
- Initialize Firebase once and reuse
- Use Firestore converters for type safety
- Implement proper error boundaries
- Unsubscribe from real-time listeners
- Use Firebase Admin SDK in API routes only
- Cache Firestore queries when appropriate
- Implement optimistic updates
- Handle offline state

### DON'T:
- Don't expose Firebase Admin credentials
- Don't mix client and admin SDKs
- Don't ignore Firebase errors
- Don't create memory leaks with listeners
- Don't bypass security rules
- Don't make unnecessary Firestore reads
- Don't store sensitive data in client

## Error Handling Pattern
```typescript
// Consistent Firebase error handling
try {
  const result = await firebaseOperation();
  return { data: result, error: null };
} catch (error) {
  if (error instanceof FirebaseError) {
    console.error(`Firebase error: ${error.code}`, error);
    return { 
      data: null, 
      error: getUserFriendlyError(error.code) 
    };
  }
  return { data: null, error: 'An unexpected error occurred' };
}
```

## Performance Considerations
- Use Firestore composite indexes
- Implement pagination for large collections
- Cache frequently accessed data
- Use Firebase Storage for media files
- Optimize bundle with dynamic imports
- Monitor Firebase usage and costs

## Security Checklist
- [ ] Firestore security rules are restrictive
- [ ] API routes verify auth tokens
- [ ] No sensitive data in client code
- [ ] Environment variables are secure
- [ ] Firebase App Check enabled (production)
- [ ] Rate limiting implemented
- [ ] Input validation before Firestore writes