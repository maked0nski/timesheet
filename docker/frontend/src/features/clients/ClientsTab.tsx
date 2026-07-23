import React from 'react';
import { ArrowLeft, Copy, Edit3, MoreVertical, Plus, Search, Trash2, X } from 'lucide-react';
import type { Client, Entry } from '../../types';
import { hoursLabel, money } from '../../utils';

export function ClientsTab(props: {
  clients: Client[];
  entries: Entry[];
  onBack: () => void;
  onSubmit: (event: React.FormEvent<HTMLFormElement>, clientId?: number) => void | Promise<void>;
  onArchive: (client: Client) => void | boolean | Promise<void | boolean>;
  onDelete: (client: Client) => void | boolean | Promise<void | boolean>;
  onCopy: (client: Client) => Promise<Client>;
}) {
  const [mode, setMode] = React.useState<'list' | 'info' | 'form'>('list');
  const [editing, setEditing] = React.useState<Client | null>(null);
  const [menuOpen, setMenuOpen] = React.useState(false);
  const [searchOpen, setSearchOpen] = React.useState(false);
  const [searchQuery, setSearchQuery] = React.useState('');
  const searchInputRef = React.useRef<HTMLInputElement>(null);
  const selected = editing || props.clients[0] || null;
  const visibleClients = props.clients.filter((client) => matchesClientSearch(client, searchQuery));
  const activeClients = visibleClients.filter((client) => client.is_active);
  const archivedClients = visibleClients.filter((client) => !client.is_active);
  const showDefaultClient = matchesText('Клієнт за замовчуванням', searchQuery);

  React.useEffect(() => {
    if (searchOpen) searchInputRef.current?.focus();
  }, [searchOpen]);

  function openForm(client: Client | null) {
    setEditing(client);
    setMode('form');
  }

  function openInfo(client: Client) {
    setEditing(client);
    setMode('info');
  }

  async function submitClient(event: React.FormEvent<HTMLFormElement>) {
    await props.onSubmit(event, editing?.id);
    setEditing(null);
    setMode('list');
  }

  async function copyClient(client: Client) {
    const copied = await props.onCopy(client);
    setMenuOpen(false);
    setEditing(copied);
    setMode('form');
  }

  async function archiveClient(client: Client) {
    setMenuOpen(false);
    const archived = await props.onArchive(client);
    if (archived === false) return;
    setEditing(null);
    setMode('list');
  }

  async function deleteClient(client: Client) {
    setMenuOpen(false);
    const deleted = await props.onDelete(client);
    if (deleted === false) return;
    setEditing(null);
    setMode('list');
  }

  if (mode === 'form') {
    return (
      <section className="service-page">
        <ServiceHeader title={editing ? 'Оновити клієнта' : 'Додати клієнта'} onBack={() => setMode('list')} />
        <form key={editing?.id || 'new-client'} className="panel form-grid matrix-form service-form client-service-form" onSubmit={submitClient}>
          <label data-title="Ім'я"><input name="name" required defaultValue={editing?.name || ''} /></label>
          <input type="hidden" name="is_active" value={String(editing?.is_active ?? true)} />
          <label data-title="Адреса 1"><input name="address" defaultValue={editing?.address || ''} /></label>
          <label data-title="Адреса 2"><input name="address_2" /></label>
          <label data-title="Адреса 3"><input name="address_3" /></label>
          <label data-title="Телефон"><input name="phone" defaultValue={editing?.phone || ''} /></label>
          <label data-title="Факс"><input name="fax" /></label>
          <label data-title="Ел. пошта"><input name="email" type="email" defaultValue={editing?.email || ''} /></label>
          <label data-title="Веб-сайт"><input name="website" /></label>
          <label data-title="Ід. номер"><input name="external_id" /></label>
          <label data-title="Опис"><input name="description" defaultValue={editing?.description || ''} /></label>
          <div className="service-actions">
            {editing && <button type="button" onClick={() => archiveClient(editing)}>Заархівувати</button>}
            <button type="submit">Зберегти</button>
          </div>
        </form>
      </section>
    );
  }

  if (mode === 'info' && selected) {
    const rows = props.entries.filter((entry) => entry.client_id === selected.id);
    const totalMinutes = rows.reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
    const paidMinutes = rows.filter((entry) => entry.is_paid).reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
    const totalAmount = rows.reduce((sum, entry) => sum + Number(entry.amount || 0), 0);
    const paidAmount = rows.filter((entry) => entry.is_paid).reduce((sum, entry) => sum + Number(entry.amount || 0), 0);

    return (
      <section className="service-page">
        <ServiceHeader
          title="Коротка інфор..."
          onBack={() => setMode('list')}
          actions={<><button className="service-icon" aria-label="Редагувати" onClick={() => openForm(selected)}><Edit3 /></button><button className="service-icon" aria-label="Скопіювати" onClick={() => copyClient(selected)}><Copy /></button><MenuButton open={menuOpen} onToggle={() => setMenuOpen((value) => !value)} onArchive={() => archiveClient(selected)} onDelete={() => deleteClient(selected)} /></>}
        />
        <section className="service-info-card">
          <h2>{selected.name}</h2>
          <div className="status-line"><span>Статус</span><strong>{selected.is_active ? 'Активний' : 'Архівний'}</strong></div>
          <p>{selected.description || selected.address || 'Без опису'}</p>
        </section>
        <MetricBlock title="години" items={[[hoursLabel(totalMinutes), 'Загалом'], [hoursLabel(paidMinutes), 'Оплачено'], [hoursLabel(totalMinutes - paidMinutes), 'Неоплачений']]} />
        <MetricBlock title="Сума" items={[[money(totalAmount), 'Загалом'], [money(paidAmount), 'Оплачено'], [money(totalAmount - paidAmount), 'Неоплачений']]} />
        <MetricBlock title="Дохід" items={[[money(totalAmount), 'Робота'], [money(0), 'Витрати'], [money(0), 'Пробіг']]} />
        <MetricBlock title="Рахунок" items={[[money(paidAmount), 'Оплачено'], [money(totalAmount - paidAmount), 'Неоплачений'], [money(0), 'Невиставлені рахунки']]} />
      </section>
    );
  }

  return (
    <section className="service-page">
      <ServiceHeader
        title="Клієнт"
        onBack={props.onBack}
        searchSlot={searchOpen ? (
          <input
            ref={searchInputRef}
            className="service-search-input"
            value={searchQuery}
            onChange={(event) => setSearchQuery(event.currentTarget.value)}
            placeholder="Пошук"
            aria-label="Пошук клієнта"
          />
        ) : undefined}
        actions={(
          <>
            <button
              className="service-icon"
              aria-label={searchOpen ? 'Закрити пошук' : 'Пошук'}
              onClick={() => {
                if (searchOpen) setSearchQuery('');
                setSearchOpen((value) => !value);
              }}
            >
              {searchOpen ? <X /> : <Search />}
            </button>
          </>
        )}
      />
      <section className="service-list client-list">
        {showDefaultClient && <button className="service-row" onClick={() => openForm(null)}>
          <strong>Клієнт за замовчуванням</strong>
        </button>}
        {activeClients.map((client) => (
          <button className="service-row" key={client.id} onClick={() => openInfo(client)}>
            <strong>{client.name}</strong>
            <span>{client.description || client.address || client.email || client.phone || ''}</span>
          </button>
        ))}
        {archivedClients.length > 0 && <div className="service-section-title">Заархівовано</div>}
        {archivedClients.map((client) => (
          <button className="service-row archived" key={client.id} onClick={() => openInfo(client)}>
            <strong>{client.name}</strong>
            <span>{client.description || client.address || client.email || client.phone || ''}</span>
          </button>
        ))}
        {visibleClients.length === 0 && !showDefaultClient && <div className="service-empty">Нічого не знайдено</div>}
      </section>
      <button className="service-fab" onClick={() => openForm(null)}><Plus /></button>
    </section>
  );
}

