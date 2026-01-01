# CONFIG.md - Next.js + Supabase Project

## 🚀 Available Commands & Workflows

### 🤖 **Claude Code Commands** (Available in project root)

#### Core Commands
```bash
/analyze-project              # Analyze project structure and patterns
/add-suggestions-to-tasks     # Add analysis suggestions to TASK.md
```

#### PRP Workflow Commands
```bash
/generate-requirements [input.md]   # Transform feature ideas into requirements doc
/generate-prp [requirements.md]     # Generate implementation plan from requirements
/check-prp [prp-path]               # Validate PRP structure and alignment
/execute-prp [prp-path]             # Start Phase 0 implementation
/continue-prp [prp-path]            # Continue phased implementation (Phase 1+)
/check-progress [prp-path]          # Comprehensive progress audit
/ensure-tracking [prp-path]         # Verify documentation before closing context
```

### 📦 **Next.js Development Commands**

#### Project Setup
```bash
# Install dependencies
npm install
# or
yarn install
# or
pnpm install

# Set up environment variables
cp .env.example .env.local
# Edit .env.local with your Supabase credentials
```

#### Development Server
```bash
# Start development server
npm run dev
# or
yarn dev
# or
pnpm dev

# Open in browser: http://localhost:3000
```

#### Build and Deploy
```bash
# Build for production
npm run build
# or
yarn build

# Start production server locally
npm start
# or
yarn start

# Deploy to Vercel
npx vercel
# or
vercel --prod
```

### 🗄️ **Supabase Commands**

#### Database Management
```bash
# Initialize Supabase (if not done)
npx supabase init

# Start local Supabase
npx supabase start

# Generate TypeScript types from database
npx supabase gen types typescript --project-id YOUR_PROJECT_ID > types/supabase.ts

# Apply database migrations
npx supabase db push

# Reset local database
npx supabase db reset
```

#### Authentication Commands
```bash
# Generate auth components (if using Supabase Auth UI)
npm install @supabase/auth-ui-react @supabase/auth-ui-shared

# Test authentication flow
# (Use Supabase dashboard or local auth)
```

### 🧪 **Testing Commands**

#### Unit Testing
```bash
# Run all tests
npm test
# or
yarn test

# Run tests in watch mode
npm run test:watch
# or
yarn test:watch

# Generate coverage report
npm run test:coverage
# or
yarn test:coverage
```

#### E2E Testing (if configured)
```bash
# Run Playwright tests
npx playwright test

# Run Cypress tests
npx cypress open
# or
npx cypress run
```

### 🔧 **Code Quality Commands**

#### Linting and Formatting
```bash
# Run ESLint
npm run lint
# or
yarn lint

# Fix ESLint issues
npm run lint:fix
# or
yarn lint:fix

# Format with Prettier
npm run format
# or
yarn format

# Type checking
npm run type-check
# or
yarn type-check
```

### 🛠️ **Context Engineering Workflow**

#### Complete Feature Development
```bash
# 1. Check current tasks
cat context-engineering/TASK.md

# 2. Create feature description
echo "# Feature: User Dashboard" > dashboard-feature.md
echo "Create user dashboard with profile and settings" >> dashboard-feature.md

# 3. Generate implementation plan
/generate-prp dashboard-feature.md

# 4. Review the generated PRP
cat context-engineering/PRPs/dashboard-feature.md

# 5. Execute implementation
/execute-prp context-engineering/PRPs/dashboard-feature.md

# 6. Test the implementation
npm run dev  # Verify in browser
npm test     # Run unit tests

# 7. Add any discovered tasks
/add-suggestions-to-tasks
```

#### Project Analysis and Optimization
```bash
# Analyze current project structure
/analyze-project

# Check for performance issues
npm run build && npm run analyze  # (if configured)

# Update dependencies
npm update
# or
yarn upgrade
```

### 📱 **Next.js Specific Commands**

