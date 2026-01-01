# CONFIG.md - Next.js + Firebase Project

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
# Edit .env.local with your Firebase configuration
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

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### 🔥 **Firebase Commands**

#### Firebase Setup
```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init

# Select services: Hosting, Firestore, Functions, Storage
```

#### Firestore Database
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Firestore indexes
firebase deploy --only firestore:indexes

# Backup Firestore data
gcloud firestore export gs://[BUCKET_NAME]

# Import Firestore data
gcloud firestore import gs://[BUCKET_NAME]/[EXPORT_FOLDER]
```

#### Firebase Functions
```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:functionName

# View function logs
firebase functions:log

# Delete function
firebase functions:delete functionName
```

#### Firebase Authentication
```bash
# Deploy auth configuration
firebase deploy --only auth

# Test authentication locally
firebase emulators:start --only auth
```

#### Firebase Hosting
```bash
# Deploy to hosting
firebase deploy --only hosting

# Preview hosting changes
firebase hosting:channel:deploy preview_name

# Delete preview channel
firebase hosting:channel:delete preview_name
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

#### Firebase Emulator Testing
```bash
# Start Firebase emulators
firebase emulators:start

# Start specific emulators
firebase emulators:start --only firestore,auth

# Run tests against emulators
npm run test:emulator
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
echo "# Feature: User Authentication" > auth-feature.md
echo "Implement Firebase Auth with email/password and Google sign-in" >> auth-feature.md

# 3. Generate implementation plan
/generate-prp auth-feature.md

# 4. Review the generated PRP
cat context-engineering/PRPs/auth-feature.md

# 5. Execute implementation
/execute-prp context-engineering/PRPs/auth-feature.md

# 6. Test the implementation
npm run dev  # Verify in browser
firebase emulators:start  # Test with emulators
npm test     # Run unit tests

# 7. Deploy to Firebase
firebase deploy

# 8. Add any discovered tasks
/add-suggestions-to-tasks
```

#### Project Analysis and Optimization
```bash
# Analyze current project structure
/analyze-project

# Check Firebase project status
firebase projects:list

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

# Required Firebase environment variables:
# NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
# NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_auth_domain
# NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
# NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_storage_bucket
# NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
# NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
# FIREBASE_ADMIN_SDK_KEY=your_admin_sdk_key (for server-side)
```

#### Security Rules
```bash
# Test Firestore security rules
firebase emulators:start --only firestore
npm run test:security-rules

# Deploy security rules
firebase deploy --only firestore:rules

# Test Storage security rules
firebase deploy --only storage
```

### 📊 **Monitoring and Analytics**

#### Firebase Analytics
```bash
# View Firebase Analytics
# Check Firebase Console -> Analytics

# Enable Analytics in code
# Add to firebase config: measurementId
```

#### Performance Monitoring
```bash
# Analyze bundle size
npm run build
npm run analyze  # (if configured)

# Check lighthouse scores
npx lighthouse http://localhost:3000 --view

# Firebase Performance Monitoring
# Enable in Firebase Console -> Performance
```

### 🗃️ **Database Operations**

#### Firestore Operations
```bash
# Create Firestore indexes
# Edit firestore.indexes.json and run:
firebase deploy --only firestore:indexes

# Backup Firestore
gcloud firestore export gs://your-bucket/backup-folder

# Import data to Firestore
gcloud firestore import gs://your-bucket/backup-folder
```

#### Firebase Storage
```bash
# Deploy storage rules
firebase deploy --only storage

# Upload files programmatically
# Use Firebase Admin SDK or client SDK
```

## 🔍 **Available Integrations**

### Firebase Features
- **Authentication**: Email/password, social providers, phone
- **Firestore**: NoSQL document database with real-time sync
- **Storage**: File uploads and management
- **Functions**: Serverless cloud functions
- **Hosting**: Fast and secure web hosting
- **Analytics**: User behavior tracking
- **Performance**: App performance monitoring

### Next.js Features
- **App Router**: Modern routing with layouts
- **Server Components**: Reduced bundle size
- **API Routes**: Built-in API endpoints
- **Image Optimization**: Automatic image optimization
- **Static Generation**: ISR and SSG support

## 📚 **Quick Reference**

### Most Common Commands
```bash
# 1. Start development with emulators
firebase emulators:start & npm run dev

# 2. Analyze project
/analyze-project

# 3. Generate feature plan
echo "# Feature: Real-time Chat" > chat.md && /generate-prp chat.md

# 4. Implement feature
/execute-prp context-engineering/PRPs/chat.md

# 5. Test and deploy
npm test && npm run build && firebase deploy
```

### File Structure
```
project/
├── .claude/                    # Claude Code commands
├── context-engineering/        # Context Engineering files
├── src/
│   ├── app/                   # Next.js App Router pages
│   ├── components/            # React components
│   ├── lib/                   # Utilities and Firebase config
│   └── types/                 # TypeScript type definitions
├── public/                    # Static assets
├── functions/                 # Firebase Cloud Functions
├── firestore.rules            # Firestore security rules
├── storage.rules              # Storage security rules
├── firebase.json              # Firebase configuration
├── .env.local                 # Environment variables
└── package.json               # Dependencies and scripts
```

### Essential Environment Variables
```env
NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project_id.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_project_id.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id
FIREBASE_ADMIN_SDK_KEY=your_service_account_key
```

## 🚨 **Important Notes**

1. **Environment Variables**: Always use `NEXT_PUBLIC_` prefix for client-side variables
2. **Security Rules**: Test Firestore and Storage rules thoroughly
3. **Functions**: Use Firebase Functions for server-side logic
4. **Real-time**: Use Firestore real-time listeners for live updates
5. **Analytics**: Enable Firebase Analytics for user insights
6. **Emulators**: Use Firebase emulators for local development and testing

This CONFIG.md provides all commands needed for efficient Next.js + Firebase development! 