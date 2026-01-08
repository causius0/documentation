# Git Workflow & Branching Strategy

## Core Principle

**NEVER merge directly to main**. Always branch, test extensively, then merge.

## Branch Strategy

```
main (production-ready, protected)
  ├── feature/user-authentication
  ├── feature/payment-integration
  ├── fix/database-connection-timeout
  └── security/fix-sql-injection-vulnerability
```

### Branch Naming Convention

```bash
feature/<description>    # New features
fix/<description>        # Bug fixes
security/<description>   # Security updates
refactor/<description>   # Code refactoring
docs/<description>       # Documentation updates
test/<description>       # Testing improvements
```

### Workflow Steps

```
┌─────────────────────────────────────────────────────────┐
│ 1. CREATE BRANCH                                        │
│    git checkout -b feature/new-feature                  │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 2. DEVELOP & COMMIT                                     │
│    - Make changes                                       │
│    - Commit frequently with clear messages              │
│    - Keep commits focused and atomic                    │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 3. TEST EXTENSIVELY                                     │
│    - Run all manual tests                               │
│    - Run automated tests (if any)                       │
│    - Test edge cases                                    │
│    - Run security tests (see security-testing.md)       │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 4. SECURITY AUDIT                                       │
│    - Run hacker agent (attempt to break feature)        │
│    - Fix any vulnerabilities found                      │
│    - Document security measures taken                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 5. PUSH & CREATE PR                                     │
│    git push -u origin feature/new-feature               │
│    gh pr create --title "..." --body "..."              │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 6. FINAL REVIEW                                         │
│    - Review all changes one more time                   │
│    - Check comments are comprehensive                   │
│    - Verify tests pass                                  │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 7. MERGE TO MAIN                                        │
│    - Squash commits (optional)                          │
│    - Delete feature branch after merge                  │
└─────────────────────────────────────────────────────────┘
```

## Pre-Merge Checklist

Every branch must pass this checklist before merging:

```markdown
## Testing
- [ ] All manual tests performed and passed
- [ ] Tested on actual deployment environment (render.com preview)
- [ ] Edge cases covered
- [ ] Error scenarios tested

## Security
- [ ] Hacker agent ran (attempted to break feature)
- [ ] All identified vulnerabilities fixed
- [ ] Input validation added
- [ ] Authentication/authorization checked
- [ ] No secrets in code
- [ ] Environment variables documented in .env.example

## Code Quality
- [ ] Every function and variable documented
- [ ] Comments explain what, why, and how
- [ ] ASCII diagrams added for complex workflows
- [ ] No console.logs or debug code left in
- [ ] TypeScript types are comprehensive (no `any`)
- [ ] Linting passes (npm run lint)
- [ ] Build succeeds (npm run build)

## Documentation
- [ ] README updated if needed
- [ ] CHANGELOG updated with changes
- [ ] AGENTS.md updated if workflow changed
- [ ] All new environment variables in .env.example
```

## Commit Message Format

Use conventional commits:

```
<type>: <short description>

<detailed explanation if needed>

<breaking changes if any>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `security`: Security improvement
- `refactor`: Code refactoring
- `docs`: Documentation
- `test`: Testing updates
- `chore`: Maintenance

**Examples:**

```bash
feat: add user authentication with JWT

- Implemented login/register endpoints
- Added JWT token generation and validation
- Created auth middleware for protected routes
- Tested with hacker agent - no vulnerabilities found

Security measures:
- Password hashing with bcrypt (12 rounds)
- Rate limiting on auth endpoints
- JWT expiration set to 1 hour
```

```bash
security: fix SQL injection vulnerability in user search

- Switched from string concatenation to parameterized queries
- Added input sanitization
- Tested with various injection attempts - all blocked

Discovered by: Hacker agent during security audit
```

## AI Agent Workflow

### When Starting New Work

```bash
# 1. Ensure we're on main and up to date
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/descriptive-name

# 3. Make changes, test extensively

# 4. Commit with clear messages
git add .
git commit -m "feat: clear description"

# 5. Push and create PR
git push -u origin feature/descriptive-name
gh pr create --title "Feature: Description" --body "..."
```

### During Development

```bash
# Commit frequently with atomic changes
git add specific-file.ts
git commit -m "feat: add user validation logic"

