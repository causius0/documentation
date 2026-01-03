# Documentation Standards

## README Format

Keep READMEs **short and concise**. Use ASCII art to visualize workflows and architecture.

### README Template

```markdown
# Project Name

[One-sentence description of what this does]

## Architecture

[ASCII diagram showing system components and data flow]

## Quick Start

\`\`\`bash
# Installation
npm install

# Environment setup
cp .env.example .env
# Edit .env with your values

# Development
npm run dev

# Build
npm run build

# Deploy
[deployment command]
\`\`\`

## Environment Variables

See `.env.example` for all required variables.

## API Reference

[Brief overview - detailed docs in code comments]

## Testing

\`\`\`bash
npm test
\`\`\`

## Security

This project has been audited. See `SECURITY_AUDIT.md` for details.

## License

[License]
```

### ASCII Art Guidelines

Use ASCII diagrams to show:
- Data flow
- Component relationships
- Request/response cycles
- State management
- Authentication flow

**Tools for creating ASCII art:**
- asciiflow.com (recommended)
- Plain text with box-drawing characters

### Example: Full-Stack App Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         CLIENT                              │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   React     │  │  State Mgmt  │  │   Router     │      │
│  │ Components  │◄─┤   (Context)  │◄─┤  (React      │      │
│  └─────────────┘  └──────────────┘  │   Router)    │      │
│         │                            └──────────────┘      │
│         │ API Calls (fetch/axios)                          │
└─────────┼──────────────────────────────────────────────────┘
          │
          │ HTTPS
          ↓
┌─────────────────────────────────────────────────────────────┐
│                      API SERVER                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Express.js / Fastify                                │  │
│  │  ┌────────────┐  ┌─────────────┐  ┌──────────────┐  │  │
│  │  │   Auth     │  │  Business   │  │   Database   │  │  │
│  │  │ Middleware │→ │    Logic    │→ │    Layer     │  │  │
│  │  └────────────┘  └─────────────┘  └──────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
│         │                    │                              │
│         │                    │                              │
└─────────┼────────────────────┼──────────────────────────────┘
          │                    │
          │                    ↓
          │           ┌─────────────────┐
          │           │   PostgreSQL    │
          │           │    (Prisma)     │
          │           └─────────────────┘
          │
          ↓
    ┌──────────────┐
    │  External    │
    │    APIs      │
    └──────────────┘
```

### Example: Authentication Flow

```
┌─────────┐                                              ┌─────────┐
│ Client  │                                              │ Server  │
└────┬────┘                                              └────┬────┘
     │                                                        │
     │  1. POST /register                                    │
     │    { email, password }                                │
     ├──────────────────────────────────────────────────────►│
     │                                                        │
     │                                         2. Hash password (bcrypt)
     │                                         3. Store user in DB
     │                                         4. Generate JWT token
     │                                                        │
     │  5. { token, user }                                   │
     │◄───────────────────────────────────────────────────────┤
     │                                                        │
     │  6. Store token (localStorage/cookie)                 │
     │                                                        │
     │  7. GET /profile                                      │
     │     Headers: { Authorization: Bearer <token> }        │
     ├──────────────────────────────────────────────────────►│
     │                                                        │
     │                                         8. Verify JWT
     │                                         9. Decode userId
     │                                         10. Fetch user data
     │                                                        │
     │  11. { user: {...} }                                  │
     │◄───────────────────────────────────────────────────────┤
     │                                                        │
