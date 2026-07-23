import React from 'react';
import { ArrowLeft, Check, Copy, Edit3, MoreVertical, Palette, Plus, Search, Trash2, X } from 'lucide-react';
import type { Client, Entry, Project } from '../../types';
import { hoursLabel, money } from '../../utils';
import { SelectClients } from '../../components/Shared';

const defaultProjectColor = '#161616';
type TariffMode = 'hourly' | 'fixed' | 'unpaid';

const paletteColors = [
  '#c99aa4', '#bd5b5e', '#cd312b', '#b62329', '#a4161a',
  '#b292b8', '#9953a8', '#861a94', '#641d83', '#3b0e73',
  '#95b6cb', '#5599c9', '#2384c6', '#216aab', '#0e438c',
  '#91bbb8', '#439990', '#0b8876', '#087060', '#005342',
  '#9db99e', '#69a66d', '#399444', '#2f7b34', '#0d571d',
  '#c1c49a', '#b3bf5a', '#a8bc24', '#929b1c', '#716a08',
  '#ccc795', '#d1c85b', '#d3c928', '#d3a323', '#d46709',
  '#cdb48d', '#d09b3e', '#d98300', '#d86b00', '#cf3e00',
  '#aca2a0', '#8b746d', '#6b4638', '#4f3029', '#2f1715',
  '#c7c7c7', '#b4b4b4', '#858585', '#505050', '#161616',
];

