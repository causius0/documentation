# Security Testing & Hacker Agent

## Core Principle

**Every feature must be tested by a "hacker agent"** that attempts to break, exploit, or bypass security measures. Fix all vulnerabilities before merging to main.

## The Hacker Agent Workflow

```
┌──────────────────────────────────────────────────────────┐
│ FEATURE DEVELOPMENT COMPLETE                             │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ HACKER AGENT ACTIVATED                                   │
│ Goal: Break the feature using any method possible        │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ ATTACK VECTORS TESTED                                    │
│ - Injection attacks (SQL, NoSQL, Command, etc.)         │
│ - Authentication bypass                                  │
│ - Authorization escalation                               │
│ - Input validation bypass                                │
│ - Rate limiting bypass                                   │
│ - XSS and CSRF attacks                                   │
│ - Data exposure                                          │
│ - Environment variable leakage                           │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ VULNERABILITIES DOCUMENTED                               │
│ Create security-audit.md in branch                       │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ FIXES IMPLEMENTED                                        │
│ Address each vulnerability with proper mitigation        │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ RE-TEST                                                  │
│ Verify all attacks now fail                             │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ SECURITY CLEARED FOR MERGE                               │
└──────────────────────────────────────────────────────────┘
```

## OWASP Top 10 Checklist

Every feature must be tested against OWASP Top 10:

### 1. Broken Access Control
**Test:**
- Try to access resources without authentication
- Try to access other users' resources
- Try to perform actions above your permission level

**Example attacks:**
```bash
# Try to access admin endpoint as regular user
curl -X GET http://localhost:3000/admin/users

# Try to modify another user's data
curl -X PUT http://localhost:3000/users/123 -d '{"email": "hacker@evil.com"}'

# Try to access files outside intended directory
curl -X GET http://localhost:3000/files/../../etc/passwd
```

**Mitigations:**
```typescript
// Verify user owns the resource
if (resource.userId !== authenticatedUser.id && !authenticatedUser.isAdmin) {
  throw new ForbiddenError('You do not have access to this resource');
}

// Implement role-based access control (RBAC)
const requireRole = (role: string) => (req, res, next) => {
  if (!req.user?.roles.includes(role)) {
    return res.status(403).json({ error: 'Insufficient permissions' });
  }
  next();
};
```

### 2. Cryptographic Failures
**Test:**
- Check if sensitive data is encrypted at rest
- Verify HTTPS is enforced
- Test password hashing strength

**Example attacks:**
```bash
# Try to access the app over HTTP (should redirect to HTTPS)
curl http://localhost:3000

# Check if passwords are hashed in database
# (Look at actual database records - should never see plaintext)
```

**Mitigations:**
```typescript
// Use bcrypt for password hashing (NEVER store plaintext)
import bcrypt from 'bcrypt';

const saltRounds = 12; // Higher = more secure but slower
const hashedPassword = await bcrypt.hash(password, saltRounds);

// Verify password
const isValid = await bcrypt.compare(inputPassword, hashedPassword);

// Encrypt sensitive data before storing
import crypto from 'crypto';

const algorithm = 'aes-256-gcm';
const key = Buffer.from(process.env.ENCRYPTION_KEY!, 'hex');

function encrypt(text: string): string {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  // ... encryption logic
}
```

### 3. Injection Attacks
**Test:**
- SQL injection in all input fields
- NoSQL injection
- Command injection
- LDAP injection

**Example attacks:**
```bash
# SQL Injection attempts
curl -X POST http://localhost:3000/login \
  -d '{"email": "admin@example.com\" OR 1=1--", "password": "anything"}'

# Command injection
curl -X POST http://localhost:3000/process \
  -d '{"filename": "file.txt; rm -rf /"}'

# NoSQL injection (MongoDB)
curl -X POST http://localhost:3000/users \
  -d '{"email": {"$gt": ""}, "password": {"$gt": ""}}'
```

**Mitigations:**
```typescript
// SQL: ALWAYS use parameterized queries
// ❌ BAD - Vulnerable to injection
const query = `SELECT * FROM users WHERE email = '${userInput}'`;

// ✅ GOOD - Parameterized query (Prisma example)
const user = await prisma.user.findFirst({
  where: { email: userInput } // Prisma automatically sanitizes
});

// ✅ GOOD - Prepared statement (raw SQL)
const user = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [userInput]
);

// Input validation with a schema library
import { z } from 'zod';

const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(100)
});

// Validate before using
const { email, password } = LoginSchema.parse(req.body);

// NoSQL: Explicitly type your queries
const user = await User.findOne({
  email: String(req.body.email) // Ensure it's a string, not an object
});
```

### 4. Insecure Design
**Test:**
- Try to enumerate users (check if emails exist)
- Test for timing attacks
- Look for logic flaws