git add another-file.ts
git commit -m "feat: add error handling for user validation"
```

### Before Merging

```bash
# Make sure everything is pushed
git push

# Run final checks
npm run lint
npm run build
npm test  # if tests exist

# Run security audit (see security-testing.md)
# Fix any issues found

# Create PR with comprehensive description
gh pr create
```

## Merge Strategies

### Squash Merge (Preferred)
- Combines all commits into one
- Cleaner main branch history
- Good for feature branches with many small commits

### Regular Merge
- Preserves all individual commits
- Use when commit history is important
- Good for well-organized commits

### Rebase and Merge
- Linear history
- Use when you want clean history but preserve commits
- Requires more Git knowledge

**Default: Squash merge** unless there's a reason to preserve commit history.

## Production Deployment Considerations

### ⚠️ CRITICAL: Main Branch = Production

**When pushing to main, the code will be deployed to production.** You must update the code to consider this BEFORE merging:

#### Pre-Merge Production Checklist

```markdown
## Environment & Configuration
- [ ] Review all environment variables for production values
- [ ] Remove any development/debug flags
- [ ] Verify DATABASE_URL points to production database
- [ ] Check API endpoints use production URLs
- [ ] Ensure CORS settings allow production domain
- [ ] Verify authentication keys/secrets are production-ready

## Code Changes Required
- [ ] Remove/disable debug logging
- [ ] Remove test routes/endpoints
- [ ] Set NODE_ENV=production (or equivalent)
- [ ] Verify error messages don't leak sensitive info
- [ ] Check rate limiting is enabled and appropriate
- [ ] Ensure proper error handling for production

## Database & Data
- [ ] Database migrations reviewed and tested
- [ ] Backup strategy confirmed before schema changes
- [ ] Seed data removed (only for development)
- [ ] Connection pooling configured for production load
- [ ] Index requirements reviewed for performance

## Performance & Scalability
- [ ] Asset bundling/optimization enabled
- [ ] Caching strategy configured (Redis/CDN)
- [ ] Static asset compression enabled
- [ ] Database queries optimized
- [ ] API rate limiting configured
- [ ] Memory limits reviewed

## Monitoring & Observability
- [ ] Error tracking configured (Sentry, etc.)
- [ ] Logging set to appropriate level (warn/error in prod)
- [ ] Performance monitoring enabled
- [ ] Uptime monitoring configured
- [ ] Health check endpoints functional

## Security Hardening
- [ ] HTTPS enforced everywhere
- [ ] Security headers configured (CSP, HSTS, etc.)
- [ ] Dependencies updated and audited (npm audit)
- [ ] Secrets not in code (use environment variables)
- [ ] Authentication/authorization fully configured
- [ ] Input validation on all endpoints

## Rollback Preparedness
- [ ] Previous version tagged/accessible
- [ ] Database rollback plan documented
- [ ] Feature flags ready if needed
- [ ] Deployment window considered (avoid peak traffic if risky)
```

#### Common Production Mistakes to Avoid

1. **Leaving debug code in production**
   ```javascript
   // ❌ BAD - Don't merge to main
   console.log("User data:", sensitiveUserData);
   console.debug("API response: ", response);

   // ✅ GOOD - Use proper logging
   logger.info("User action completed", { userId: user.id });
   ```

2. **Development endpoints exposed**
   ```javascript
   // ❌ BAD - Remove before merging to main
   app.get('/debug/all-users', async (req, res) => {
     const users = await db.query('SELECT * FROM users');
     res.json(users);
   });

   // ✅ GOOD - Admin only, authenticated, with proper authorization
   app.get('/admin/users',
     authenticate,
     authorize('admin'),
     async (req, res) => {
       const users = await userService.getAllUsers();
       res.json(users);
     }
   );
   ```

3. **Wrong environment variables**
   ```javascript
   // ❌ BAD - Hardcoded or wrong environment
   const API_URL = 'http://localhost:3000/api';
   const DB_HOST = '127.0.0.1';

   // ✅ GOOD - Environment-specific
   const API_URL = process.env.API_URL;
   const DB_HOST = process.env.DATABASE_URL;
   ```

4. **No error handling in production**
   ```javascript
   // ❌ BAD - Crashes in production
   app.get('/api/data', async (req, res) => {
     const data = await fetchData();
     res.json(data);
   });

   // ✅ GOOD - Graceful error handling
   app.get('/api/data', async (req, res) => {
     try {
       const data = await fetchData();
       res.json(data);
     } catch (error) {
       logger.error('Failed to fetch data', { error: error.message });
       res.status(500).json({ error: 'Internal server error' });
     }
   });
   ```

#### Production Deployment Flow

```
┌─────────────────────────────────────────────────────────┐
│ BEFORE MERGING TO MAIN                                  │
└─────────────────────────────────────────────────────────┘
                         ↓
        Review all items in the Pre-Merge Production Checklist
                         ↓