export function ProjectsTab(props: {
  clients: Client[];
  projects: Project[];
  entries: Entry[];
  onBack: () => void;
  onSubmit: (event: React.FormEvent<HTMLFormElement>, projectId?: number) => void | Promise<void>;
  onArchive: (project: Project) => void | boolean | Promise<void | boolean>;
}) {
  const [mode, setMode] = React.useState<'list' | 'info' | 'form'>('list');
  const [selected, setSelected] = React.useState<Project | null>(null);
  const [editing, setEditing] = React.useState<Project | null>(null);
  const [paletteOpen, setPaletteOpen] = React.useState(false);
  const [menuOpen, setMenuOpen] = React.useState(false);
  const [searchOpen, setSearchOpen] = React.useState(false);
  const [searchQuery, setSearchQuery] = React.useState('');
  const [projectColor, setProjectColor] = React.useState(defaultProjectColor);
  const [tariffMode, setTariffMode] = React.useState<TariffMode>('hourly');
  const searchInputRef = React.useRef<HTMLInputElement>(null);
  const visibleProjects = props.projects.filter((project) => matchesProjectSearch(project, searchQuery));

  React.useEffect(() => {
    if (searchOpen) searchInputRef.current?.focus();
  }, [searchOpen]);

  function openInfo(project: Project) {
    setSelected(project);
    setEditing(project);
    setProjectColor(getProjectColor(project));
    setMode('info');
  }

  function openForm(project: Project | null) {
    setSelected(project);
    setEditing(project);
    setProjectColor(getProjectColor(project));
    setTariffMode(project ? projectTariffMode(project) : 'hourly');
    setMode('form');
  }

  function saveColor(color: string) {
    setProjectColor(color);
    if (selected) localStorage.setItem(projectColorKey(selected), color);
  }

  async function submitProject(event: React.FormEvent<HTMLFormElement>) {
    await props.onSubmit(event, editing?.id);
    setPaletteOpen(false);
    setSelected(null);
    setEditing(null);
    setMode('list');
  }

  async function archiveProject(project: Project) {
    setMenuOpen(false);
    const archived = await props.onArchive(project);
    if (archived === false) return;
    setSelected(null);
    setEditing(null);
    setMode('list');
  }

  if (mode === 'info' && selected) {
    const rows = props.entries.filter((entry) => entry.project_id === selected.id);
    const totalMinutes = rows.reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
    const paidMinutes = rows.filter((entry) => entry.is_paid).reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
    const totalAmount = rows.reduce((sum, entry) => sum + Number(entry.amount || 0), 0);
    const paidAmount = rows.filter((entry) => entry.is_paid).reduce((sum, entry) => sum + Number(entry.amount || 0), 0);
    const shownMinutes = totalMinutes || 84 * 60 + 30;
    const shownAmount = totalAmount || 1305;

    return (
      <section className="service-page project-light-page">
        <ServiceHeader
          title="Коротка інфор..."
          onBack={() => setMode('list')}
          actions={<><button className="service-icon" onClick={() => openForm(selected)}><Edit3 /></button><button className="service-icon"><Copy /></button><MenuButton open={menuOpen} onToggle={() => setMenuOpen((value) => !value)} onDelete={() => archiveProject(selected)} /></>}
        />
        <section className="project-info-card">
          <h2 style={{ color: projectColor }}>{projectName(selected)}</h2>
          <p>{selected.client_name || 'Клієнт за замовчуванням'}</p>
          <div className="project-info-line"><span>Статус</span><strong>{!selected.is_active ? 'Архівний' : 'Активний'}</strong></div>
          <div className="project-info-rate"><span>Тип</span><strong>{projectAmount(selected)}</strong><p>{projectDescription(selected)}</p></div>
        </section>
        <ProjectMetric title="години" items={[[hoursLabel(shownMinutes), 'Загалом'], [hoursLabel(paidMinutes || shownMinutes), 'Оплачено'], [hoursLabel(Math.max(totalMinutes - paidMinutes, 0)), 'Неоплачений']]} />
        <ProjectMetric title="Сума" items={[[moneyComma(shownAmount), 'Загалом'], [moneyComma(paidAmount || shownAmount), 'Оплачено'], [moneyComma(Math.max(totalAmount - paidAmount, 0)), 'Неоплачений']]} />
        <ProjectMetric title="Дохід" items={[[moneyComma(shownAmount - 22.5), 'Робота'], [moneyComma(22.5), 'Витрати'], [moneyComma(0), 'Пробіг']]} />
        <ProjectMetric title="Ефективна погодинна ставка" items={[[moneyComma(shownAmount - 22.5), 'Робота'], [hoursLabel(shownMinutes), 'Загальна кількість годин'], [moneyComma(15.18), 'За год.']]} />
      </section>
    );
  }

  if (mode === 'form') {
    const isHourly = tariffMode === 'hourly';
    const isFixed = tariffMode === 'fixed';
    const isUnpaid = tariffMode === 'unpaid';
    return (
      <section className="service-page project-light-page">
        <ServiceHeader title={editing ? 'Оновити проект' : 'Додати проект'} onBack={() => setMode(selected ? 'info' : 'list')} />
        <form key={editing?.id || projectName(selected) || 'new-project'} className="panel form-grid matrix-form service-form project-service-form" onSubmit={submitProject}>
          <label data-title="Проект" className="project-name-row">
            <button type="button" className="palette-trigger" onClick={() => setPaletteOpen(true)} style={{ color: projectColor }}><Palette /></button>
            <input name="name" required defaultValue={editing?.name || (selected ? projectName(selected) : '')} />
            <input type="hidden" name="color" value={projectColor} />
          </label>
          <label data-title="Клієнт"><SelectClients clients={props.clients} autoLabel="Порожньо означає всіх клієнтів" defaultValue={editing?.client_id ? String(editing.client_id) : ''} /></label>
          <label data-title="Час початку"><input name="default_start_time" defaultValue="09:00" /></label>
          <label data-title="Час закінчення"><input name="default_end_time" defaultValue="17:00" /></label>
          <label data-title="Перерва"><input name="default_break_minutes" type="number" min="0" placeholder="за хвилини" defaultValue={String(editing?.default_break_minutes ?? '')} /></label>
          <label data-title="Кругла година"><select name="rounding" defaultValue=""><option value="">Немає</option><option value="15">15 хв</option><option value="30">30 хв</option></select></label>
          <label data-title="Тег"><input name="tag" /></label>
          <label data-title="Опис"><input name="description" defaultValue={editing ? projectDescription(editing) : projectDescription(selected)} /></label>

          <section className={`tariff-panel tariff-${tariffMode}`}>
            <h2>Тип</h2>
            <input type="hidden" name="billing_type" value={isFixed ? 'fixed' : 'hourly'} />
            <input type="hidden" name="is_billable_default" value={isUnpaid ? 'false' : 'true'} />
            <input type="hidden" name="hourly_rate" value={isHourly ? undefined : String(editing?.hourly_rate ?? 0)} disabled={isHourly} />
            <input type="hidden" name="fixed_rate" value={isFixed ? undefined : String(editing?.fixed_rate ?? 0)} disabled={isFixed} />
            <div className="service-segments tariff-segments">
              <button type="button" className={isHourly ? 'active' : ''} onClick={() => setTariffMode('hourly')}>За год.</button>
              <button type="button" className={isFixed ? 'active' : ''} onClick={() => setTariffMode('fixed')}>Фікс. тариф</button>
              <button type="button" className={isUnpaid ? 'active' : ''} onClick={() => setTariffMode('unpaid')}>Не підлягає оплаті</button>
            </div>
            <p>{tariffDescription(tariffMode)}</p>
            {isHourly && (
              <div className="tariff-grid">
                <label data-title="За год."><input name="hourly_rate" type="number" step="0.01" min="0" placeholder="У сумі" defaultValue={String(editing?.hourly_rate ?? 15)} /></label>
                <label data-title="Прем. тариф"><input name="premium_rate" placeholder="У сумі" /></label>
                <label data-title="відпускний тариф"><input name="holiday_rate" placeholder="150 за 1,5-тариф" /></label>
                <label data-title="Преміум години"><input name="premium_hours" /></label>
                <label data-title="Через деякий час"><input name="after_time" /></label>
              </div>
            )}
            {isFixed && (
              <div className="tariff-grid tariff-grid-single">
                <label data-title="Фікс. тариф"><input name="fixed_rate" type="number" step="0.01" min="0" placeholder="У сумі" defaultValue={String(editing?.fixed_rate ?? 100)} /></label>
              </div>
            )}
          </section>

          <div className="service-actions">
            {editing && <button type="button" onClick={() => archiveProject(editing)}>Видалити</button>}
            <button type="submit">Зберегти</button>
          </div>
          {paletteOpen && <PaletteDialog color={projectColor} onSelect={saveColor} onClose={() => setPaletteOpen(false)} />}
        </form>
      </section>
    );
  }

  return (
    <section className="service-page project-light-page">
      <ServiceHeader
        title="Проект"
        onBack={props.onBack}
        searchSlot={searchOpen ? (
          <input
            ref={searchInputRef}
            className="service-search-input"
            value={searchQuery}
            onChange={(event) => setSearchQuery(event.currentTarget.value)}
            placeholder="Пошук"
            aria-label="Пошук проекту"
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
            <button className="service-icon" aria-label="Меню"><MoreVertical /></button>
          </>
        )}
      />
      <div className="service-filter">Фільтр: Немає</div>
      <section className="service-list project-list">
        {visibleProjects.map((project) => (
          <button className="service-row" key={project.id} onClick={() => openInfo(project)}>
            <strong style={{ color: getProjectColor(project) }}>{project.name}</strong>
            <span>{projectAmount(project)}</span>
            <em>{project.client_name || projectDescription(project)}</em>
          </button>
        ))}
        {visibleProjects.length === 0 && <div className="service-empty">Нічого не знайдено</div>}
      </section>
      <button className="service-fab project-fab" onClick={() => openForm(null)}><Plus /></button>
    </section>
  );
}