**Example attacks:**
```bash
# User enumeration via different error messages
curl -X POST http://localhost:3000/login \
  -d '{"email": "exists@example.com", "password": "wrong"}'
# Response: "Invalid password" (reveals email exists)

curl -X POST http://localhost:3000/login \
  -d '{"email": "notexist@example.com", "password": "wrong"}'
# Response: "User not found" (reveals email doesn't exist)
```

**Mitigations:**
```typescript
// Generic error messages to prevent enumeration
if (!user || !await bcrypt.compare(password, user.password)) {
  // Same message regardless of whether user exists or password is wrong
  throw new UnauthorizedError('Invalid email or password');
}

// Rate limiting to prevent brute force
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts per window
  message: 'Too many login attempts, please try again later'
});

app.post('/login', loginLimiter, loginHandler);
```

### 5. Security Misconfiguration
**Test:**
- Check for exposed environment variables
- Look for debug mode in production
- Test default credentials
- Check for unnecessary services running

**Example attacks:**
```bash
# Try to access common debug endpoints
curl http://localhost:3000/debug
curl http://localhost:3000/.env
curl http://localhost:3000/config

# Check response headers for version information
curl -I http://localhost:3000
```

**Mitigations:**
```typescript
// Never expose sensitive info in errors
// ❌ BAD
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.message, stack: err.stack });
});

// ✅ GOOD
app.use((err, req, res, next) => {
  console.error(err); // Log internally
  res.status(500).json({
    error: process.env.NODE_ENV === 'production'
      ? 'Internal server error'
      : err.message
  });
});

// Security headers
import helmet from 'helmet';
app.use(helmet()); // Sets various security headers

// Disable unnecessary features
app.disable('x-powered-by'); // Don't reveal Express
```

### 6. Vulnerable and Outdated Components
**Test:**
- Check for outdated dependencies
- Look for known vulnerabilities

**Commands:**
```bash
# Check for vulnerabilities
npm audit

# Update dependencies
npm update

# Check for outdated packages
npm outdated
```

**Mitigations:**
```bash
# Run before every merge
npm audit fix

# For high/critical vulnerabilities, investigate and fix immediately
npm audit --audit-level=high
```

### 7. Identification and Authentication Failures
**Test:**
- Try weak passwords
- Test session fixation
- Test for missing MFA
- Try credential stuffing

**Example attacks:**
```bash
# Try common passwords
curl -X POST http://localhost:3000/register \
  -d '{"email": "test@example.com", "password": "password123"}'

# Try to reuse session tokens
curl -X GET http://localhost:3000/profile \
  -H "Authorization: Bearer <old_token>"
```

**Mitigations:**
```typescript
// Password strength validation
const PasswordSchema = z.string()
  .min(12, 'Password must be at least 12 characters')
  .regex(/[A-Z]/, 'Must contain uppercase letter')
  .regex(/[a-z]/, 'Must contain lowercase letter')
  .regex(/[0-9]/, 'Must contain number')
  .regex(/[^A-Za-z0-9]/, 'Must contain special character');

// JWT token expiration
const token = jwt.sign(
  { userId: user.id },
  process.env.JWT_SECRET!,
  { expiresIn: '1h' } // Short expiration
);

// Refresh token rotation
// Implement refresh tokens with longer expiration but rotate them
```

### 8. Software and Data Integrity Failures
**Test:**
- Try to modify serialized objects
- Test for unsigned/unverified updates
- Check for insecure deserialization

**Mitigations:**
```typescript
// Sign critical data
import crypto from 'crypto';

function signData(data: any): string {
  const hmac = crypto.createHmac('sha256', process.env.SIGNING_KEY!);
  hmac.update(JSON.stringify(data));
  return hmac.digest('hex');
}

function verifyData(data: any, signature: string): boolean {
  const expectedSignature = signData(data);
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expectedSignature)
  );
}

// Verify dependencies
# Use lock files (package-lock.json or pnpm-lock.yaml)
# Never commit without lock file
```

### 9. Security Logging and Monitoring Failures
**Test:**
- Check if failed logins are logged
- Verify suspicious activity is detected

**Mitigations:**
```typescript
// Log security events
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'security.log' })
  ]
});

// Log authentication failures
logger.warn('Failed login attempt', {
  email: email,
  ip: req.ip,
  timestamp: new Date(),
  userAgent: req.headers['user-agent']
});

// Alert on multiple failures
if (failedAttempts > 5) {
  logger.error('Potential brute force attack', {
    email: email,
    attempts: failedAttempts,
    ip: req.ip
  });
  // Send alert to admin
}
```

### 10. Server-Side Request Forgery (SSRF)
**Test:**
- Try to make server request internal resources
- Test URL parameters for SSRF

**Example attacks:**
```bash
# Try to access internal resources
curl -X POST http://localhost:3000/fetch-url \
  -d '{"url": "http://localhost:3000/admin"}'

curl -X POST http://localhost:3000/fetch-url \
  -d '{"url": "http://169.254.169.254/latest/meta-data/"}'  # AWS metadata
```

