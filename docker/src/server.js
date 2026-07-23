import bcrypt from 'bcryptjs';
import connectPgSimple from 'connect-pg-simple';
import express from 'express';
import session from 'express-session';
import helmet from 'helmet';
import crypto from 'node:crypto';
import fs from 'node:fs';
import pg from 'pg';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import nodemailer from 'nodemailer';

const { Pool } = pg;
const __dirname = path.dirname(fileURLToPath(import.meta.url));

const port = Number(process.env.PORT || 3000);
const databaseUrl = process.env.DATABASE_URL;
const sessionSecret = process.env.SESSION_SECRET;
const adminUsername = process.env.ADMIN_USERNAME || 'admin';
const adminEmail = process.env.ADMIN_EMAIL || (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(adminUsername) ? adminUsername : `${adminUsername}@timesheet.local`);
const adminPassword = process.env.ADMIN_PASSWORD;
const publicAppUrl = (process.env.PUBLIC_APP_URL || `http://localhost:${port}`).replace(/\/$/, '');

if (!databaseUrl) throw new Error('DATABASE_URL is required');
if (!sessionSecret) throw new Error('SESSION_SECRET is required');
if (!adminPassword) throw new Error('ADMIN_PASSWORD is required');

const pool = new Pool({ connectionString: databaseUrl });
const PgSession = connectPgSimple(session);
const app = express();
const publicDir = path.join(__dirname, '..', 'public');

const defaultProjects = [
  { name: 'За год.', billing_type: 'hourly', hourly_rate: '15.00', fixed_rate: '0.00', is_billable_default: true, color: '#cd312b' },
  { name: 'Фікс. тариф', billing_type: 'fixed', hourly_rate: '0.00', fixed_rate: '100.00', is_billable_default: true, color: '#161616' },
  { name: 'Понадн. час', billing_type: 'hourly', hourly_rate: '10.00', fixed_rate: '0.00', is_billable_default: true, color: '#161616' },
  { name: 'Нічна зміна', billing_type: 'hourly', hourly_rate: '10.00', fixed_rate: '0.00', is_billable_default: true, color: '#161616' },
  { name: 'Свято', billing_type: 'hourly', hourly_rate: '10.00', fixed_rate: '0.00', is_billable_default: true, color: '#161616' },
  { name: 'Неоплачувана відпустка', billing_type: 'hourly', hourly_rate: '0.00', fixed_rate: '0.00', is_billable_default: false, color: '#161616' },
];

app.set('trust proxy', 1);
app.use(helmet({ contentSecurityPolicy: false }));
app.use(express.json({ limit: '3mb' }));
app.use(
  session({
    store: new PgSession({
      pool,
      tableName: 'user_sessions',
      createTableIfMissing: true,
    }),
    name: 'timesheet.sid',
    secret: sessionSecret,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      sameSite: 'lax',
      secure: process.env.NODE_ENV === 'production' && process.env.FORCE_INSECURE_COOKIE !== '1',
      maxAge: 1000 * 60 * 60 * 24 * 30,
    },
  }),
);

async function requireAuth(req, res, next) {
  if (!req.session.userId) {
    res.status(401).json({ error: 'Unauthorized' });
    return;
  }
  try {
    const result = await query('SELECT role, is_active FROM users WHERE id = $1', [req.session.userId]);
    if (!result.rows[0] || !result.rows[0].is_active) {
      res.status(403).json({ error: 'Account is blocked' });
      return;
    }
    req.session.role = result.rows[0].role;
    req.session.isActive = result.rows[0].is_active;
    next();
  } catch (err) {
    next(err);
  }
}

function requireAdmin(req, res, next) {
  if (req.session.role !== 'admin') {
    res.status(403).json({ error: 'Admin access required' });
    return;
  }
  next();
}

function intOrNull(value) {
  if (value === undefined || value === null || value === '') return null;
  const parsed = Number.parseInt(value, 10);
  return Number.isFinite(parsed) ? parsed : null;
}

function numberOr(value, fallback = 0) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function boolToDb(value) {
  return value === true || value === 'true' || value === 1 || value === '1';
}

function boolOr(value, fallback = true) {
  return value === undefined ? fallback : boolToDb(value);
}

function requiredString(value, name) {
  const text = String(value || '').trim();
  if (!text) {
    const err = new Error(`${name} is required`);
    err.status = 400;
    throw err;
  }
  return text;
}

function colorOrNull(value) {
  const text = String(value || '').trim();
  return /^#[0-9a-fA-F]{6}$/.test(text) ? text.toLowerCase() : null;
}

function currentUserId(req) {
  return req.session.userId;
}

function normalizeEmail(value) {
  const email = String(value || '').trim().toLowerCase();
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    const err = new Error('Valid email is required');
    err.status = 400;
    throw err;
  }
  return email;
}

function profileFromUser(user) {
  if (!user) return null;
  return {
    id: user.id,
    username: user.username,
    email: user.email,
    display_name: user.display_name,
    phone: user.phone,
    bio: user.bio,
    avatar_url: user.avatar_url,
    email_verified: user.email_verified,
    role: user.role,
    is_active: user.is_active,
    locale: user.locale,
  };
}

async function query(sql, params = []) {
  const result = await pool.query(sql, params);
  return result;
}

async function recordAudit(userId, action, targetType = null, targetId = null, meta = {}) {
  await query(
    `
    INSERT INTO audit_events (user_id, action, target_type, target_id, meta)
    VALUES ($1, $2, $3, $4, $5)
    `,
    [userId, action, targetType, targetId, JSON.stringify(meta || {})],
  );
}