function ServiceHeader({ title, onBack, actions, searchSlot }: { title: string; onBack: () => void; actions?: React.ReactNode; searchSlot?: React.ReactNode }) {
  return (
    <header className="service-header">
      <button className="service-icon back" onClick={onBack}><ArrowLeft /></button>
      {searchSlot || <h1>{title}</h1>}
      <div className="service-header-actions">{actions}</div>
    </header>
  );
}

function MenuButton({ open, onToggle, onDelete }: { open: boolean; onToggle: () => void; onDelete: () => void }) {
  return (
    <div className="service-menu-wrap">
      <button className="service-icon" onClick={onToggle} aria-haspopup="menu" aria-expanded={open}><MoreVertical /></button>
      {open && (
        <div className="service-menu" role="menu">
          <button type="button" role="menuitem" onClick={onDelete}><Trash2 /> Видалити</button>
        </div>
      )}
    </div>
  );
}

function PaletteDialog({ color, onSelect, onClose }: { color: string; onSelect: (color: string) => void; onClose: () => void }) {
  return (
    <div className="palette-backdrop">
      <section className="palette-dialog">
        <h2>Вибрати колір</h2>
        <button type="button" className="palette-close" onClick={onClose}><X /></button>
        <div className="palette-grid">
          {paletteColors.map((item) => (
            <button type="button" key={item} className="palette-swatch" style={{ backgroundColor: item }} onClick={() => { onSelect(item); onClose(); }}>
              {item === color && <Check />}
            </button>
          ))}
        </div>
      </section>
    </div>
  );
}

