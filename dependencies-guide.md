# Dependencies Guide

## Philosophy

**Quality over quantity.** Every dependency adds:
- Bundle size (slower downloads)
- Security risk (more attack surface)
- Maintenance burden (updates, breaking changes)
- Complexity (more to understand)

Only add dependencies that provide significant value.

## Decision Framework

Before adding a dependency, ask:

```
┌────────────────────────────────────────┐
│ Can I build this myself in <1 hour?    │
└───────────┬────────────────────────────┘
            │
            ├─► Yes ─► Build it yourself
            │
            └─► No ─► Continue ↓

┌────────────────────────────────────────┐
│ Is this a core feature of the app?     │
└───────────┬────────────────────────────┘
            │
            ├─► Yes ─► Build it yourself
            │           (to maintain control)
            │
            └─► No ─► Continue ↓

┌────────────────────────────────────────┐
│ Is there a well-maintained library?    │
└───────────┬────────────────────────────┘
            │
            ├─► Yes ─► Check criteria ↓
            │
            └─► No ─► Build it yourself

┌────────────────────────────────────────┐
│ Library Quality Checklist:             │
│ - Active maintenance (updated <6mo)    │
│ - Good documentation                   │
│ - High test coverage                   │
│ - Reasonable bundle size               │
│ - Few dependencies itself              │
│ - TypeScript support                   │
│ - No known security issues             │
└───────────┬────────────────────────────┘
            │
            ├─► All pass ─► Use the library
            │
            └─► Some fail ─► Consider building it
```

## Recommended Dependencies

### Essential (Almost Always Use)

**TypeScript**
```bash
npm install -D typescript @types/node
```
Why: Type safety catches errors before runtime, great for learning

**React** (for frontends)
```bash
npm install react react-dom
npm install -D @types/react @types/react-dom
```
Why: Industry standard, huge ecosystem, transferable skills

**Tailwind CSS** (for styling)
```bash
npm install -D tailwindcss postcss autoprefixer
```
Why: Utility-first, no naming conflicts, faster than writing custom CSS

**Vite** (for build tooling)
```bash
npm create vite@latest
```
Why: Fast HMR, modern, better than Create React App

### Backend Essentials

**Express** (API framework)
```bash
npm install express
npm install -D @types/express
```
Why: Simple, well-documented, huge community

**Fastify** (faster alternative to Express)
```bash
npm install fastify
```
Why: Better performance, modern, excellent TypeScript support

**Prisma** (database ORM)
```bash
npm install prisma @prisma/client
npm install -D prisma
```
Why: Type-safe queries, automatic migrations, great DX

**Zod** (validation)
```bash
npm install zod
```
Why: TypeScript-first, runtime validation, composable schemas

**bcrypt** (password hashing)
```bash
npm install bcrypt
npm install -D @types/bcrypt
```
Why: Industry standard, secure, simple API

**jsonwebtoken** (JWT tokens)
```bash
npm install jsonwebtoken
npm install -D @types/jsonwebtoken
```
Why: Standard auth solution, widely used

### Security

**helmet** (security headers)
```bash
npm install helmet
```
Why: Sets security headers automatically, prevents common attacks

**express-rate-limit** (rate limiting)
```bash
npm install express-rate-limit
```
Why: Prevents brute force, simple to configure

**cors** (CORS handling)
```bash
npm install cors
npm install -D @types/cors
```
Why: Handles CORS properly, configurable

### Quality Tools

**ESLint** (linting)
```bash
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
```
Why: Catches errors, enforces style, teaches best practices

**Prettier** (formatting)
```bash
npm install -D prettier
```
Why: Consistent formatting, no debates, auto-fix

**Vitest** (testing)
```bash
npm install -D vitest
```
Why: Fast, modern, great TypeScript support

### Utilities (Use Sparingly)

**date-fns** (date manipulation)
```bash
npm install date-fns
```
Why: Lightweight, tree-shakeable (only import what you need)
Alternative: Native Date API is often sufficient

**lodash-es** (utilities)
```bash
npm install lodash-es
npm install -D @types/lodash-es
```
Why: Tree-shakeable, well-tested utilities
⚠️ Warning: Only import specific functions, not the whole library

**axios** (HTTP client)
```bash
npm install axios
```
Why: Better error handling than fetch, interceptors, timeouts
Alternative: Native fetch is often sufficient

## Dependencies to AVOID

### ❌ Moment.js
**Don't use:** Outdated, huge bundle size, mutable API
**Use instead:** date-fns or native Intl API

```typescript
// ❌ Bad - moment.js (huge bundle)
import moment from 'moment';
const date = moment().format('YYYY-MM-DD');

// ✅ Good - date-fns (lightweight)
import { format } from 'date-fns';
const date = format(new Date(), 'yyyy-MM-dd');

// ✅ Best - native (no dependency)
const date = new Date().toISOString().split('T')[0];
```

### ❌ Lodash (full package)
**Don't use:** Import whole library
**Use instead:** Import specific functions

```typescript
// ❌ Bad - imports entire lodash
import _ from 'lodash';
const unique = _.uniq(array);

// ✅ Good - imports only what's needed
import { uniq } from 'lodash-es';
const unique = uniq(array);

// ✅ Best - native (no dependency)
const unique = [...new Set(array)];
```

### ❌ jQuery
**Don't use:** Outdated, React handles DOM
**Use instead:** React state and refs

```typescript
// ❌ Bad - jQuery with React
$('#button').on('click', () => { ... });

// ✅ Good - React way
<button onClick={() => { ... }}>Click</button>
```

