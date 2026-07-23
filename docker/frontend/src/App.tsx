import React from 'react';
import {
  BarChart3,
  CalendarDays,
  CircleHelp,
  Database,
  Download,
  FileText,
  Folder,
  List,
  Mail,
  Settings,
  Shield,
  User,
  UserCircle,
} from 'lucide-react';
import { api, formPayload } from './api';
import { emptySummary, tabTitles } from './constants';
import type { Client, Entry, Expense, Mileage, Project, Session, Summary, TabName, ThemeMode, UserProfile } from './types';
import { LanguageSelect, useI18n, type Locale } from './i18n';
import { InfoTab } from './components/Shared';
import { AdminTab } from './features/admin/AdminTab';
import { CalendarTab } from './features/calendar/CalendarTab';
import { ClientsTab } from './features/clients/ClientsTab';
import { FinanceTab } from './features/finance/FinanceTab';
import { ProjectsTab } from './features/projects/ProjectsTab';
import { ProfileTab } from './features/profile/ProfileTab';
import { SettingsTab } from './features/settings/SettingsTab';
import { StatsTab } from './features/stats/StatsTab';
import { TimeTab } from './features/time/TimeTab';

const lastClientKey = 'timesheet.lastClientId';
const lastProjectKey = 'timesheet.lastProjectId';
const themeKey = 'timesheet.theme';