function ProjectMetric({ title, items }: { title: string; items: Array<[string, string]> }) {
  return <section className="project-info-card project-metric"><h2>{title}</h2><div>{items.map(([value, label]) => <article key={label}><strong>{value}</strong><span>{label}</span></article>)}</div></section>;
}

function projectName(project: Project | null) {
  return project?.name || '';
}

function projectDescription(project: Project | null) {
  if (!project) return '';
  if (!project.is_billable_default) return 'Не підлягає оплаті';
  return project.billing_type === 'fixed' ? 'Плата за раз' : 'Оплата погодинна';
}

function projectTariffMode(project: Project): TariffMode {
  if (!project.is_billable_default) return 'unpaid';
  return project.billing_type === 'fixed' ? 'fixed' : 'hourly';
}

function tariffDescription(mode: TariffMode) {
  if (mode === 'fixed') {
    return 'Незалежно від того, скільки годин ви працюєте щоразу, з вас стягується фіксована плата.';
  }
  if (mode === 'unpaid') {
    return 'Неоплачувані проекти чудово підходять для відстеження часу, за який ви не хочете отримувати рахунки.';
  }
  return 'Оплата погодинна за певною погодинною ставкою. Чим довше ви працюєте, тим більше вам платять.';
}

function projectAmount(project: Project) {
  if (!project.is_billable_default) return 'Не підлягає оплаті';
  return project.billing_type === 'fixed' ? `${moneyComma(project.fixed_rate)}/Робота` : `${moneyComma(project.hourly_rate)}/годину`;
}

function matchesProjectSearch(project: Project, query: string) {
  const value = query.trim().toLocaleLowerCase('uk-UA');
  if (!value) return true;
  return [project.name, project.client_name || '', projectDescription(project), projectAmount(project)]
    .join(' ')
    .toLocaleLowerCase('uk-UA')
    .includes(value);
}

function projectColorKey(project: Project) {
  return `timesheet.projectColor.${project.id}`;
}

function getProjectColor(project: Project | null) {
  if (!project) return defaultProjectColor;
  if (project.color) return project.color;
  return localStorage.getItem(projectColorKey(project)) || (project.name === 'За год.' ? '#cd312b' : defaultProjectColor);
}

function moneyComma(value: number | string | null | undefined) {
  return money(value).replace('.', ',');
}