async function ownedClientIdOrNull(userId, clientId) {
  const parsed = intOrNull(clientId);
  if (!parsed) return null;
  const result = await query('SELECT id FROM clients WHERE user_id = $1 AND id = $2', [userId, parsed]);
  if (!result.rows[0]) {
    const err = new Error('Client not found');
    err.status = 400;
    throw err;
  }
  return parsed;
}

async function ownedProjectIdOrNull(userId, projectId) {
  const parsed = intOrNull(projectId);
  if (!parsed) return null;
  const result = await query('SELECT id FROM projects WHERE user_id = $1 AND id = $2', [userId, parsed]);
  if (!result.rows[0]) {
    const err = new Error('Project not found');
    err.status = 400;
    throw err;
  }
  return parsed;
}

function escapeHtml(value) {
  return String(value || '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

function authEmailHtml(title, body, link, buttonText) {
  return `
    <div style="font-family:Arial,sans-serif;line-height:1.5;color:#202126;max-width:560px;margin:0 auto;padding:24px">
      <h1 style="font-size:28px;font-weight:400;margin:0 0 14px">${escapeHtml(title)}</h1>
      <p style="font-size:16px;margin:0 0 22px">${escapeHtml(body)}</p>
      <p style="margin:0 0 24px"><a href="${escapeHtml(link)}" style="display:inline-block;background:#078777;color:#fff;text-decoration:none;padding:12px 18px;border-radius:4px;font-weight:700">${escapeHtml(buttonText)}</a></p>
      <p style="font-size:13px;color:#606169;margin:0">Timesheet</p>
    </div>
  `;
}

async function seedDefaultProjectsForUser(userId) {
  for (const project of defaultProjects) {
    const existingProject = await query(
      'SELECT id FROM projects WHERE user_id = $1 AND name = $2 ORDER BY is_active DESC, id ASC LIMIT 1',
      [userId, project.name],
    );
    if (existingProject.rows[0]) {
      await query(
        `
        UPDATE projects
        SET billing_type = $3, hourly_rate = $4, fixed_rate = $5, default_break_minutes = 0,
            is_billable_default = $6, color = $7, is_active = TRUE, updated_at = now()
        WHERE user_id = $1 AND id = $2
        `,
        [userId, existingProject.rows[0].id, project.billing_type, project.hourly_rate, project.fixed_rate, project.is_billable_default, project.color],
      );
    } else {
      await query(
        `
        INSERT INTO projects (user_id, name, billing_type, hourly_rate, fixed_rate, default_break_minutes, is_billable_default, color)
        VALUES ($1, $2, $3, $4, $5, 0, $6, $7)
        `,
        [userId, project.name, project.billing_type, project.hourly_rate, project.fixed_rate, project.is_billable_default, project.color],
      );
    }
  }
}

function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

async function createAuthToken(userId, type, ttlMinutes, meta = {}) {
  const token = crypto.randomBytes(32).toString('hex');
  await query(
    `
    INSERT INTO auth_tokens (user_id, type, token_hash, expires_at, meta)
    VALUES ($1, $2, $3, now() + ($4::int * interval '1 minute'), $5)
    `,
    [userId, type, hashToken(token), ttlMinutes, JSON.stringify(meta || {})],
  );
  return token;
}

async function consumeAuthToken(token, type) {
  const result = await query(
    `
    UPDATE auth_tokens
    SET used_at = now()
    WHERE id = (
      SELECT id
      FROM auth_tokens
      WHERE token_hash = $1 AND type = $2 AND used_at IS NULL AND expires_at > now()
      ORDER BY created_at DESC
      LIMIT 1
    )
    RETURNING user_id, meta
    `,
    [hashToken(requiredString(token, 'token')), type],
  );
  return result.rows[0] || null;
}

function mailTransport() {
  if (!process.env.SMTP_HOST) return null;
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT || 587),
    secure: process.env.SMTP_SECURE === '1',
    auth: process.env.SMTP_USER ? { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS || '' } : undefined,
  });
}

async function sendAuthMail(to, subject, text, html = null) {
  const from = process.env.SMTP_FROM || 'Timesheet <no-reply@timesheet.local>';
  const transport = mailTransport();
  if (!transport) {
    console.log(`[mail disabled] ${subject} -> ${to}\n${text}`);
    return { sent: false };
  }
  await transport.sendMail({ from, to, subject, text, html: html || undefined });
  return { sent: true };
}

