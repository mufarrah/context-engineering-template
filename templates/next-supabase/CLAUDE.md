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
  - For Supabase services:
    - `lib/supabase/` - Supabase configuration and utilities
    - `lib/supabase/client.ts` - Client initialization
    - `lib/supabase/server.ts` - Server client setup
    - `lib/supabase/types.ts` - Generated database types
  - For database operations:
    - `services/` - Business logic and database queries
    - `hooks/` - Custom React hooks for data fetching
- **Use clear, consistent imports** (prefer named imports, use path aliases like `@/components`).
- **Use environment variables** with `.env.local` for Supabase config.

### 🧪 Testing & Reliability
- **Always create tests for new features** using Jest and React Testing Library.
- **After updating any logic**, check whether existing tests need to be updated. If so, do it.
- **Tests should live in:**
  - `__tests__` folders for unit tests
  - `.test.tsx` files alongside components
  - `e2e/` folder for end-to-end tests
- **Include at least:**
  - Component render tests
  - Supabase auth flow tests
  - Database operation tests
  - API route tests
  - RLS (Row Level Security) policy tests
  - Edge cases and error states

### ✅ Task Completion
- **Mark completed tasks in `TASK.md`** immediately after finishing them.
- **Run these checks before marking complete:**
  - `npm run lint` (ESLint)
  - `npm run type-check` (TypeScript)
  - `npm test` (Jest)
  - `npm run build` (ensure no build errors)
  - Verify RLS policies are properly configured
  - Test database migrations if applicable
- Add new sub-tasks or TODOs discovered during development to `TASK.md`.

### 📎 Style & Conventions
- **Use TypeScript** as the primary language (`.ts`, `.tsx` files).
- **Follow ESLint rules** and format with Prettier.
- **Supabase-specific conventions:**
  - Use Supabase client for browser-side operations
  - Use Supabase server client for Server Components
  - Always handle Supabase errors properly
  - Use generated types from database schema
- **Authentication patterns:**
  - Server-side auth checks for pages
  - Client-side auth state with hooks
  - Middleware for route protection
- **Database conventions:**
  - Use TypeScript types generated from schema
  - Implement proper error handling
  - Use database functions for complex operations
  - Follow RLS best practices

### 📚 Documentation & Explainability
- **Update `README.md`** when new features are added, dependencies change, or setup steps are modified.
- **Document Supabase setup:**
  - Required environment variables
  - Database schema and migrations
  - RLS policies configuration
  - Edge Functions (if used)
- **Comment non-obvious code** and ensure everything is understandable to a mid-level developer.

### 🏗️ Framework-Specific Rules

#### Next.js + Supabase Integration:
- **Use App Router** for new projects (unless explicitly using Pages Router).
- **Supabase client usage:**
  - Browser client: For Client Components
  - Server client: For Server Components and Route Handlers
  - Service role client: Only when bypassing RLS (carefully!)
- **Authentication flow:**
  - Use Supabase Auth Helpers for Next.js
  - Server-side session validation
  - Client-side auth state management
  - Proper cookie handling
- **Data fetching patterns:**
  - Server Components: Direct database queries
  - Client Components: React Query/SWR with Supabase
  - Real-time: Supabase Realtime subscriptions
  - Optimistic updates for better UX

#### Supabase Best Practices:
- **Always use Row Level Security (RLS)**
- **Generate TypeScript types** from database schema
- **Use database functions** for complex operations
- **Implement proper error handling** for all operations
- **Monitor database performance** and query efficiency
- **Use Supabase Storage** for file uploads

### 🧠 AI Behavior Rules
- **Never assume missing context. Ask questions if uncertain.**
- **Always verify Supabase setup** before implementing features.
- **Check for existing RLS policies** before database operations.
- **Never expose service role key** in client-side code.
- **Always use generated types** for type safety.
- **Follow Supabase best practices** for performance and security.

### 🚀 Performance & Best Practices
- **Optimize database queries:**
  - Use proper indexes
  - Implement pagination
  - Use select() to limit returned columns
  - Batch operations when possible
- **Caching strategies:**
  - Use React Query or SWR for client-side caching
  - Implement proper cache invalidation
  - Use Supabase's built-in caching
- **Real-time considerations:**
  - Properly unsubscribe from channels
  - Implement connection state handling
  - Use presence for collaborative features

### 🔐 Security Checklist
- [ ] RLS policies are properly configured
- [ ] API routes validate authentication
- [ ] Environment variables are secured
- [ ] No service role key in client code
- [ ] Database functions have proper permissions
- [ ] Input validation before database writes
- [ ] Rate limiting on sensitive operations

### 📊 Database Management
- **Migrations:**
  - Use Supabase CLI for migrations
  - Version control migration files
  - Test migrations locally first
- **Type Generation:**
  ```bash
  npx supabase gen types typescript --local > lib/supabase/types.ts
  ```
- **RLS Policy Patterns:**
  ```sql
  -- Enable RLS
  ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;
  
  -- Common policies
  CREATE POLICY "Users can view own data" ON table_name
    FOR SELECT USING (auth.uid() = user_id);
  ```