┌─────────────────────────────────────────────────────────┐
│ UPDATE CODE FOR PRODUCTION                              │
│ • Remove debug code                                     │
│ • Update environment variables                          │
│ • Configure production logging                          │
│ • Enable security features                              │
│ • Test in staging/preview environment                   │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ MERGE TO MAIN (triggers production deployment)          │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ POST-DEPLOYMENT VERIFICATION                            │
│ • Check application health endpoint                     │
│ • Monitor error logs for 15 minutes                     │
│ • Verify critical functionality                         │
│ • Be ready to rollback if issues detected               │
└─────────────────────────────────────────────────────────┘
```

#### Environment Variable Template

Maintain a `.env.production.example` file to document required production variables:

```bash
# Application
NODE_ENV=production
PORT=3000
API_URL=https://your-domain.com

# Database
DATABASE_URL=postgresql://user:pass@host:5432/dbname
DB_POOL_MIN=2
DB_POOL_MAX=10

# Security
JWT_SECRET=your-super-secret-key
JWT_EXPIRATION=1h
SESSION_SECRET=another-secret-key

# External Services
REDIS_URL=redis://user:pass@host:6379
SENDGRID_API_KEY=your-api-key

# Monitoring
SENTRY_DSN=https://your-sentry-dsn
LOG_LEVEL=warn  # debug, info, warn, error

# Features
FEATURE_NEW_UI=false
FEATURE_BETA_FUNCTIONALITY=false
```

#### Automatic Deployment Considerations

If your repository has CI/CD configured (GitHub Actions, Render, etc.):

- **Merging to main triggers automatic production deployment**
- No manual approval step in most cases
- You must be 100% certain code is production-ready before merging
- Test in preview/staging environments first
- Use feature flags for incomplete functionality

**Remember: Once you merge to main, the code goes live immediately. There's no "undo" button that prevents user impact.**

## Branch Protection Rules (for GitHub)

Recommended settings for `main` branch:

```yaml
- Require pull request before merging
- Require approvals: 0 (solo developer, but forces PR process)
- Require status checks to pass
- Require branches to be up to date before merging
- Do not allow bypassing the above settings
```

## Long-Running Branches

Avoid long-running feature branches:
- Merge to main frequently (daily if possible)
- Break large features into smaller, mergeable chunks
- Use feature flags if you need to deploy partial features

## Handling Conflicts

```bash
# Update your branch with latest main
git checkout feature/your-feature
git fetch origin
git merge origin/main

# Resolve conflicts in your editor
# Test thoroughly after resolving

git add .
git commit -m "merge: resolve conflicts with main"
git push
```

## Emergency Hotfixes

For critical production bugs:

```bash
# Create hotfix branch from main
git checkout main
git pull
git checkout -b fix/critical-bug

# Fix the issue
# Test extensively
# Run security check

# Fast-track merge (but still create PR for documentation)
git push -u origin fix/critical-bug
gh pr create --title "HOTFIX: Critical bug description"

# Merge immediately after creation
gh pr merge fix/critical-bug --squash
```

## AI Agent Instructions

1. **Always create a branch** - Never work directly on main
2. **Test before pushing** - Run all checks locally first
3. **Security audit required** - Every branch needs security review
4. **Comprehensive PR descriptions** - Include what, why, how, and test results
5. **Clean up after merge** - Delete branch after successful merge
6. **Document everything** - Update CHANGELOG, README, AGENTS.md as needed