async function migrate() {
  await query('CREATE EXTENSION IF NOT EXISTS pgcrypto');
  await query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE TABLE IF NOT EXISTS app_meta (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL,
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE TABLE IF NOT EXISTS clients (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      name TEXT NOT NULL,
      address TEXT,
      phone TEXT,
      email TEXT,
      description TEXT,
      is_active BOOLEAN NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE TABLE IF NOT EXISTS projects (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE SET NULL,
      name TEXT NOT NULL,
      billing_type TEXT NOT NULL DEFAULT 'hourly' CHECK (billing_type IN ('hourly', 'fixed')),
      hourly_rate NUMERIC(12,2) NOT NULL DEFAULT 0,
      fixed_rate NUMERIC(12,2) NOT NULL DEFAULT 0,
      default_break_minutes INTEGER NOT NULL DEFAULT 0,
      is_billable_default BOOLEAN NOT NULL DEFAULT TRUE,
      color TEXT,
      is_active BOOLEAN NOT NULL DEFAULT TRUE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE TABLE IF NOT EXISTS time_entries (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE SET NULL,
      start_at TIMESTAMPTZ NOT NULL,
      end_at TIMESTAMPTZ NOT NULL,
      break_minutes INTEGER NOT NULL DEFAULT 0,
      worked_minutes INTEGER NOT NULL,
      applied_rate NUMERIC(12,2) NOT NULL DEFAULT 0,
      amount NUMERIC(12,2) NOT NULL DEFAULT 0,
      task_description TEXT,
      status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'paid')),
      is_billable BOOLEAN NOT NULL DEFAULT TRUE,
      is_paid BOOLEAN NOT NULL DEFAULT FALSE,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
      CHECK (end_at > start_at),
      CHECK (break_minutes >= 0),
      CHECK (worked_minutes > 0)
    );

    CREATE TABLE IF NOT EXISTS expenses (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE SET NULL,
      project_id INTEGER REFERENCES projects(id) ON DELETE SET NULL,
      occurred_at DATE NOT NULL,
      amount NUMERIC(12,2) NOT NULL,
      note TEXT,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE TABLE IF NOT EXISTS mileages (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      client_id INTEGER REFERENCES clients(id) ON DELETE SET NULL,
      project_id INTEGER REFERENCES projects(id) ON DELETE SET NULL,
      occurred_at DATE NOT NULL,
      distance NUMERIC(12,2) NOT NULL DEFAULT 0,
      amount NUMERIC(12,2) NOT NULL DEFAULT 0,
      note TEXT,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE INDEX IF NOT EXISTS idx_clients_user ON clients(user_id);
    CREATE INDEX IF NOT EXISTS idx_projects_user ON projects(user_id);
    CREATE INDEX IF NOT EXISTS idx_entries_user_start ON time_entries(user_id, start_at DESC);
    CREATE INDEX IF NOT EXISTS idx_expenses_user_date ON expenses(user_id, occurred_at DESC);
    CREATE INDEX IF NOT EXISTS idx_mileages_user_date ON mileages(user_id, occurred_at DESC);
  `);

  await query(`
    ALTER TABLE users ADD COLUMN IF NOT EXISTS email TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS display_name TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS phone TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS bio TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS avatar_url TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS email_verified BOOLEAN NOT NULL DEFAULT FALSE;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin'));
    ALTER TABLE users ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS pending_email TEXT;
    ALTER TABLE users ADD COLUMN IF NOT EXISTS locale TEXT NOT NULL DEFAULT 'uk' CHECK (locale IN ('uk', 'en'));
    ALTER TABLE users ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT now();

    CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_unique ON users (lower(email)) WHERE email IS NOT NULL;

    CREATE TABLE IF NOT EXISTS auth_tokens (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      type TEXT NOT NULL CHECK (type IN ('verify_email', 'reset_password')),
      token_hash TEXT NOT NULL UNIQUE,
      expires_at TIMESTAMPTZ NOT NULL,
      used_at TIMESTAMPTZ,
      meta JSONB NOT NULL DEFAULT '{}'::jsonb,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE INDEX IF NOT EXISTS idx_auth_tokens_lookup ON auth_tokens(token_hash, type, used_at, expires_at);

    CREATE TABLE IF NOT EXISTS audit_events (
      id SERIAL PRIMARY KEY,
      user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
      action TEXT NOT NULL,
      target_type TEXT,
      target_id INTEGER,
      meta JSONB NOT NULL DEFAULT '{}'::jsonb,
      created_at TIMESTAMPTZ NOT NULL DEFAULT now()
    );

    CREATE INDEX IF NOT EXISTS idx_audit_events_created ON audit_events(created_at DESC);
    CREATE INDEX IF NOT EXISTS idx_audit_events_user ON audit_events(user_id, created_at DESC);
  `);
  await query(`
    ALTER TABLE auth_tokens ADD COLUMN IF NOT EXISTS meta JSONB NOT NULL DEFAULT '{}'::jsonb;
    ALTER TABLE auth_tokens DROP CONSTRAINT IF EXISTS auth_tokens_type_check;
    ALTER TABLE auth_tokens ADD CONSTRAINT auth_tokens_type_check CHECK (type IN ('verify_email', 'reset_password', 'change_email'));
  `);
  await query('ALTER TABLE projects ADD COLUMN IF NOT EXISTS color TEXT');

  const existing = await query('SELECT id FROM users WHERE username = $1', [adminUsername]);
  if (existing.rowCount === 0) {
    const passwordHash = await bcrypt.hash(adminPassword, 12);
    await query(
      'INSERT INTO users (username, email, password_hash, display_name, email_verified, role, is_active) VALUES ($1, $2, $3, $4, TRUE, $5, TRUE)',
      [adminUsername, adminEmail, passwordHash, adminUsername, 'admin'],
    );
    console.log(`Seeded admin user "${adminUsername}"`);
  } else {
    await query(
      "UPDATE users SET email = COALESCE(email, $2), email_verified = TRUE, role = 'admin', is_active = TRUE, display_name = COALESCE(display_name, username), updated_at = now() WHERE username = $1",
      [adminUsername, adminEmail],
    );
  }

  const seeded = await query('SELECT value FROM app_meta WHERE key = $1', ['default_projects_seed_v2']);
  if (seeded.rowCount === 0) {
    const users = await query('SELECT id FROM users');
    for (const user of users.rows) {
      await seedDefaultProjectsForUser(user.id);
    }
    await query(
      `
      INSERT INTO app_meta (key, value, updated_at)
      VALUES ($1, $2, now())
      ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()
      `,
      ['default_projects_seed_v2', 'done'],
    );
  }
}

function calculateEntry(body, project, existingEntry = null) {
  const startAt = new Date(requiredString(body.start_at, 'start_at'));
  const endAt = new Date(requiredString(body.end_at, 'end_at'));
  const breakMinutes = Math.max(0, intOrNull(body.break_minutes) ?? Number(project.default_break_minutes || 0));
  const totalMinutes = Math.round((endAt.getTime() - startAt.getTime()) / 60000);
  const workedMinutes = totalMinutes - breakMinutes;
  if (!Number.isFinite(totalMinutes) || workedMinutes <= 0) {
    const err = new Error('End time must be after start time and worked minutes must be positive');
    err.status = 400;
    throw err;
  }

  const billingType = project.billing_type;
  const keepsSameProject = existingEntry && Number(existingEntry.project_id) === Number(project.id);
  const manualRate = body.applied_rate === undefined || body.applied_rate === '' ? null : numberOr(body.applied_rate, null);
  const appliedRate = manualRate !== null
    ? manualRate
    : keepsSameProject
      ? Number(existingEntry.applied_rate)
      : billingType === 'fixed'
        ? Number(project.fixed_rate)
        : Number(project.hourly_rate);
  const amount = billingType === 'fixed' ? appliedRate : (workedMinutes / 60) * appliedRate;

  return {
    startAt,
    endAt,
    breakMinutes,
    workedMinutes,
    appliedRate: appliedRate.toFixed(2),
    amount: amount.toFixed(2),
  };
}

app.get('/api/session', async (req, res, next) => {
  try {
    if (!req.session.userId) {
      res.json({ authenticated: false, username: null });
      return;
    }
    const result = await query(
      'SELECT id, username, email, display_name, phone, bio, avatar_url, email_verified, role, is_active, locale FROM users WHERE id = $1',
      [req.session.userId],
    );
    const user = result.rows[0];
    if (!user) {
      req.session.destroy(() => {});
      res.json({ authenticated: false, username: null });
      return;
    }
    res.json({ authenticated: true, ...profileFromUser(user) });
  } catch (err) {
    next(err);
  }
});

app.post('/api/login', async (req, res, next) => {
  try {
    const email = normalizeEmail(req.body.email || req.body.username);
    const password = requiredString(req.body.password, 'password');
    const result = await query(
      'SELECT id, username, email, display_name, phone, bio, avatar_url, email_verified, password_hash, role, is_active, locale FROM users WHERE lower(email) = lower($1)',
      [email],
    );
    const user = result.rows[0];
    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
      res.status(401).json({ error: 'Невірний email або пароль' });
      return;
    }
    if (!user.email_verified) {
      res.status(403).json({ error: 'Підтвердіть email перед входом' });
      return;
    }
    if (!user.is_active) {
      res.status(403).json({ error: 'Акаунт заблоковано' });
      return;
    }
    req.session.userId = user.id;
    req.session.username = user.username;
    req.session.role = user.role;
    req.session.isActive = user.is_active;
    await recordAudit(user.id, 'login', 'user', user.id);
    res.json(profileFromUser(user));
  } catch (err) {
    next(err);
  }
});

app.post('/api/register', async (req, res, next) => {
  try {
    const email = normalizeEmail(req.body.email);
    const displayName = requiredString(req.body.display_name || req.body.name, 'display_name');
    const password = requiredString(req.body.password, 'password');
    if (password.length < 8) {
      res.status(400).json({ error: 'Пароль має містити щонайменше 8 символів' });
      return;
    }
    const existing = await query('SELECT id FROM users WHERE username = $1 OR lower(email) = lower($1)', [email]);
    if (existing.rows[0]) {
      res.status(409).json({ error: 'Користувач з таким email вже існує' });
      return;
    }
    const passwordHash = await bcrypt.hash(password, 12);
    const created = await query(
      `
      INSERT INTO users (username, email, display_name, password_hash, email_verified, locale)
      VALUES ($1, $1, $2, $3, FALSE, $4)
      RETURNING id
      `,
      [email, displayName, passwordHash, req.body.locale === 'en' ? 'en' : 'uk'],
    );
    const userId = created.rows[0].id;
    await seedDefaultProjectsForUser(userId);
    const token = await createAuthToken(userId, 'verify_email', 60 * 24);
    const link = `${publicAppUrl}/verify-email?token=${token}`;
    const mail = await sendAuthMail(
      email,
      'Підтвердження реєстрації Timesheet',
      `Вітаємо, ${displayName}!\n\nЩоб підтвердити реєстрацію, відкрийте посилання:\n${link}\n\nПосилання дійсне 24 години.`,
      authEmailHtml('Підтвердження реєстрації Timesheet', `Вітаємо, ${displayName}! Підтвердіть email, щоб увійти в акаунт.`, link, 'Підтвердити email'),
    );
    await recordAudit(userId, 'register', 'user', userId, { email });
    res.status(201).json({ ok: true, email_sent: mail.sent });
  } catch (err) {
    next(err);
  }
});

app.post('/api/verify-email', async (req, res, next) => {
  try {
    const token = await consumeAuthToken(req.body.token, 'verify_email');
    if (!token) {
      res.status(400).json({ error: 'Посилання недійсне або прострочене' });
      return;
    }
    await query('UPDATE users SET email_verified = TRUE, updated_at = now() WHERE id = $1', [token.user_id]);
    await recordAudit(token.user_id, 'verify_email', 'user', token.user_id);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.post('/api/password/forgot', async (req, res, next) => {
  try {
    const email = normalizeEmail(req.body.email);
    const result = await query('SELECT id, email, display_name FROM users WHERE lower(email) = lower($1)', [email]);
    const user = result.rows[0];
    if (user) {
      const token = await createAuthToken(user.id, 'reset_password', 60);
      const link = `${publicAppUrl}/reset-password?token=${token}`;
      await sendAuthMail(
        user.email,
        'Відновлення паролю Timesheet',
        `Щоб встановити новий пароль, відкрийте посилання:\n${link}\n\nПосилання дійсне 1 годину.`,
        authEmailHtml('Відновлення паролю Timesheet', 'Відкрийте посилання, щоб встановити новий пароль. Посилання дійсне 1 годину.', link, 'Оновити пароль'),
      );
    }
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.post('/api/password/reset', async (req, res, next) => {
  try {
    const password = requiredString(req.body.password, 'password');
    if (password.length < 8) {
      res.status(400).json({ error: 'Пароль має містити щонайменше 8 символів' });
      return;
    }
    const token = await consumeAuthToken(req.body.token, 'reset_password');
    if (!token) {
      res.status(400).json({ error: 'Посилання недійсне або прострочене' });
      return;
    }
    const passwordHash = await bcrypt.hash(password, 12);
    await query('UPDATE users SET password_hash = $2, updated_at = now() WHERE id = $1', [token.user_id, passwordHash]);
    await recordAudit(token.user_id, 'reset_password', 'user', token.user_id);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.post('/api/email/resend-verification', async (req, res, next) => {
  try {
    const email = normalizeEmail(req.body.email);
    const result = await query('SELECT id, email, display_name, email_verified FROM users WHERE lower(email) = lower($1)', [email]);
    const user = result.rows[0];
    if (user && !user.email_verified) {
      const token = await createAuthToken(user.id, 'verify_email', 60 * 24);
      const link = `${publicAppUrl}/verify-email?token=${token}`;
      await sendAuthMail(
        user.email,
        'Підтвердження реєстрації Timesheet',
        `Щоб підтвердити реєстрацію, відкрийте посилання:\n${link}\n\nПосилання дійсне 24 години.`,
        authEmailHtml('Підтвердження реєстрації Timesheet', 'Підтвердіть email, щоб увійти в акаунт.', link, 'Підтвердити email'),
      );
      await recordAudit(user.id, 'resend_verification', 'user', user.id);
    }
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.post('/api/email/confirm-change', async (req, res, next) => {
  try {
    const token = await consumeAuthToken(req.body.token, 'change_email');
    if (!token) {
      res.status(400).json({ error: 'Посилання недійсне або прострочене' });
      return;
    }
    const nextEmail = normalizeEmail(token.meta?.email);
    await query(
      'UPDATE users SET email = $2, username = $2, pending_email = NULL, email_verified = TRUE, updated_at = now() WHERE id = $1',
      [token.user_id, nextEmail],
    );
    await recordAudit(token.user_id, 'change_email_confirmed', 'user', token.user_id, { email: nextEmail });
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.get('/api/profile', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      'SELECT id, username, email, display_name, phone, bio, avatar_url, email_verified, role, is_active, locale FROM users WHERE id = $1',
      [currentUserId(req)],
    );
    res.json(profileFromUser(result.rows[0]));
  } catch (err) {
    next(err);
  }
});

app.put('/api/profile', requireAuth, async (req, res, next) => {
  try {
    const avatar = String(req.body.avatar_url || '').trim();
    if (avatar && !avatar.startsWith('data:image/')) {
      res.status(400).json({ error: 'Фото має бути зображенням' });
      return;
    }
    const result = await query(
      `
      UPDATE users
      SET display_name = $2, phone = $3, bio = $4, avatar_url = $5, locale = $6, updated_at = now()
      WHERE id = $1
      RETURNING id, username, email, display_name, phone, bio, avatar_url, email_verified, role, is_active, locale
      `,
      [
        currentUserId(req),
        requiredString(req.body.display_name, 'display_name'),
        req.body.phone || null,
        req.body.bio || null,
        avatar || null,
        req.body.locale === 'en' ? 'en' : 'uk',
      ],
    );
    const profile = profileFromUser(result.rows[0]);
    req.session.username = profile.username;
    await recordAudit(currentUserId(req), 'update_profile', 'user', currentUserId(req));
    res.json(profile);
  } catch (err) {
    next(err);
  }
});

app.post('/api/profile/password', requireAuth, async (req, res, next) => {
  try {
    const currentPassword = requiredString(req.body.current_password, 'current_password');
    const nextPassword = requiredString(req.body.new_password, 'new_password');
    if (nextPassword.length < 8) return res.status(400).json({ error: 'Пароль має містити щонайменше 8 символів' });
    const result = await query('SELECT password_hash FROM users WHERE id = $1', [currentUserId(req)]);
    if (!result.rows[0] || !(await bcrypt.compare(currentPassword, result.rows[0].password_hash))) {
      return res.status(400).json({ error: 'Поточний пароль невірний' });
    }
    await query('UPDATE users SET password_hash = $2, updated_at = now() WHERE id = $1', [currentUserId(req), await bcrypt.hash(nextPassword, 12)]);
    await recordAudit(currentUserId(req), 'change_password', 'user', currentUserId(req));
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.post('/api/profile/email', requireAuth, async (req, res, next) => {
  try {
    const nextEmail = normalizeEmail(req.body.email);
    const existing = await query('SELECT id FROM users WHERE lower(email) = lower($1) AND id <> $2', [nextEmail, currentUserId(req)]);
    if (existing.rows[0]) return res.status(409).json({ error: 'Email вже використовується' });
    await query('UPDATE users SET pending_email = $2, updated_at = now() WHERE id = $1', [currentUserId(req), nextEmail]);
    const token = await createAuthToken(currentUserId(req), 'change_email', 60 * 24, { email: nextEmail });
    const link = `${publicAppUrl}/confirm-email-change?token=${token}`;
    await sendAuthMail(
      nextEmail,
      'Підтвердження нового email Timesheet',
      `Щоб підтвердити новий email, відкрийте посилання:\n${link}\n\nПосилання дійсне 24 години.`,
      authEmailHtml('Підтвердження нового email Timesheet', 'Підтвердіть новий email для вашого акаунта.', link, 'Підтвердити email'),
    );
    await recordAudit(currentUserId(req), 'change_email_requested', 'user', currentUserId(req), { email: nextEmail });
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.delete('/api/profile', requireAuth, async (req, res, next) => {
  try {
    const password = requiredString(req.body.password, 'password');
    const result = await query('SELECT password_hash FROM users WHERE id = $1', [currentUserId(req)]);
    if (!result.rows[0] || !(await bcrypt.compare(password, result.rows[0].password_hash))) {
      return res.status(400).json({ error: 'Пароль невірний' });
    }
    const userId = currentUserId(req);
    await recordAudit(userId, 'delete_account', 'user', userId);
    await query('DELETE FROM users WHERE id = $1', [userId]);
    req.session.destroy((err) => {
      if (err) return next(err);
      res.clearCookie('timesheet.sid');
      res.json({ ok: true });
    });
  } catch (err) {
    next(err);
  }
});

app.post('/api/logout', requireAuth, (req, res, next) => {
  req.session.destroy((err) => {
    if (err) return next(err);
    res.clearCookie('timesheet.sid');
    res.json({ ok: true });
  });
});

app.get('/api/summary', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const result = await query(
      `
      SELECT
        COALESCE(SUM(worked_minutes), 0)::int AS total_minutes,
        COALESCE(SUM(worked_minutes) FILTER (WHERE is_paid), 0)::int AS paid_minutes,
        COALESCE(SUM(worked_minutes) FILTER (WHERE is_billable AND NOT is_paid), 0)::int AS unpaid_minutes,
        COALESCE(SUM(amount), 0)::float AS total_amount,
        COALESCE(SUM(amount) FILTER (WHERE is_paid), 0)::float AS paid_amount,
        COALESCE(SUM(amount) FILTER (WHERE is_billable AND NOT is_paid), 0)::float AS unpaid_amount
      FROM time_entries
      WHERE user_id = $1
      `,
      [userId],
    );
    const extras = await query(
      `
      SELECT
        (SELECT COALESCE(SUM(amount), 0)::float FROM expenses WHERE user_id = $1) AS expenses_amount,
        (SELECT COALESCE(SUM(amount), 0)::float FROM mileages WHERE user_id = $1) AS mileage_amount
      `,
      [userId],
    );
    res.json({ ...result.rows[0], ...extras.rows[0] });
  } catch (err) {
    next(err);
  }
});

app.get('/api/clients', requireAuth, async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM clients WHERE user_id = $1 ORDER BY is_active DESC, name ASC', [currentUserId(req)]);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.post('/api/clients', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `
      INSERT INTO clients (user_id, name, address, phone, email, description)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
      `,
      [
        currentUserId(req),
        requiredString(req.body.name, 'name'),
        req.body.address || null,
        req.body.phone || null,
        req.body.email || null,
        req.body.description || null,
      ],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.put('/api/clients/:id', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `
      UPDATE clients
      SET name = $3, address = $4, phone = $5, email = $6, description = $7, is_active = $8, updated_at = now()
      WHERE user_id = $1 AND id = $2
      RETURNING *
      `,
      [
        currentUserId(req),
        req.params.id,
        requiredString(req.body.name, 'name'),
        req.body.address || null,
        req.body.phone || null,
        req.body.email || null,
        req.body.description || null,
        boolOr(req.body.is_active),
      ],
    );
    if (!result.rows[0]) return res.status(404).json({ error: 'Client not found' });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.delete('/api/clients/:id', requireAuth, async (req, res, next) => {
  try {
    await query('UPDATE clients SET is_active = FALSE, updated_at = now() WHERE user_id = $1 AND id = $2', [currentUserId(req), req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.delete('/api/clients/:id/hard', requireAuth, async (req, res, next) => {
  try {
    await query('DELETE FROM clients WHERE user_id = $1 AND id = $2', [currentUserId(req), req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.get('/api/projects', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `
      SELECT p.*, c.name AS client_name
      FROM projects p
      LEFT JOIN clients c ON c.id = p.client_id AND c.user_id = p.user_id
      WHERE p.user_id = $1
      ORDER BY p.is_active DESC, p.name ASC
      `,
      [currentUserId(req)],
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.post('/api/projects', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const result = await query(
      `
      INSERT INTO projects (
        user_id, client_id, name, billing_type, hourly_rate, fixed_rate, default_break_minutes, is_billable_default, color
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *
      `,
      [
        userId,
        await ownedClientIdOrNull(userId, req.body.client_id),
        requiredString(req.body.name, 'name'),
        req.body.billing_type === 'fixed' ? 'fixed' : 'hourly',
        numberOr(req.body.hourly_rate).toFixed(2),
        numberOr(req.body.fixed_rate).toFixed(2),
        intOrNull(req.body.default_break_minutes) ?? 0,
        boolOr(req.body.is_billable_default),
        colorOrNull(req.body.color),
      ],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.put('/api/projects/:id', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const result = await query(
      `
      UPDATE projects
      SET client_id = $3, name = $4, billing_type = $5, hourly_rate = $6, fixed_rate = $7,
          default_break_minutes = $8, is_billable_default = $9, is_active = $10, color = $11, updated_at = now()
      WHERE user_id = $1 AND id = $2
      RETURNING *
      `,
      [
        userId,
        req.params.id,
        await ownedClientIdOrNull(userId, req.body.client_id),
        requiredString(req.body.name, 'name'),
        req.body.billing_type === 'fixed' ? 'fixed' : 'hourly',
        numberOr(req.body.hourly_rate).toFixed(2),
        numberOr(req.body.fixed_rate).toFixed(2),
        intOrNull(req.body.default_break_minutes) ?? 0,
        boolOr(req.body.is_billable_default),
        boolOr(req.body.is_active),
        colorOrNull(req.body.color),
      ],
    );
    if (!result.rows[0]) return res.status(404).json({ error: 'Project not found' });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.delete('/api/projects/:id', requireAuth, async (req, res, next) => {
  try {
    await query('UPDATE projects SET is_active = FALSE, updated_at = now() WHERE user_id = $1 AND id = $2', [currentUserId(req), req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.get('/api/entries', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `
      SELECT e.*, p.name AS project_name, c.name AS client_name
      FROM time_entries e
      JOIN projects p ON p.id = e.project_id AND p.user_id = e.user_id
      LEFT JOIN clients c ON c.id = e.client_id AND c.user_id = e.user_id
      WHERE e.user_id = $1
      ORDER BY e.start_at DESC
      LIMIT 500
      `,
      [currentUserId(req)],
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.post('/api/entries', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const projectResult = await query('SELECT * FROM projects WHERE user_id = $1 AND id = $2', [userId, req.body.project_id]);
    const project = projectResult.rows[0];
    if (!project) return res.status(400).json({ error: 'Project is required' });

    const explicitClientId = await ownedClientIdOrNull(userId, req.body.client_id);
    const calculated = calculateEntry(req.body, project);
    const isPaid = boolToDb(req.body.is_paid);
    const result = await query(
      `
      INSERT INTO time_entries (
        user_id, project_id, client_id, start_at, end_at, break_minutes, worked_minutes,
        applied_rate, amount, task_description, status, is_billable, is_paid
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
      RETURNING *
      `,
      [
        userId,
        project.id,
        explicitClientId ?? project.client_id,
        calculated.startAt,
        calculated.endAt,
        calculated.breakMinutes,
        calculated.workedMinutes,
        calculated.appliedRate,
        calculated.amount,
        req.body.task_description || null,
        isPaid ? 'paid' : 'open',
        req.body.is_billable !== false,
        isPaid,
      ],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.put('/api/entries/:id', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const existingResult = await query('SELECT * FROM time_entries WHERE user_id = $1 AND id = $2', [userId, req.params.id]);
    const existingEntry = existingResult.rows[0];
    if (!existingEntry) return res.status(404).json({ error: 'Entry not found' });

    const projectResult = await query('SELECT * FROM projects WHERE user_id = $1 AND id = $2', [userId, req.body.project_id]);
    const project = projectResult.rows[0];
    if (!project) return res.status(400).json({ error: 'Project is required' });

    const explicitClientId = await ownedClientIdOrNull(userId, req.body.client_id);
    const calculated = calculateEntry(req.body, project, existingEntry);
    const isPaid = boolToDb(req.body.is_paid);
    const result = await query(
      `
      UPDATE time_entries
      SET project_id = $3, client_id = $4, start_at = $5, end_at = $6, break_minutes = $7,
          worked_minutes = $8, applied_rate = $9, amount = $10, task_description = $11,
          status = $12, is_billable = $13, is_paid = $14, updated_at = now()
      WHERE user_id = $1 AND id = $2
      RETURNING *
      `,
      [
        userId,
        req.params.id,
        project.id,
        explicitClientId ?? project.client_id,
        calculated.startAt,
        calculated.endAt,
        calculated.breakMinutes,
        calculated.workedMinutes,
        calculated.appliedRate,
        calculated.amount,
        req.body.task_description || null,
        isPaid ? 'paid' : 'open',
        req.body.is_billable !== false,
        isPaid,
      ],
    );
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.patch('/api/entries/:id/paid', requireAuth, async (req, res, next) => {
  try {
    const isPaid = boolToDb(req.body.is_paid);
    const result = await query(
      `
      UPDATE time_entries
      SET is_paid = $3, status = $4, updated_at = now()
      WHERE user_id = $1 AND id = $2
      RETURNING *
      `,
      [currentUserId(req), req.params.id, isPaid, isPaid ? 'paid' : 'open'],
    );
    if (!result.rows[0]) return res.status(404).json({ error: 'Entry not found' });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.delete('/api/entries/:id', requireAuth, async (req, res, next) => {
  try {
    await query('DELETE FROM time_entries WHERE user_id = $1 AND id = $2', [currentUserId(req), req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.get('/api/expenses', requireAuth, async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM expenses WHERE user_id = $1 ORDER BY occurred_at DESC, id DESC LIMIT 200', [currentUserId(req)]);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.post('/api/expenses', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const result = await query(
      `
      INSERT INTO expenses (user_id, client_id, project_id, occurred_at, amount, note)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
      `,
      [
        userId,
        await ownedClientIdOrNull(userId, req.body.client_id),
        await ownedProjectIdOrNull(userId, req.body.project_id),
        requiredString(req.body.occurred_at, 'occurred_at'),
        numberOr(req.body.amount).toFixed(2),
        req.body.note || null,
      ],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.get('/api/mileages', requireAuth, async (req, res, next) => {
  try {
    const result = await query('SELECT * FROM mileages WHERE user_id = $1 ORDER BY occurred_at DESC, id DESC LIMIT 200', [currentUserId(req)]);
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.post('/api/mileages', requireAuth, async (req, res, next) => {
  try {
    const userId = currentUserId(req);
    const result = await query(
      `
      INSERT INTO mileages (user_id, client_id, project_id, occurred_at, distance, amount, note)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *
      `,
      [
        userId,
        await ownedClientIdOrNull(userId, req.body.client_id),
        await ownedProjectIdOrNull(userId, req.body.project_id),
        requiredString(req.body.occurred_at, 'occurred_at'),
        numberOr(req.body.distance).toFixed(2),
        numberOr(req.body.amount).toFixed(2),
        req.body.note || null,
      ],
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

function csvCell(value) {
  const text = value === null || value === undefined ? '' : String(value);
  return `"${text.replaceAll('"', '""')}"`;
}

app.get('/api/export/entries.csv', requireAuth, async (req, res, next) => {
  try {
    const result = await query(
      `
      SELECT e.id, e.start_at, e.end_at, e.worked_minutes, e.applied_rate, e.amount,
             e.is_paid, e.is_billable, p.name AS project_name, c.name AS client_name, e.task_description
      FROM time_entries e
      JOIN projects p ON p.id = e.project_id AND p.user_id = e.user_id
      LEFT JOIN clients c ON c.id = e.client_id AND c.user_id = e.user_id
      WHERE e.user_id = $1
      ORDER BY e.start_at DESC
      `,
      [currentUserId(req)],
    );
    const header = ['id', 'start_at', 'end_at', 'worked_minutes', 'rate', 'amount', 'paid', 'billable', 'project', 'client', 'description'];
    const rows = result.rows.map((row) => [
      row.id, row.start_at, row.end_at, row.worked_minutes, row.applied_rate, row.amount,
      row.is_paid, row.is_billable, row.project_name, row.client_name, row.task_description,
    ].map(csvCell).join(','));
    await recordAudit(currentUserId(req), 'export_entries_csv', 'user', currentUserId(req));
    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', 'attachment; filename="timesheet-entries.csv"');
    res.send([header.map(csvCell).join(','), ...rows].join('\n'));
  } catch (err) {
    next(err);
  }
});

app.get('/api/admin/users', requireAuth, requireAdmin, async (_req, res, next) => {
  try {
    const result = await query(
      `
      SELECT u.id, u.username, u.email, u.display_name, u.role, u.is_active, u.email_verified, u.created_at, u.updated_at,
             COUNT(e.id)::int AS entries_count,
             COALESCE(SUM(e.worked_minutes), 0)::int AS worked_minutes
      FROM users u
      LEFT JOIN time_entries e ON e.user_id = u.id
      GROUP BY u.id
      ORDER BY u.created_at DESC
      `,
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.patch('/api/admin/users/:id', requireAuth, requireAdmin, async (req, res, next) => {
  try {
    const targetId = Number(req.params.id);
    if (targetId === currentUserId(req) && req.body.is_active === false) {
      return res.status(400).json({ error: 'Cannot block your own account' });
    }
    const result = await query(
      `
      UPDATE users
      SET is_active = $2, role = $3, updated_at = now()
      WHERE id = $1
      RETURNING id, username, email, display_name, role, is_active, email_verified, created_at, updated_at
      `,
      [targetId, boolOr(req.body.is_active), req.body.role === 'admin' ? 'admin' : 'user'],
    );
    if (!result.rows[0]) return res.status(404).json({ error: 'User not found' });
    await recordAudit(currentUserId(req), 'admin_update_user', 'user', targetId, { is_active: req.body.is_active, role: req.body.role });
    res.json(result.rows[0]);
  } catch (err) {
    next(err);
  }
});

app.delete('/api/admin/users/:id', requireAuth, requireAdmin, async (req, res, next) => {
  try {
    const targetId = Number(req.params.id);
    if (targetId === currentUserId(req)) return res.status(400).json({ error: 'Cannot delete your own account' });
    await recordAudit(currentUserId(req), 'admin_delete_user', 'user', targetId);
    const result = await query('DELETE FROM users WHERE id = $1 RETURNING id', [targetId]);
    if (!result.rows[0]) return res.status(404).json({ error: 'User not found' });
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

app.get('/api/admin/audit', requireAuth, requireAdmin, async (_req, res, next) => {
  try {
    const result = await query(
      `
      SELECT a.*, u.email, u.display_name
      FROM audit_events a
      LEFT JOIN users u ON u.id = a.user_id
      ORDER BY a.created_at DESC
      LIMIT 300
      `,
    );
    res.json(result.rows);
  } catch (err) {
    next(err);
  }
});

app.get(/^\/assets\/index-.*\.(js|css)$/, (req, res, next) => {
  const ext = req.path.endsWith('.js') ? '.js' : '.css';
  const assetsDir = path.join(publicDir, 'assets');
  try {
    const latest = fs.readdirSync(assetsDir)
      .filter((file) => file.startsWith('index-') && file.endsWith(ext))
      .sort()
      .at(-1);
    if (!latest) return next();
    res.sendFile(path.join(assetsDir, latest));
  } catch (err) {
    next(err);
  }
});

app.use(express.static(publicDir, {
  setHeaders(res, filePath) {
    if (filePath.endsWith('index.html') || filePath.endsWith('sw.js') || filePath.endsWith('manifest.webmanifest')) {
      res.setHeader('Cache-Control', 'no-store');
    } else if (filePath.endsWith('debug.html')) {
      res.setHeader('Cache-Control', 'no-store');
    } else if (filePath.includes(`${path.sep}assets${path.sep}`)) {
      res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
    }
  },
}));
app.get('*', (_req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.sendFile(path.join(publicDir, 'index.html'));
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(err.status || 500).json({ error: err.message || 'Internal server error' });
});

await migrate();
app.listen(port, () => {
  console.log(`Timesheet web is running on port ${port}`);
});