#### Page and Component Generation
```bash
# Create new page (App Router)
mkdir -p src/app/dashboard
echo "export default function Dashboard() { return <div>Dashboard</div> }" > src/app/dashboard/page.tsx

# Create new component
mkdir -p src/components/ui
echo "export function Button() { return <button>Click me</button> }" > src/components/ui/Button.tsx
```

#### API Routes
```bash
# Create API route (App Router)
mkdir -p src/app/api/users
echo "export async function GET() { return Response.json({ users: [] }) }" > src/app/api/users/route.ts

# Test API route
curl http://localhost:3000/api/users
```

### 🎨 **Styling Commands**

#### Tailwind CSS (if configured)
```bash
# Install Tailwind CSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Build CSS
npm run build:css  # (if configured)
```

#### CSS Modules
```bash
# Create component with CSS modules
echo ".button { padding: 1rem; }" > src/components/Button.module.css
```

### 🔐 **Environment and Security**

#### Environment Management
```bash
# Copy environment template
cp .env.example .env.local

# Required Supabase environment variables:
# NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
# NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
# SUPABASE_SERVICE_ROLE_KEY=your_service_role_key (for server-side)
```

#### Security Checks
```bash
# Check for security vulnerabilities
npm audit

# Fix security issues
npm audit fix

# Check bundle size
npm run build && npx @next/bundle-analyzer
```

### 📊 **Monitoring and Analytics**

#### Performance Monitoring
```bash
# Analyze bundle size
npm run build
npm run analyze  # (if configured)

# Check lighthouse scores
npx lighthouse http://localhost:3000 --view

# Monitor Core Web Vitals (in production)
# Check Vercel Analytics or Google PageSpeed Insights
```

### 🗃️ **Database Operations**

#### Supabase Database Commands
```bash
# Connect to remote database
npx supabase db remote commit

# Create new migration
npx supabase migration new add_user_profiles

# Apply migrations
npx supabase db push

# Seed database
npx supabase db seed
```

## 🔍 **Available Integrations**

### Supabase Features
- **Authentication**: Email/password, OAuth, magic links
- **Database**: PostgreSQL with real-time subscriptions
- **Storage**: File uploads and management
- **Edge Functions**: Serverless functions
- **Real-time**: Live data synchronization

### Next.js Features
- **App Router**: Modern routing with layouts
- **Server Components**: Reduced bundle size
- **API Routes**: Built-in API endpoints
- **Image Optimization**: Automatic image optimization
- **Static Generation**: ISR and SSG support

## 📚 **Quick Reference**

### Most Common Commands
```bash
# 1. Start development
npm run dev

# 2. Analyze project
/analyze-project

# 3. Generate feature plan
echo "# Feature: Authentication" > auth.md && /generate-prp auth.md

# 4. Implement feature
/execute-prp context-engineering/PRPs/auth.md

# 5. Test and deploy
npm test && npm run build && vercel --prod
```

### File Structure
```
project/
├── .claude/                    # Claude Code commands
├── context-engineering/        # Context Engineering files
├── src/
│   ├── app/                   # Next.js App Router pages
│   ├── components/            # React components
│   ├── lib/                   # Utilities and configurations
│   └── types/                 # TypeScript type definitions
├── public/                    # Static assets
├── .env.local                 # Environment variables
├── next.config.js             # Next.js configuration
└── package.json               # Dependencies and scripts
```

### Essential Environment Variables
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

## 🚨 **Important Notes**

1. **Environment Variables**: Always use `NEXT_PUBLIC_` prefix for client-side variables
2. **Supabase Types**: Regenerate types after database schema changes
3. **Authentication**: Use Supabase Auth helpers for Next.js integration
4. **Real-time**: Subscribe to database changes using Supabase real-time
5. **Security**: Enable Row Level Security (RLS) in Supabase for data protection

This CONFIG.md provides all commands needed for efficient Next.js + Supabase development! 