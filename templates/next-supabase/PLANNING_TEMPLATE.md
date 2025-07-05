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
- **Backend:** Supabase (Auth, Database, Storage, Functions)
- **Styling:** [Tailwind CSS / CSS Modules / Styled Components]
- **State Management:** [React Context / Zustand / Redux Toolkit]
- **Testing:** Jest + React Testing Library
- **Deployment:** [Vercel / Netlify]

## Supabase Services Used
- **Authentication:** [Email/Password, OAuth providers]
- **Database:** PostgreSQL with Row Level Security
- **Storage:** Supabase Storage (if applicable)
- **Edge Functions:** Serverless functions (if applicable)
- **Real-time:** Live data subscriptions (if applicable)

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
│   ├── supabase/         # Supabase configuration
│   │   ├── client.ts     # Browser client
│   │   ├── server.ts     # Server client
│   │   └── types.ts      # Generated types
│   ├── hooks/            # Custom React hooks
│   └── utils/            # Helper functions
├── services/             # Business logic layer
├── types/                # TypeScript types
└── middleware.ts         # Next.js middleware
```

## Conventions

### Component Structure
- Functional components with TypeScript
- Props interfaces defined above component
- Custom hooks for complex logic
- Separate business logic from UI

### Supabase Patterns
- Use client for browser operations
- Use server client for Server Components
- Generate types from database schema
- Implement proper RLS policies

### State Management
- React Context for auth state
- [Local state / Zustand / Redux] for app state
- React Query/SWR for server state

### Styling Approach
<!-- Choose one and remove others -->
- Tailwind CSS with custom components
- CSS Modules with SCSS
- Styled Components with theme

### Testing Strategy
- Unit tests for utilities and hooks
- Component tests for UI components
- Integration tests for Supabase operations
- E2E tests for critical user flows

## Key Patterns

### Authentication Flow
```typescript
// Client-side auth state
const { user, session } = useAuth();

// Server-side auth check
const supabase = createServerClient();
const { data: { session } } = await supabase.auth.getSession();
```

### Database Operations
```typescript
// Type-safe operations with generated types
const { data, error } = await supabase
  .from('table_name')
  .select('column1, column2')
  .eq('user_id', userId);
```

### Protected Routes
- Middleware checks auth state
- Redirect to login if unauthenticated
- Show loading state during auth check

## Environment Variables
```env
# Public (exposed to client)
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=

# Server-only
SUPABASE_SERVICE_ROLE_KEY=
```

## Security Considerations
- Row Level Security (RLS) policies
- API route authentication
- Environment variable security
- Input validation and sanitization
- Rate limiting implementation

## Performance Optimizations
- Server Components for data fetching
- Client Components only when needed
- Proper caching with React Query/SWR
- Database query optimization
- Image optimization with Next.js

## Development Workflow
1. Feature branch from `main`
2. Implement with tests
3. Run linting and type checking
4. Test Supabase operations locally
5. Deploy to preview environment
6. Merge to main after review

## Deployment
<!-- Customize based on your deployment target -->
- Production: Vercel with Supabase
- Staging: Vercel preview deployments
- Database: Supabase hosted
- Environment variables: Set in Vercel dashboard