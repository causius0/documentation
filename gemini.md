# Gemini AI Agent Guide

This file contains instructions for Gemini AI agents (Gemini 3 Pro, etc.) working on projects.

**Important:** This file is specifically for Gemini agents. Do not read claude.md - that contains Claude Code-specific features that are not applicable.

## Gemini Agent Role

Gemini agents work on **separate features** independently. There is no handoff between Claude Code and Gemini - each agent owns complete features from start to finish.

## Core Responsibilities

As a Gemini agent, you must:

1. **Follow all documentation standards**
   - Read and follow coding-standards.md
   - Follow git-workflow.md for branching and commits
   - Follow security-testing.md for OWASP Top 10
   - Follow documentation-standards.md for docs

2. **Comment extensively**
   - Every function needs JSDoc/TSDoc
   - Every code block needs what/why/how comments
   - Complex logic needs inline comments
   - See coding-standards.md for examples

3. **Test thoroughly**
   - Manual testing before commits
   - Run all build/lint/typecheck commands
   - Test edge cases
   - Document test steps

4. **Security first**
   - Run OWASP Top 10 checklist manually
   - Test for SQL injection, XSS, CSRF, etc.
   - Document security measures taken
   - Create SECURITY_AUDIT.md for each feature

## Essential Agents

Use these specialized approaches for different tasks:

### build-validator Approach
Before every commit, manually validate:
```bash
# Run all checks
pnpm run lint
pnpm run typecheck
pnpm run build
pnpm test  # if tests exist

# Verify:
# ✓ No linting errors
# ✓ No TypeScript errors
# ✓ Build succeeds
# ✓ All tests pass
```

### code-architect Approach
Before implementing complex features:
1. Analyze existing codebase patterns
2. Design architecture that matches existing style
3. Plan file structure
4. Identify dependencies
5. Create implementation plan
6. Document the architecture

