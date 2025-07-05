### 🔄 Project Awareness & Context
- **Always read `PLANNING.md`** at the start of a new conversation to understand the project's architecture, goals, style, and constraints.
- **Check `TASK.md`** before starting a new task. If the task isn't listed, add it with a brief description and today's date.
- **Use consistent naming conventions, file structure, and architecture patterns** as described in `PLANNING.md`.
- **Use npm/yarn/pnpm commands** based on the lock file present in the project.

### 🧱 Code Structure & Modularity
- **Never create a file longer than 300 lines of code.** If a file approaches this limit, refactor by splitting it into modules or helper files.
- **Organize code into clearly separated modules**, grouped by feature or responsibility:
  - For React components:
    - `ComponentName.tsx` - Main component file
    - `ComponentName.styles.ts` - Styled components or CSS modules
    - `ComponentName.test.tsx` - Component tests
    - `index.ts` - Export barrel file
  - For Firebase services:
    - `lib/firebase/` - Firebase configuration and services
    - `lib/firebase/auth.ts` - Authentication functions
    - `lib/firebase/firestore.ts` - Firestore operations
    - `lib/firebase/storage.ts` - Storage operations
  - For Next.js API routes:
    - Keep route handlers focused and delegate to service layers
    - Use Firebase Admin SDK in API routes only
- **Use clear, consistent imports** (prefer named imports, use path aliases like `@/components`).
- **Use environment variables** with `.env.local` for Firebase config.

### 🧪 Testing & Reliability
- **Always create tests for new features** using Jest and React Testing Library.
- **After updating any logic**, check whether existing tests need to be updated. If so, do it.
- **Tests should live in:**
  - `__tests__` folders for unit tests
  - `.test.tsx` files alongside components
  - `e2e/` folder for end-to-end tests
- **Include at least:**
  - Component render tests
  - Firebase auth flow tests
  - Firestore operation tests
  - API route tests with mocked Firebase Admin
  - Edge cases and error states

### ✅ Task Completion
- **Mark completed tasks in `TASK.md`** immediately after finishing them.
- **Run these checks before marking complete:**
  - `npm run lint` (ESLint)
  - `npm run type-check` (TypeScript)
  - `npm test` (Jest)
  - `npm run build` (ensure no build errors)
  - Verify Firebase security rules are updated if needed
- Add new sub-tasks or TODOs discovered during development to `TASK.md`.

### 📎 Style & Conventions
- **Use TypeScript** as the primary language (`.ts`, `.tsx` files).
- **Follow ESLint rules** and format with Prettier.
- **Firebase-specific conventions:**
  - Initialize Firebase once in `lib/firebase/config.ts`
  - Use Firebase Admin SDK only in API routes
  - Never expose Firebase service account keys
  - Implement proper error handling for Firebase operations
- **Authentication patterns:**
  - Use Firebase Auth Context for client-side auth state
  - Verify ID tokens in API routes
  - Implement proper session management
- **Firestore conventions:**
  - Define collection names as constants
  - Use TypeScript interfaces for document types
  - Implement proper data validation
  - Use Firestore converters for type safety

### 📚 Documentation & Explainability
- **Update `README.md`** when new features are added, dependencies change, or setup steps are modified.
- **Document Firebase setup:**
  - Required environment variables
  - Security rules configuration
  - Cloud Functions deployment (if used)
- **Comment non-obvious code** and ensure everything is understandable to a mid-level developer.

### 🏗️ Framework-Specific Rules

#### Next.js + Firebase Integration:
- **Use App Router** for new projects (unless explicitly using Pages Router).
- **Firebase client vs admin SDK:**
  - Client SDK: Use in Client Components and browser-side code
  - Admin SDK: Use only in API routes and Server Components
  - Never mix client and admin SDKs in the same file
- **Authentication flow:**
  - Client-side: Firebase Auth with custom React Context
  - Server-side: Verify ID tokens with Admin SDK
  - Use middleware for protecting routes
- **Data fetching patterns:**
  - Real-time data: Use Firestore listeners in Client Components
  - Static data: Fetch with Admin SDK in Server Components
  - Cache Firestore queries appropriately

#### Firebase Security:
- **Always implement Firestore security rules**
- **Use Firebase App Check** for production apps
- **Validate all user inputs** before writing to Firestore
- **Implement rate limiting** for API routes
- **Use environment variables** for all Firebase config
- **Never commit Firebase service account keys**

### 🧠 AI Behavior Rules
- **Never assume missing context. Ask questions if uncertain.**
- **Always verify Firebase setup** before implementing features.
- **Check `package.json` for Firebase SDK versions**.
- **Never expose sensitive Firebase configuration**.
- **Always implement proper error handling** for Firebase operations.
- **Follow Firebase best practices** for performance and security.

### 🚀 Performance & Best Practices
- **Optimize Firebase usage:**
  - Minimize Firestore reads with proper query design
  - Use Firestore composite indexes for complex queries
  - Implement proper caching strategies
  - Use Firebase Storage for media files
- **Bundle optimization:**
  - Lazy load Firebase services
  - Use dynamic imports for Firebase Admin SDK
  - Tree-shake unused Firebase features
- **Real-time considerations:**
  - Properly unsubscribe from Firestore listeners
  - Implement connection state handling
  - Use optimistic updates for better UX

### 🔐 Security Checklist
- [ ] Firebase security rules are properly configured
- [ ] API routes validate authentication tokens
- [ ] Environment variables are properly secured
- [ ] No sensitive data in client-side code
- [ ] Proper CORS configuration for API routes
- [ ] Input validation before Firestore writes
- [ ] Rate limiting on sensitive operations