```

### Example: State Management

```
┌────────────────────────────────────────────────────────────┐
│                    Application State                       │
│                                                            │
│  ┌──────────────┐    ┌──────────────┐    ┌─────────────┐ │
│  │     User     │    │   Products   │    │    Cart     │ │
│  │    State     │    │    State     │    │   State     │ │
│  │  ┌────────┐  │    │  ┌────────┐  │    │ ┌────────┐  │ │
│  │  │ user   │  │    │  │ items  │  │    │ │ items  │  │ │
│  │  │ token  │  │    │  │ filter │  │    │ │ total  │  │ │
│  │  │ loading│  │    │  │ sort   │  │    │ └────────┘  │ │
│  │  └────────┘  │    │  └────────┘  │    │             │ │
│  └──────────────┘    └──────────────┘    └─────────────┘ │
│         │                    │                   │        │
│         └────────────────────┴───────────────────┘        │
│                              │                            │
│                     ┌────────▼────────┐                   │
│                     │     Context     │                   │
│                     │    Provider     │                   │
│                     └────────┬────────┘                   │
│                              │                            │
│                     ┌────────▼────────┐                   │
│                     │   Components    │                   │
│                     └─────────────────┘                   │
└────────────────────────────────────────────────────────────┘
```

### Example: Database Schema

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│     USERS       │         │      POSTS       │         │    COMMENTS     │
├─────────────────┤         ├──────────────────┤         ├─────────────────┤
│ id (PK)         │◄───┐    │ id (PK)          │◄───┐    │ id (PK)         │
│ email           │    │    │ userId (FK)      │    │    │ postId (FK)     │
│ passwordHash    │    └────┤ title            │    └────┤ userId (FK)     │
│ name            │         │ content          │         │ content         │
│ createdAt       │         │ published        │         │ createdAt       │
│ updatedAt       │         │ createdAt        │         └─────────────────┘
└─────────────────┘         │ updatedAt        │
                            └──────────────────┘

Relationships:
- User has many Posts (1:N)
- User has many Comments (1:N)
- Post has many Comments (1:N)
```

## Function & Variable Documentation

**Every function and variable must be documented.** Use JSDoc/TSDoc format.

### Function Documentation Template

```typescript
/**
 * [One-line summary of what this function does]
 *
 * [Detailed explanation if needed - explain the "why" and "how"]
 *
 * @param paramName - What this parameter represents and constraints
 * @param anotherParam - Another parameter description
 * @returns What this function returns and its structure
 * @throws {ErrorType} When this error is thrown
 *
 * @example
 * ```typescript
 * const result = functionName('example');
 * console.log(result); // Expected output
 * ```
 *
 * Algorithm:
 * 1. Step one explanation
 * 2. Step two explanation
 * 3. Step three explanation
 *
 * Why this approach:
 * - Reason 1
 * - Reason 2
 *
 * Alternatives considered:
 * - Alternative 1: Why it wasn't used
 * - Alternative 2: Trade-offs
 */
function functionName(paramName: string, anotherParam: number): ResultType {
  // Implementation with inline comments for complex logic
}
```

### Real Example

```typescript
/**
 * Hash a password using bcrypt with salt rounds
 *
 * Uses bcrypt to create a secure hash of the password. The salt rounds
 * determine how computationally expensive the hash is to generate.
 * Higher = more secure but slower. 12 rounds is a good balance.
 *
 * @param password - The plaintext password to hash (never store this!)
 * @param saltRounds - Number of bcrypt rounds (default: 12, range: 10-14)
 * @returns Promise resolving to the hashed password string
 * @throws {Error} If password is empty or saltRounds is invalid
 *
 * @example
 * ```typescript
 * const hashed = await hashPassword('MySecurePass123!');
 * // Returns: $2b$12$randomsaltandhashedpasswordstring
 * ```
 *
 * Security notes:
 * - Never log the password parameter
 * - Store only the hash, never the plaintext
 * - 12 rounds takes ~200ms, which prevents brute force attacks
 * - Each hash has a unique salt (prevents rainbow table attacks)
 *
 * Why bcrypt over SHA-256:
 * - Bcrypt is designed to be slow (good for passwords)
 * - SHA-256 is too fast (GPUs can crack billions/second)
 * - Bcrypt auto-handles salting
 */
async function hashPassword(
  password: string,
  saltRounds: number = 12
): Promise<string> {
  // Validate input
  if (!password || password.length === 0) {
    throw new Error('Password cannot be empty');
  }

  if (saltRounds < 10 || saltRounds > 14) {
    throw new Error('Salt rounds must be between 10 and 14');
  }

  // Generate hash
  // bcrypt.hash automatically generates a unique salt
  const hash = await bcrypt.hash(password, saltRounds);

  return hash; // Format: $2b$12$[22-char-salt][31-char-hash]
}
```

### Variable Documentation