### code-simplifier Approach
After implementing features:
1. Review code for over-engineering
2. Identify unnecessary abstractions
3. Consolidate duplicate logic
4. Simplify complex expressions
5. Improve readability
6. Ensure functionality remains intact

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│ 1. Read AGENTS.md for project-specific instructions    │
├─────────────────────────────────────────────────────────┤
│ 2. Read documentation standards (coding-standards.md)  │
├─────────────────────────────────────────────────────────┤
│ 3. Create feature branch                               │
├─────────────────────────────────────────────────────────┤
│ 4. Plan architecture (code-architect approach)         │
├─────────────────────────────────────────────────────────┤
│ 5. Implement with extensive comments                   │
├─────────────────────────────────────────────────────────┤
│ 6. Test manually (document test steps)                 │
├─────────────────────────────────────────────────────────┤
│ 7. Run security audit (OWASP Top 10 checklist)        │
├─────────────────────────────────────────────────────────┤
│ 8. Validate build (build-validator approach)           │
├─────────────────────────────────────────────────────────┤
│ 9. Simplify if needed (code-simplifier approach)       │
├─────────────────────────────────────────────────────────┤
│ 10. Create SECURITY_AUDIT.md with findings             │
├─────────────────────────────────────────────────────────┤
│ 11. Update documentation (README, CHANGELOG)           │
├─────────────────────────────────────────────────────────┤
│ 12. Create PR with comprehensive description           │
├─────────────────────────────────────────────────────────┤
│ 13. Merge to main after approval                       │
└─────────────────────────────────────────────────────────┘
```

## Pre-Merge Checklist

Before creating a PR, verify:

### Testing
- [ ] All manual tests performed and passed
- [ ] `pnpm run lint` passes (no errors)
- [ ] `pnpm run typecheck` passes (no errors)
- [ ] `pnpm run build` succeeds
- [ ] `pnpm test` passes (if tests exist)
- [ ] Tested edge cases (empty inputs, large inputs, special characters)

### Security
- [ ] Tested for SQL injection (if database queries)
- [ ] Tested for XSS (if user input displayed)
- [ ] Tested for CSRF (if state-changing operations)
- [ ] Tested for authentication bypass
- [ ] Tested for authorization escalation
- [ ] Created SECURITY_AUDIT.md documenting tests
- [ ] All critical/high vulnerabilities fixed
- [ ] `pnpm audit --audit-level=high` shows no issues

### Code Quality
- [ ] Every function has JSDoc/TSDoc comments
- [ ] Complex logic has inline comments explaining what/why/how
- [ ] No console.logs or debug code left in
- [ ] TypeScript types are comprehensive (no `any` unless necessary)
- [ ] Code follows existing patterns in codebase
- [ ] No unnecessary complexity or over-engineering

### Documentation
- [ ] README updated if feature changes usage
- [ ] CHANGELOG updated with changes
- [ ] AGENTS.md updated if workflow changed
- [ ] .env.example updated if new variables added
- [ ] All new environment variables documented
- [ ] ASCII diagrams added for complex workflows

## Security Testing (OWASP Top 10)

For each feature, manually test these vulnerabilities:

### 1. Broken Access Control
```bash
# Try to access resources without authentication
# Try to access other users' resources
# Try to perform admin actions as regular user
```

### 2. Cryptographic Failures
```bash
# Verify passwords are hashed (bcrypt, 12+ rounds)
# Verify HTTPS is enforced
# Verify sensitive data is encrypted
```

### 3. Injection Attacks
```bash
# Test SQL injection: ' OR 1=1--
# Test command injection: ; rm -rf /
# Test NoSQL injection: {"$gt": ""}
# Verify all queries use parameterized statements
```

### 4. Insecure Design
```bash
# Test for user enumeration (different error messages)
# Test for timing attacks
# Look for logic flaws
```

### 5. Security Misconfiguration
```bash
# Check for exposed .env files
# Check for debug mode in production
# Check for default credentials
# Verify error messages don't leak sensitive info
```

### 6. Vulnerable Components
```bash
pnpm audit --audit-level=high
# Fix all high/critical vulnerabilities
```

### 7. Authentication Failures
```bash
# Test weak passwords (should be rejected)
# Test password requirements
# Test session expiration
# Test token validation
```

### 8. Data Integrity Failures
```bash
# Test for insecure deserialization
# Verify data signatures
# Check dependency integrity
```

### 9. Logging Failures
```bash
# Verify failed logins are logged
# Verify security events are logged
# Check logs don't contain sensitive data
```

### 10. SSRF
```bash
# Test URL parameters for internal access
# Verify domain whitelisting
# Check for private IP blocking
```

Document all findings in `SECURITY_AUDIT.md`.

## Coding Standards

### Function Documentation
```typescript
/**
 * Hash a password using bcrypt
 *
 * Uses bcrypt with 12 salt rounds for secure password hashing.
 * Higher rounds = more secure but slower. 12 is a good balance.
 *
 * @param password - The plaintext password to hash
 * @param saltRounds - Number of bcrypt rounds (default: 12)
 * @returns Promise resolving to hashed password
 * @throws {Error} If password is empty
 *
 * @example
 * ```typescript
 * const hashed = await hashPassword('MySecurePass123!');
 * // Returns: $2b$12$...
 * ```
 *
 * Security notes:
 * - Never log the password parameter
 * - Store only the hash, never plaintext
 * - 12 rounds takes ~200ms (prevents brute force)
 *
 * Why bcrypt:
 * - Designed to be slow (good for passwords)
 * - Auto-handles salting
 * - Industry standard
 */
async function hashPassword(
  password: string,
  saltRounds: number = 12
): Promise<string> {
  // Validate input
  if (!password || password.length === 0) {
    throw new Error('Password cannot be empty');
  }

  // Generate hash
  // bcrypt.hash automatically generates a unique salt
  const hash = await bcrypt.hash(password, saltRounds);

  return hash;
}
```

### Inline Comments
```typescript
// Step 1: Verify user has sufficient balance
// We check this first to fail fast and avoid unnecessary API calls
const user = await getUser(userId);
if (user.balance < amount) {
  throw new InsufficientFundsError();
}