**Mitigations:**
```typescript
// Whitelist allowed domains
const ALLOWED_DOMAINS = ['api.example.com', 'cdn.example.com'];

function isAllowedUrl(url: string): boolean {
  const parsed = new URL(url);
  return ALLOWED_DOMAINS.includes(parsed.hostname);
}

// Block private IP ranges
function isPrivateIP(ip: string): boolean {
  // Block localhost, 10.x.x.x, 192.168.x.x, 169.254.x.x, etc.
  return /^(127\.|10\.|192\.168\.|169\.254\.)/.test(ip);
}
```

## Security Audit Template

Create `SECURITY_AUDIT.md` in each feature branch:

```markdown
# Security Audit Report

**Feature:** [Feature name]
**Branch:** [Branch name]
**Date:** [Date]
**Auditor:** [Hacker Agent / AI Agent]

## Attack Vectors Tested

- [ ] Broken Access Control
- [ ] Cryptographic Failures
- [ ] Injection Attacks (SQL, NoSQL, Command)
- [ ] Insecure Design
- [ ] Security Misconfiguration
- [ ] Vulnerable Components
- [ ] Authentication Failures
- [ ] Data Integrity
- [ ] Logging Failures
- [ ] SSRF

## Vulnerabilities Found

### 1. [Vulnerability Name]
**Severity:** Critical | High | Medium | Low
**Description:** [What was found]
**Attack Example:**
\`\`\`bash
[Command or code that exploited it]
\`\`\`
**Fix Applied:** [How it was fixed]
**Verification:** [How we verified the fix]

### 2. [Next vulnerability...]

## Security Measures Implemented

- [List all security measures added]
- [Input validation, rate limiting, etc.]

## Final Status

- [ ] All critical vulnerabilities fixed
- [ ] All high vulnerabilities fixed
- [ ] All medium vulnerabilities fixed or documented
- [ ] Re-tested all attack vectors
- [ ] Security documentation updated
- [ ] Code comments explain security measures

**CLEARED FOR MERGE:** Yes / No
```

## AI Agent Instructions

### Before Every Merge

1. **Activate hacker mindset** - Try to break your own code
2. **Test all OWASP Top 10** - Go through the checklist systematically
3. **Document everything** - Create SECURITY_AUDIT.md
4. **Fix all criticals** - Zero tolerance for critical/high vulnerabilities
5. **Re-test after fixes** - Verify attacks now fail
6. **Update security docs** - Keep this file updated with new attack patterns

### Security-First Development

```typescript
/**
 * Security Checklist for Every Feature:
 *
 * Authentication & Authorization:
 * - [ ] User is authenticated before accessing resources
 * - [ ] User is authorized to perform the action
 * - [ ] Tokens expire appropriately
 *
 * Input Validation:
 * - [ ] All inputs validated with schema (Zod, Joi, etc.)
 * - [ ] SQL queries use parameterized statements
 * - [ ] File uploads are restricted and validated
 *
 * Data Protection:
 * - [ ] Passwords hashed with bcrypt (12+ rounds)
 * - [ ] Sensitive data encrypted at rest
 * - [ ] HTTPS enforced (no HTTP)
 * - [ ] No secrets in code (use .env)
 *
 * Rate Limiting:
 * - [ ] Login endpoints rate limited
 * - [ ] API endpoints rate limited
 * - [ ] File upload size limited
 *
 * Error Handling:
 * - [ ] Generic error messages (no info leakage)
 * - [ ] Errors logged securely
 * - [ ] Stack traces hidden in production
 *
 * Dependencies:
 * - [ ] npm audit shows no high/critical vulnerabilities
 * - [ ] Dependencies are up to date
 * - [ ] Lock file committed
 */
```

## Common Vulnerability Patterns to Avoid

```typescript
// ❌ NEVER DO THESE

// 1. String concatenation in queries
const query = `SELECT * FROM users WHERE id = ${userId}`;

// 2. Storing passwords in plaintext
await db.users.create({ password: req.body.password });

// 3. No input validation
const result = await processData(req.body.data);

// 4. Exposing sensitive info in errors
res.status(500).json({ error: err.stack });

// 5. No rate limiting on auth
app.post('/login', loginHandler);

// 6. Weak session management
const sessionId = Math.random().toString();

// 7. Missing authorization checks
app.delete('/users/:id', (req, res) => {
  await db.users.delete(req.params.id); // Anyone can delete anyone!
});

// 8. eval() or similar dynamic code execution
eval(req.body.code);

// 9. Unvalidated redirects
res.redirect(req.query.url);

// 10. Hardcoded secrets
const API_KEY = 'sk_live_1234567890abcdef';
```

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [Snyk Vulnerability Database](https://snyk.io/vuln/)

Remember: **Security is not optional. Every feature must pass security audit before merge.**