```typescript
/**
 * Maximum number of login attempts before account lockout
 *
 * After 5 failed attempts, the account is locked for 15 minutes.
 * This prevents brute force attacks while not being too restrictive
 * for legitimate users who forget their password.
 *
 * Why 5: OWASP recommends 3-5 attempts before lockout
 * Alternative: Could use exponential backoff instead
 */
const MAX_LOGIN_ATTEMPTS = 5;

/**
 * JWT token expiration time in seconds (1 hour)
 *
 * Tokens expire after 1 hour for security. Users will need to
 * re-authenticate after this time. For longer sessions, implement
 * refresh tokens.
 *
 * Security trade-off:
 * - Shorter = more secure but worse UX
 * - Longer = better UX but higher risk if token is stolen
 * - 1 hour is a good balance for most applications
 */
const TOKEN_EXPIRATION_SECONDS = 3600; // 60 * 60

/**
 * Database connection pool configuration
 *
 * Connection pool reuses database connections instead of creating
 * new ones for each query, which improves performance significantly.
 *
 * Settings explained:
 * - min: Always keep 2 connections open (faster response)
 * - max: Never exceed 10 connections (prevents DB overload)
 * - idle: Close unused connections after 10 seconds
 */
const poolConfig = {
  min: 2,        // Minimum connections to maintain
  max: 10,       // Maximum connections allowed
  idle: 10000    // Close idle connections after 10s
};
```

## Inline Comments

Use inline comments for:
1. Complex algorithms
2. Non-obvious business logic
3. Workarounds for bugs
4. Performance optimizations
5. Security measures

```typescript
async function processPayment(userId: string, amount: number) {
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

  // Step 3: Deduct from user balance
  // We do this AFTER Stripe confirms to avoid race conditions
  // Transaction ensures atomicity (both succeed or both fail)
  await db.transaction(async (tx) => {
    await tx.users.update({
      where: { id: userId },
      data: { balance: { decrement: amount } }
    });

    // Step 4: Record transaction for auditing
    await tx.transactions.create({
      data: {
        userId,
        amount,
        type: 'payment',
        stripePaymentIntentId: paymentIntent.id,
        timestamp: new Date()
      }
    });
  });

  return paymentIntent;
}
```

## CHANGELOG Format

Keep a changelog to track project evolution.

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- New features that are in development but not yet released

### Changed
- Changes to existing features

### Fixed
- Bug fixes

### Security
- Security improvements and vulnerability fixes

## [1.0.0] - 2025-01-03

### Added
- User authentication with JWT
- Password hashing with bcrypt (12 rounds)
- Rate limiting on login endpoint (5 attempts per 15 minutes)
- PostgreSQL database with Prisma ORM
- Input validation with Zod schemas

### Security
- SQL injection protection via parameterized queries
- XSS protection via input sanitization
- CSRF protection with tokens
- Passed OWASP Top 10 security audit

### Changed
- Migrated from REST to tRPC for type-safe API calls

### Fixed
- Fixed memory leak in WebSocket connections
- Fixed race condition in concurrent user updates

## [0.1.0] - 2024-12-20

### Added
- Initial project setup
- Basic Express server
- Hello world endpoint
```

## Code Example Documentation

Every complex feature should include usage examples:

```typescript
/**
 * API Client for interacting with the backend
 *
 * @example
 * ```typescript
 * // Initialize client
 * const client = new APIClient({
 *   baseUrl: 'https://api.example.com',
 *   apiKey: process.env.API_KEY
 * });
 *
 * // Fetch user data
 * const user = await client.users.get('123');
 * console.log(user.email);
 *
 * // Create new post
 * const post = await client.posts.create({
 *   title: 'My Post',
 *   content: 'Hello world'
 * });
 * ```
 *
 * @example Error handling
 * ```typescript
 * try {
 *   const user = await client.users.get('invalid-id');
 * } catch (error) {
 *   if (error instanceof NotFoundError) {
 *     console.log('User not found');
 *   } else if (error instanceof UnauthorizedError) {
 *     console.log('Invalid API key');
 *   }
 * }
 * ```
 */
class APIClient {
  // ...
}
```

## Documentation Checklist

Every project must have:

- [ ] README.md with ASCII architecture diagram
- [ ] .env.example with all required variables documented
- [ ] CHANGELOG.md tracking changes
- [ ] AGENTS.md with AI agent instructions
- [ ] SECURITY_AUDIT.md for each feature branch
- [ ] JSDoc/TSDoc comments on every function
- [ ] Inline comments explaining complex logic
- [ ] Usage examples for main features
- [ ] Deployment instructions in README

## AI Agent Instructions

When writing documentation:

1. **Be concise** - Don't over-explain obvious things
2. **Use ASCII art** - Visualize workflows and architecture
3. **Document the "why"** - Not just what the code does
4. **Include examples** - Show how to use the feature
5. **Explain trade-offs** - Why this approach vs alternatives
6. **Update as you go** - Don't leave docs for later
7. **Comment every function** - Use JSDoc/TSDoc format
8. **Add inline comments** - Explain complex logic
