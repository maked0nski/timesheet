import React from 'react';
import { ArrowLeft, MoreVertical, Shield, Trash2 } from 'lucide-react';
import { api } from '../../api';
import type { AdminUser, AuditEvent } from '../../types';

type Props = {
  onBack: () => void;
  t: (key: 'admin' | 'users' | 'activity' | 'block' | 'unblock' | 'delete') => string;
};

function hours(minutes: number) {
  return `${(minutes / 60).toFixed(1)} h`;
}

export function AdminTab({ onBack, t }: Props) {
  const [users, setUsers] = React.useState<AdminUser[]>([]);
  const [audit, setAudit] = React.useState<AuditEvent[]>([]);
  const [view, setView] = React.useState<'users' | 'activity'>('users');

  async function load() {
    const [nextUsers, nextAudit] = await Promise.all([
      api<AdminUser[]>('/api/admin/users'),
      api<AuditEvent[]>('/api/admin/audit'),
    ]);
    setUsers(nextUsers);
    setAudit(nextAudit);
  }

  React.useEffect(() => {
    load().catch(console.error);
  }, []);

  async function updateUser(user: AdminUser, patch: Partial<AdminUser>) {
    await api(`/api/admin/users/${user.id}`, {
      method: 'PATCH',
      body: JSON.stringify({ is_active: patch.is_active ?? user.is_active, role: patch.role ?? user.role }),
    });
    await load();
  }

  async function deleteUser(user: AdminUser) {
    if (!window.confirm(`Delete ${user.email || user.username}?`)) return;
    await api(`/api/admin/users/${user.id}`, { method: 'DELETE' });
    await load();
  }

  return (
    <section className="service-page admin-page">
      <header className="service-header">
        <button className="service-icon back" onClick={onBack} title="Back"><ArrowLeft /></button>
        <h1>{t('admin')}</h1>
        <span />
      </header>
      <div className="admin-tabs">
        <button className={view === 'users' ? 'active' : ''} onClick={() => setView('users')}>{t('users')}</button>
        <button className={view === 'activity' ? 'active' : ''} onClick={() => setView('activity')}>{t('activity')}</button>
      </div>

      {view === 'users' && (
        <div className="admin-list">
          {users.map((user) => (
            <article className="admin-row" key={user.id}>
              <div>
                <strong>{user.display_name || user.email || user.username}</strong>
                <span>{user.email || user.username}</span>
                <em>{user.role} · {user.is_active ? 'active' : 'blocked'} · {user.entries_count} · {hours(user.worked_minutes)}</em>
              </div>
              <div className="admin-actions">
                <button title="role" onClick={() => updateUser(user, { role: user.role === 'admin' ? 'user' : 'admin' })}><Shield /></button>
                <button onClick={() => updateUser(user, { is_active: !user.is_active })}>{user.is_active ? t('block') : t('unblock')}</button>
                <button title={t('delete')} onClick={() => deleteUser(user)}><Trash2 /></button>
              </div>
            </article>
          ))}
        </div>
      )}

      {view === 'activity' && (
        <div className="admin-list">
          {audit.map((event) => (
            <article className="admin-row compact" key={event.id}>
              <div>
                <strong>{event.action}</strong>
                <span>{event.display_name || event.email || `user ${event.user_id || '-'}`}</span>
                <em>{new Date(event.created_at).toLocaleString()}</em>
              </div>
              <MoreVertical />
            </article>
          ))}
        </div>
      )}
    </section>
  );
}