// Step 2: Create payment intent with Stripe
// Using idempotency key to prevent duplicate charges if request is retried
const idempotencyKey = `payment_${userId}_${Date.now()}`;
const paymentIntent = await stripe.paymentIntents.create({
  amount: amount * 100, // Stripe uses cents, not dollars
  currency: 'usd',
  customer: user.stripeCustomerId
}, {
  idempotencyKey // Prevents duplicate charges on retry
});
```

## Git Workflow

### Branching
```bash
# NEVER work directly on main
git checkout -b feature/descriptive-name

# Examples:
git checkout -b feature/user-authentication
git checkout -b feature/payment-integration
git checkout -b fix/database-timeout
git checkout -b security/sql-injection-fix
```

### Commits
```bash
# Use conventional commits
git commit -m "feat: add user authentication with JWT"
git commit -m "fix: resolve database connection timeout"
git commit -m "security: fix SQL injection in user search"
git commit -m "docs: update README with deployment steps"

# Always include the Claude Code footer
git commit -m "$(cat <<'EOF'
feat: add user authentication

- Implemented JWT token generation
- Added bcrypt password hashing (12 rounds)
- Created auth middleware
- Added rate limiting (5 attempts per 15 min)

Security measures:
- Password hashing with bcrypt
- JWT expiration (1 hour)
- Rate limiting on auth endpoints

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Pull Requests
```bash
# Create PR with comprehensive description
gh pr create --title "feat: user authentication" --body "$(cat <<'EOF'
## Summary
- Implemented JWT-based authentication
- Added password hashing with bcrypt
- Created auth middleware for protected routes

## Security Audit
- ✓ Tested SQL injection - BLOCKED
- ✓ Tested weak passwords - REJECTED
- ✓ Tested brute force - RATE LIMITED
- ✓ Tested token manipulation - REJECTED

See SECURITY_AUDIT.md for details.

## Testing
Manual testing completed:
- ✓ Registration flow
- ✓ Login flow
- ✓ Protected routes
- ✓ Token expiration
- ✓ Error cases

## Build Validation
- ✓ pnpm run lint - PASS
- ✓ pnpm run typecheck - PASS
- ✓ pnpm run build - PASS

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

## Error Handling

Implement dual-mode error handling:

```typescript
class AppError extends Error {
  constructor(
    public userMessage: string,      // User-friendly
    public developerMessage: string,  // Technical details
    public code: string,              // Error code
    public statusCode: number = 500,
    public context?: Record<string, any>
  ) {
    super(developerMessage);
    this.name = this.constructor.name;
  }
}

// Usage
throw new AppError(
  'Unable to process payment. Please try again.',
  'Stripe API returned 402: Insufficient funds',
  'PAYMENT_FAILED',
  402,
  { userId: '123', amount: 50 }
);
```

## Resources

- [Coding Standards](https://github.com/causius0/documentation/blob/main/coding-standards.md)
- [Tech Stack](https://github.com/causius0/documentation/blob/main/tech-stack.md)
- [Git Workflow](https://github.com/causius0/documentation/blob/main/git-workflow.md)
- [Security Testing](https://github.com/causius0/documentation/blob/main/security-testing.md)
- [Documentation Standards](https://github.com/causius0/documentation/blob/main/documentation-standards.md)
- [Dependencies Guide](https://github.com/causius0/documentation/blob/main/dependencies-guide.md)

## Summary Checklist

- [ ] Read AGENTS.md for project specifics
- [ ] Follow coding-standards.md (extensive comments)
- [ ] Follow git-workflow.md (branch, test, merge)
- [ ] Run security audit (OWASP Top 10 checklist)
- [ ] Document extensively (JSDoc + inline comments)
- [ ] Test thoroughly before merging
- [ ] Create SECURITY_AUDIT.md
- [ ] Update README, CHANGELOG, AGENTS.md
- [ ] Validate build before PR
- [ ] Simplify code if over-engineered
- [ ] Do NOT read or reference claude.md (Claude Code specific)

**Remember:** You own the entire feature from start to finish. No handoffs, complete ownership.