### ❌ uuid (for simple cases)
**Don't use:** When crypto.randomUUID() works
**Use instead:** Native crypto API (Node 16.7+, all modern browsers)

```typescript
// ❌ Unnecessary dependency
import { v4 as uuidv4 } from 'uuid';
const id = uuidv4();

// ✅ Native (no dependency)
const id = crypto.randomUUID();
```

## Dependency Hygiene

### Always Lock Dependencies

```json
{
  "dependencies": {
    "express": "4.18.2",      // ✅ Locked version
    "react": "^18.2.0"        // ❌ May update (breaking changes)
  }
}
```

**Prefer exact versions** to prevent unexpected breaking changes:
```bash
npm install --save-exact express
# Or set in .npmrc
echo "save-exact=true" > .npmrc
```

### Regular Maintenance

```bash
# Check for outdated packages
npm outdated

# Check for security vulnerabilities
npm audit

# Fix auto-fixable vulnerabilities
npm audit fix

# Update packages (carefully)
npm update

# Interactive update with version selection
npx npm-check-updates -i
```

### Before Every Merge

```bash
# Must pass before merging
npm audit --audit-level=high

# If vulnerabilities found:
# 1. Check if there's a fix available
npm audit fix

# 2. If no fix, check if it affects your code
npm audit

# 3. Document why it's acceptable (if it is)
# 4. Create issue to revisit later
```

### Bundle Size Monitoring

Use bundlephobia.com to check package sizes before installing:

```bash
# Example: Check axios size
# Visit: https://bundlephobia.com/package/axios
```

Or use npm:
```bash
npx bundle-phobia axios
```

## Monorepo Dependencies

### Shared Dependencies

Use workspaces to share common dependencies:

```json
// Root package.json
{
  "workspaces": [
    "packages/*"
  ],
  "devDependencies": {
    "typescript": "^5.0.0",    // Shared across all packages
    "prettier": "^3.0.0",
    "eslint": "^8.0.0"
  }
}
```

### Package-Specific Dependencies

Only install where needed:

```bash
# Install only in specific package
pnpm add express --filter backend
pnpm add react --filter frontend
```

## Security Best Practices

### 1. Review Before Installing

```bash
# Check package details
npm view express

# Check recent activity
npm view express time

# Check maintainers
npm view express maintainers

# Check dependencies
npm view express dependencies
```

### 2. Verify Authenticity

⚠️ Watch for typosquatting:
```bash
# ❌ Typo - might be malicious
npm install expres

# ✅ Correct
npm install express

# ❌ Suspicious - random suffix
npm install react-helper-utils-v2

# ✅ Official packages usually have clean names
npm install react
```

### 3. Check npm Score

Visit npmjs.com and check:
- Popularity
- Quality (tests, README, etc.)
- Maintenance (last update, issue response)

### 4. Audit Regularly

```bash
# Weekly: Check for vulnerabilities
npm audit

# Before deploy: Ensure no high/critical
npm audit --audit-level=high
```

## When You've Added Too Many Dependencies

Signs you might have too many:

- `node_modules` is >500MB
- `npm install` takes >2 minutes
- Bundle size >500KB (before gzip)
- Don't know what half the dependencies do

**Audit process:**

```bash
# 1. List all dependencies
npm list --depth=0

# 2. For each, ask: "Do we actually use this?"
npm ls <package-name>

# 3. Remove unused
npm uninstall <package-name>

# 4. Check what depends on what
npm ls

# 5. Look for opportunities to use native features
# Example: Replace axios with fetch
# Example: Replace lodash with native methods
```

## AI Agent Instructions

When adding dependencies:

1. **Check if native alternative exists** - Use built-in features first
2. **Explain why the dependency is needed** - Document the decision
3. **Comment on the choice** - What it does, why this library
4. **Check bundle size** - Use bundlephobia.com
5. **Verify maintenance** - Last updated <6 months ago
6. **Lock the version** - Use exact versions, not ranges
7. **Document in README** - List major dependencies and why

### Adding Dependency Template

```typescript
/**
 * DEPENDENCY ADDED: zod
 *
 * What: Runtime type validation library
 * Why: Need to validate API requests and ensure type safety at runtime
 * Alternatives considered:
 * - Joi: Less TypeScript-friendly
 * - Yup: Older, less modern API
 * - Manual validation: Too error-prone, lots of boilerplate
 *
 * Bundle size: 13.5KB (minified + gzipped)
 * Last updated: 2 weeks ago
 * Security: No known vulnerabilities
 */
import { z } from 'zod';
```

## Dependency Checklist

Before adding any dependency:

- [ ] Checked if native alternative exists
- [ ] Verified it's actively maintained (<6 months since update)
- [ ] Checked bundle size (<50KB preferred, <100KB acceptable)
- [ ] No known security vulnerabilities
- [ ] Good TypeScript support (has @types or built-in types)
- [ ] Documented why this dependency is needed
- [ ] Added comment explaining the choice
- [ ] Locked to specific version
- [ ] Ran `npm audit` after installing

## Resources

- [bundlephobia.com](https://bundlephobia.com) - Check bundle sizes
- [npm trends](https://npmtrends.com) - Compare package popularity
- [Snyk Advisor](https://snyk.io/advisor) - Package health scores
- [Can I Use](https://caniuse.com) - Browser support for native features
- [You might not need jQuery](https://youmightnotneedjquery.com/)
- [You might not need Lodash](https://youmightnotneed.com/lodash/)