export function App() {
  const [session, setSession] = React.useState<Session | null>(null);
  const [authMode, setAuthMode] = React.useState<'login' | 'register' | 'forgot' | 'reset' | 'verify'>('login');
  const [authToken, setAuthToken] = React.useState('');
  const [authMessage, setAuthMessage] = React.useState('');
  const [resendEmail, setResendEmail] = React.useState('');
  const [authBusy, setAuthBusy] = React.useState(false);
  const [summary, setSummary] = React.useState<Summary>(emptySummary);
  const [clients, setClients] = React.useState<Client[]>([]);
  const [projects, setProjects] = React.useState<Project[]>([]);
  const [entries, setEntries] = React.useState<Entry[]>([]);
  const [expenses, setExpenses] = React.useState<Expense[]>([]);
  const [mileages, setMileages] = React.useState<Mileage[]>([]);
  const [activeTab, setActiveTab] = React.useState<TabName>('time');
  const [homeVisible, setHomeVisible] = React.useState(true);
  const [toast, setToast] = React.useState('');
  const [error, setError] = React.useState('');
  const [calendarMonth, setCalendarMonth] = React.useState(() => new Date(new Date().getFullYear(), new Date().getMonth(), 1));
  const [selectedDay, setSelectedDay] = React.useState(() => new Date());
  const [entryDraftDay, setEntryDraftDay] = React.useState<Date | null>(null);
  const [editingEntry, setEditingEntry] = React.useState<Entry | null>(null);
  const [lastClientId, setLastClientId] = React.useState(() => localStorage.getItem(lastClientKey) || '');
  const [lastProjectId, setLastProjectId] = React.useState(() => localStorage.getItem(lastProjectKey) || '');
  const [theme, setTheme] = React.useState<ThemeMode>(() => (localStorage.getItem(themeKey) === 'dark' ? 'dark' : 'light'));
  const touchStart = React.useRef({ x: 0, y: 0 });
  const { locale, setLocale, t } = useI18n(session?.locale);

  React.useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const token = params.get('token') || '';
    if (window.location.pathname === '/verify-email' && token) {
      setAuthToken(token);
      setAuthMode('verify');
    }
    if (window.location.pathname === '/reset-password' && token) {
      setAuthToken(token);
      setAuthMode('reset');
    }
    if (window.location.pathname === '/confirm-email-change' && token) {
      setAuthToken(token);
      setAuthMode('verify');
      api('/api/email/confirm-change', { method: 'POST', body: JSON.stringify({ token }) })
        .then(() => {
          window.history.replaceState(null, '', '/');
          setAuthToken('');
          setAuthMode('login');
          setAuthMessage('Email підтверджено. Увійдіть ще раз.');
        })
        .catch((err) => setError(err.message));
    }
  }, []);

  const activeClients = clients.filter((client) => client.is_active);
  const activeProjects = projects.filter((project) => project.is_active);
  const isCalendarFocus = activeTab === 'calendar' && !homeVisible;

  async function loadAll() {
    const [nextSummary, nextClients, nextProjects, nextEntries, nextExpenses, nextMileages] = await Promise.all([
      api<Summary>('/api/summary'),
      api<Client[]>('/api/clients'),
      api<Project[]>('/api/projects'),
      api<Entry[]>('/api/entries'),
      api<Expense[]>('/api/expenses'),
      api<Mileage[]>('/api/mileages'),
    ]);
    setSummary(nextSummary);
    setClients(nextClients);
    setProjects(nextProjects);
    setEntries(nextEntries);
    setExpenses(nextExpenses);
    setMileages(nextMileages);
  }

  function showToast(message: string) {
    setToast(message);
    window.setTimeout(() => setToast(''), 2200);
  }

  function rememberDraft(payload: Record<string, FormDataEntryValue | boolean>) {
    const projectId = String(payload.project_id || '');
    const clientId = String(payload.client_id || '');
    setLastProjectId(projectId);
    setLastClientId(clientId);
    localStorage.setItem(lastProjectKey, projectId);
    localStorage.setItem(lastClientKey, clientId);
  }

  React.useEffect(() => {
    api<Session>('/api/session')
      .then(async (nextSession) => {
        setSession(nextSession);
        if (nextSession.authenticated) await loadAll();
      })
      .catch((err) => setError(err.message));
  }, []);

  React.useEffect(() => {
    document.body.classList.toggle('calendar-focus', isCalendarFocus);
    return () => document.body.classList.remove('calendar-focus');
  }, [isCalendarFocus]);

  React.useEffect(() => {
    document.body.dataset.theme = theme;
    localStorage.setItem(themeKey, theme);
  }, [theme]);

  React.useEffect(() => {
    if (session?.locale === 'en' || session?.locale === 'uk') setLocale(session.locale);
  }, [session?.locale]);

  async function login(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError('');
    setAuthBusy(true);
    try {
      const user = await api<UserProfile>('/api/login', {
        method: 'POST',
        body: JSON.stringify(formPayload(event.currentTarget)),
      });
      setSession({ authenticated: true, ...user });
      await loadAll();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setAuthBusy(false);
    }
  }

  async function register(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    setError('');
    setAuthMessage('');
    setAuthBusy(true);
    try {
      const result = await api<{ email_sent: boolean }>('/api/register', {
        method: 'POST',
        body: JSON.stringify({ ...formPayload(form), locale }),
      });
      form.reset();
      setAuthMode('login');
      setAuthMessage(result.email_sent ? 'Перевірте пошту і підтвердіть реєстрацію.' : 'Користувача створено. SMTP не налаштований, посилання підтвердження записане в лог контейнера.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Помилка реєстрації');
    } finally {
      setAuthBusy(false);
    }
  }

  async function forgotPassword(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    setError('');
    setAuthMessage('');
    setAuthBusy(true);
    try {
      await api('/api/password/forgot', { method: 'POST', body: JSON.stringify(formPayload(form)) });
      form.reset();
      setAuthMessage('Якщо email є в системі, лист для відновлення паролю буде надіслано.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Помилка відновлення');
    } finally {
      setAuthBusy(false);
    }
  }

  async function resetPassword(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    setError('');
    setAuthMessage('');
    setAuthBusy(true);
    try {
      await api('/api/password/reset', {
        method: 'POST',
        body: JSON.stringify({ ...formPayload(form), token: authToken }),
      });
      window.history.replaceState(null, '', '/');
      setAuthToken('');
      setAuthMode('login');
      setAuthMessage('Пароль оновлено. Тепер можна увійти.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Помилка оновлення паролю');
    } finally {
      setAuthBusy(false);
    }
  }

  async function verifyEmail() {
    setError('');
    setAuthMessage('');
    setAuthBusy(true);
    try {
      await api('/api/verify-email', { method: 'POST', body: JSON.stringify({ token: authToken }) });
      window.history.replaceState(null, '', '/');
      setAuthToken('');
      setAuthMode('login');
      setAuthMessage('Email підтверджено. Тепер можна увійти.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Помилка підтвердження');
    } finally {
      setAuthBusy(false);
    }
  }

  async function logout() {
    await api('/api/logout', { method: 'POST' });
    setSession({ authenticated: false, username: null });
    setActiveTab('time');
    setHomeVisible(true);
  }

  async function saveProfile(event: React.FormEvent<HTMLFormElement>, avatarUrl: string) {
    event.preventDefault();
    const payload = { ...formPayload(event.currentTarget), avatar_url: avatarUrl };
    const profile = await api<UserProfile>('/api/profile', { method: 'PUT', body: JSON.stringify(payload) });
    setSession((current) => current ? { ...current, ...profile, authenticated: true } : current);
    showToast(t('savedProfile'));
  }

  async function changeProfilePassword(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    await api('/api/profile/password', { method: 'POST', body: JSON.stringify(formPayload(form)) });
    form.reset();
    showToast(t('passwordChanged'));
  }

  async function changeProfileEmail(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = event.currentTarget;
    await api('/api/profile/email', { method: 'POST', body: JSON.stringify(formPayload(form)) });
    form.reset();
    showToast(t('emailChangeSent'));
  }

  async function deleteAccount(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!window.confirm(t('deleteAccount'))) return;
    await api('/api/profile', { method: 'DELETE', body: JSON.stringify(formPayload(event.currentTarget)) });
    setSession({ authenticated: false, username: null });
    showToast(t('accountDeleted'));
  }

  async function resendVerification() {
    await api('/api/email/resend-verification', { method: 'POST', body: JSON.stringify({ email: resendEmail }) });
    setResendEmail('');
    setAuthMessage('Лист підтвердження відправлено повторно.');
  }

  function exportEntriesCsv() {
    window.location.href = '/api/export/entries.csv';
  }

  async function submitForm(event: React.FormEvent<HTMLFormElement>, path: string, message: string, method = 'POST') {
    event.preventDefault();
    const form = event.currentTarget;
    await api(path, { method, body: JSON.stringify(formPayload(form)) });
    form.reset();
    setEntryDraftDay(null);
    showToast(message);
    await loadAll();
  }

  async function submitEntry(event: React.FormEvent<HTMLFormElement>, entry?: Entry) {
    event.preventDefault();
    const form = event.currentTarget;
    const payload = formPayload(form);
    const calendarOriginDay = entry ? new Date(entry.start_at) : entryDraftDay ? new Date(entryDraftDay) : null;
    await api(entry ? `/api/entries/${entry.id}` : '/api/entries', { method: entry ? 'PUT' : 'POST', body: JSON.stringify(payload) });
    rememberDraft(payload);
    form.reset();
    setEntryDraftDay(null);
    setEditingEntry(null);
    await loadAll();
    if (calendarOriginDay) {
      setSelectedDay(calendarOriginDay);
      setCalendarMonth(new Date(calendarOriginDay.getFullYear(), calendarOriginDay.getMonth(), 1));
      setActiveTab('calendar');
    }
    showToast(entry ? 'Запис часу оновлено' : 'Запис часу додано');
  }

  async function copyEntry(event: React.MouseEvent<HTMLButtonElement>, entry: Entry) {
    const form = event.currentTarget.form;
    if (!form) return;
    const payload = formPayload(form);
    const originDay = new Date(String(payload.start_at || entry.start_at));
    await api('/api/entries', { method: 'POST', body: JSON.stringify(payload) });
    rememberDraft(payload);
    form.reset();
    setEntryDraftDay(null);
    setEditingEntry(null);
    await loadAll();
    setSelectedDay(originDay);
    setCalendarMonth(new Date(originDay.getFullYear(), originDay.getMonth(), 1));
    setActiveTab('calendar');
    showToast('Запис часу скопійовано');
  }

  function openEntryForDay(day: Date) {
    setEditingEntry(null);
    setEntryDraftDay(new Date(day));
    setHomeVisible(false);
    setActiveTab('time');
  }

  function editEntry(entry: Entry) {
    setEntryDraftDay(null);
    setEditingEntry(entry);
    setHomeVisible(false);
    setActiveTab('time');
  }

  async function markPaid(entry: Entry) {
    await api(`/api/entries/${entry.id}/paid`, { method: 'PATCH', body: JSON.stringify({ is_paid: !entry.is_paid }) });
    await loadAll();
  }

  async function deleteEntry(entry: Entry) {
    if (!window.confirm('Видалити цей запис часу?')) return;
    await api(`/api/entries/${entry.id}`, { method: 'DELETE' });
    if (editingEntry?.id === entry.id) setEditingEntry(null);
    await loadAll();
    if (activeTab === 'time') setActiveTab('calendar');
  }

  async function archive(path: string) {
    if (!window.confirm('Видалити цей запис?')) return false;
    await api(path, { method: 'DELETE' });
    await loadAll();
    return true;
  }

  async function archiveClient(client: Client) {
    if (!window.confirm('Заархівувати цього клієнта?')) return false;
    await api(`/api/clients/${client.id}`, { method: 'DELETE' });
    await loadAll();
    return true;
  }

  async function deleteClient(client: Client) {
    if (!window.confirm('Видалити цього клієнта остаточно?')) return false;
    await api(`/api/clients/${client.id}/hard`, { method: 'DELETE' });
    await loadAll();
    return true;
  }

  async function copyClient(client: Client) {
    const copied = await api<Client>('/api/clients', {
      method: 'POST',
      body: JSON.stringify({
        name: `${client.name} копія`,
        address: client.address || '',
        phone: client.phone || '',
        email: client.email || '',
        description: client.description || '',
      }),
    });
    await loadAll();
    return copied;
  }

  if (session === null) return <main className="login-shell" />;

  if (!session.authenticated) {
    return (
      <main className="login-shell">
        {authMode === 'login' && (
          <form className="login-panel" onSubmit={login}>
            <div>
              <h1>Timesheet</h1>
              <p>{t('loginSubtitle')}</p>
            </div>
            <LanguageSelect locale={locale} onChange={setLocale} />
            <label>{t('email')}<input name="email" type="email" autoComplete="email" required /></label>
            <label>{t('password')}<input name="password" type="password" autoComplete="current-password" required /></label>
            <button type="submit" disabled={authBusy}>{t('signIn')}</button>
            <div className="auth-links">
              <button type="button" onClick={() => { setAuthMode('register'); setError(''); }}>{t('register')}</button>
              <button type="button" onClick={() => { setAuthMode('forgot'); setError(''); }}>{t('forgotPassword')}</button>
            </div>
            <div className="resend-inline">
              <input value={resendEmail} onChange={(event) => setResendEmail(event.currentTarget.value)} type="email" placeholder={t('email')} />
              <button type="button" onClick={resendVerification} disabled={!resendEmail}>{t('resendVerification')}</button>
            </div>
            {authMessage && <p className="success">{authMessage}</p>}
            <p className="error">{error}</p>
          </form>
        )}

        {authMode === 'register' && (
          <form className="login-panel" onSubmit={register}>
            <div>
              <h1>{t('register')}</h1>
              <p>{t('registerSubtitle')}</p>
            </div>
            <LanguageSelect locale={locale} onChange={setLocale} />
            <label>{t('name')}<input name="display_name" autoComplete="name" required /></label>
            <label>{t('email')}<input name="email" type="email" autoComplete="email" required /></label>
            <label>{t('password')}<input name="password" type="password" autoComplete="new-password" minLength={8} required /></label>
            <button type="submit" disabled={authBusy}>{t('createAccount')}</button>
            <div className="auth-links">
              <button type="button" onClick={() => { setAuthMode('login'); setError(''); }}>{t('backToLogin')}</button>
            </div>
            <p className="error">{error}</p>
          </form>
        )}

        {authMode === 'forgot' && (
          <form className="login-panel" onSubmit={forgotPassword}>
            <div>
              <h1>{t('passwordTitle')}</h1>
              <p>{t('forgotSubtitle')}</p>
            </div>
            <LanguageSelect locale={locale} onChange={setLocale} />
            <label>{t('email')}<input name="email" type="email" autoComplete="email" required /></label>
            <button type="submit" disabled={authBusy}>{t('sendEmail')}</button>
            <div className="auth-links">
              <button type="button" onClick={() => { setAuthMode('login'); setError(''); }}>{t('backToLogin')}</button>
            </div>
            {authMessage && <p className="success">{authMessage}</p>}
            <p className="error">{error}</p>
          </form>
        )}

        {authMode === 'reset' && (
          <form className="login-panel" onSubmit={resetPassword}>
            <div>
              <h1>{t('newPassword')}</h1>
              <p>{t('newPasswordSubtitle')}</p>
            </div>
            <LanguageSelect locale={locale} onChange={setLocale} />
            <label>{t('password')}<input name="password" type="password" autoComplete="new-password" minLength={8} required /></label>
            <button type="submit" disabled={authBusy || !authToken}>{t('updatePassword')}</button>
            <p className="error">{error}</p>
          </form>
        )}

        {authMode === 'verify' && (
          <section className="login-panel">
            <div>
              <h1>Email</h1>
              <p>{t('verifyEmail')}</p>
            </div>
            <LanguageSelect locale={locale} onChange={setLocale} />
            <button type="button" onClick={verifyEmail} disabled={authBusy || !authToken}>{t('verifyEmail')}</button>
            <p className="error">{error}</p>
          </section>
        )}
      </main>
    );
  }

  const tabs: Array<{ id: TabName; label: string; icon: React.ReactNode }> = [
    { id: 'time', label: 'Час', icon: <List /> },
    { id: 'calendar', label: 'Календар', icon: <CalendarDays /> },
    { id: 'finance', label: 'Рахунок', icon: <FileText /> },
    { id: 'stats', label: 'Статистика', icon: <BarChart3 /> },
    { id: 'settings', label: 'Налаштування', icon: <Settings /> },
    { id: 'data', label: 'Дані', icon: <Database /> },
  ];
  if (session.role === 'admin') tabs.push({ id: 'admin', label: t('admin'), icon: <Shield /> });

  if (activeTab === 'time' && (entryDraftDay || editingEntry)) {
    return (
      <main className="app app-entry-time">
        <TimeTab
          summary={summary}
          clients={activeClients}
          projects={activeProjects}
          entries={entries}
          onSubmit={submitEntry}
          onRefresh={loadAll}
          onMarkPaid={markPaid}
          onDelete={deleteEntry}
          onCopy={copyEntry}
          onEdit={editEntry}
          draftDay={entryDraftDay}
          editEntry={editingEntry}
          lastClientId={lastClientId}
          lastProjectId={lastProjectId}
          onCancel={() => {
            setEntryDraftDay(null);
            setEditingEntry(null);
            setActiveTab('calendar');
          }}
        />
        {toast && <div className="toast">{toast}</div>}
      </main>
    );
  }

  if (activeTab === 'clients') {
    return (
      <main className="app app-service app-clients">
        <ClientsTab
          clients={clients}
          entries={entries}
          onBack={() => {
            setActiveTab('time');
            setHomeVisible(true);
          }}
          onSubmit={(event, clientId) => submitForm(event, clientId ? `/api/clients/${clientId}` : '/api/clients', clientId ? 'Клієнта оновлено' : 'Клієнта додано', clientId ? 'PUT' : 'POST')}
          onArchive={archiveClient}
          onDelete={deleteClient}
          onCopy={copyClient}
        />
        {toast && <div className="toast">{toast}</div>}
      </main>
    );
  }

  if (activeTab === 'projects') {
    return (
      <main className="app app-service app-projects">
        <ProjectsTab
          clients={activeClients}
          projects={activeProjects}
          entries={entries}
          onBack={() => {
            setActiveTab('time');
            setHomeVisible(true);
          }}
          onSubmit={(event, projectId) => submitForm(event, projectId ? `/api/projects/${projectId}` : '/api/projects', projectId ? 'Проєкт оновлено' : 'Проєкт додано', projectId ? 'PUT' : 'POST')}
          onArchive={(project) => archive(`/api/projects/${project.id}`)}
        />
        {toast && <div className="toast">{toast}</div>}
      </main>
    );
  }

  if (activeTab === 'settings') {
    return (
      <main className="app app-service app-settings">
        <SettingsTab theme={theme} onThemeChange={setTheme} onBack={() => {
          setActiveTab('time');
          setHomeVisible(true);
        }} />
      </main>
    );
  }

  if (activeTab === 'profile') {
    return (
      <main className="app app-service app-profile">
        <ProfileTab
          profile={session}
          onBack={() => {
            setActiveTab('time');
            setHomeVisible(true);
          }}
          onLogout={logout}
          onPasswordChange={changeProfilePassword}
          onEmailChange={changeProfileEmail}
          onDeleteAccount={deleteAccount}
          onSave={saveProfile}
          locale={locale}
          onLocaleChange={setLocale}
          t={t}
        />
        {toast && <div className="toast">{toast}</div>}
      </main>
    );
  }

  if (activeTab === 'admin') {
    return (
      <main className="app app-service app-admin">
        <AdminTab
          t={t}
          onBack={() => {
            setActiveTab('time');
            setHomeVisible(true);
          }}
        />
      </main>
    );
  }

  return (
    <main className={`app app-${activeTab}`}>
      {homeVisible && (
        <>
          <header className="topbar">
            <div>
              <h1>{tabTitles[activeTab]}</h1>
              <span>{session.display_name || session.username}</span>
            </div>
            <div className="top-icons">
              <button className="icon-btn" onClick={() => { setActiveTab('profile'); setHomeVisible(false); }} title="Профіль"><UserCircle /></button>
              <button className="icon-btn" onClick={() => { setActiveTab('projects'); setHomeVisible(false); }} title="Проєкти"><Folder /></button>
              <button className="icon-btn" onClick={() => { setActiveTab('clients'); setHomeVisible(false); }} title="Клієнти"><User /></button>
              <button className="icon-btn" onClick={() => { setActiveTab('settings'); setHomeVisible(false); }} title="Довідка"><CircleHelp /></button>
              <button className="icon-btn" onClick={exportEntriesCsv} title={t('exportCsv')}><Download /></button>
              <button className="icon-btn" onClick={logout} title="Вийти"><Mail /></button>
            </div>
          </header>

          <nav className="module-grid" aria-label="Розділи">
            {tabs.map((tab) => (
              <button key={tab.id} data-tab={tab.id} className={`module-tile ${activeTab === tab.id ? 'active' : ''}`} onClick={() => { setActiveTab(tab.id); setHomeVisible(false); }}>
                <span className="tile-icon">{tab.icon}</span>
                <strong>{tab.label}</strong>
              </button>
            ))}
          </nav>
        </>
      )}

      {!homeVisible && activeTab === 'time' && <TimeTab summary={summary} clients={activeClients} projects={activeProjects} entries={entries} onSubmit={submitEntry} onRefresh={loadAll} onMarkPaid={markPaid} onDelete={deleteEntry} onCopy={copyEntry} onEdit={editEntry} draftDay={entryDraftDay} editEntry={editingEntry} lastClientId={lastClientId} lastProjectId={lastProjectId} onAdd={openEntryForDay} onBack={() => setHomeVisible(true)} />}
      {!homeVisible && activeTab === 'calendar' && <CalendarTab month={calendarMonth} selectedDay={selectedDay} entries={entries} setMonth={setCalendarMonth} setSelectedDay={setSelectedDay} onSwipeBack={() => setHomeVisible(true)} onAddEntry={openEntryForDay} onEditEntry={editEntry} touchStart={touchStart} />}
      {!homeVisible && activeTab === 'finance' && <FinanceTab summary={summary} expenses={expenses} mileages={mileages} onExpense={(event) => submitForm(event, '/api/expenses', 'Витрату додано')} onMileage={(event) => submitForm(event, '/api/mileages', 'Mileage додано')} onBack={() => setHomeVisible(true)} />}
      {!homeVisible && activeTab === 'stats' && <StatsTab summary={summary} onBack={() => setHomeVisible(true)} />}
      {!homeVisible && activeTab === 'data' && <InfoTab title="Дані" text="Дані зберігаються в Docker volume PostgreSQL. Бекапи робляться на рівні бази." onBack={() => setHomeVisible(true)} />}
      {toast && <div className="toast">{toast}</div>}
    </main>
  );
}