function ServiceHeader({ title, onBack, actions, searchSlot }: { title: string; onBack: () => void; actions?: React.ReactNode; searchSlot?: React.ReactNode }) {
  return <header className="service-header"><button className="service-icon back" onClick={onBack}><ArrowLeft /></button>{searchSlot || <h1>{title}</h1>}<div className="service-header-actions">{actions}</div></header>;
}

function MenuButton({ open, onToggle, onArchive, onDelete }: { open: boolean; onToggle: () => void; onArchive: () => void; onDelete: () => void }) {
  return (
    <div className="service-menu-wrap">
      <button className="service-icon" onClick={onToggle} aria-haspopup="menu" aria-expanded={open}><MoreVertical /></button>
      {open && (
        <div className="service-menu" role="menu">
          <button type="button" role="menuitem" onClick={onArchive}><Trash2 /> Заархівувати</button>
          <button type="button" role="menuitem" onClick={onDelete}><Trash2 /> Видалити</button>
        </div>
      )}
    </div>
  );
}

function MetricBlock({ title, items }: { title: string; items: Array<[string, string]> }) {
  return <section className="service-info-card metric-block"><h2>{title}</h2><div className="metric-grid">{items.map(([value, label]) => <div key={label}><strong>{value}</strong><span>{label}</span></div>)}</div></section>;
}

function matchesClientSearch(client: Client, query: string) {
  const value = query.trim().toLocaleLowerCase('uk-UA');
  if (!value) return true;
  return [client.name, client.description || '', client.address || '', client.email || '', client.phone || '']
    .join(' ')
    .toLocaleLowerCase('uk-UA')
    .includes(value);
}

function matchesText(text: string, query: string) {
  const value = query.trim().toLocaleLowerCase('uk-UA');
  return !value || text.toLocaleLowerCase('uk-UA').includes(value);
}
