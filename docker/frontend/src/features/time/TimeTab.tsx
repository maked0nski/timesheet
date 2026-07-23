import React from 'react';
import { ArrowLeft, BarChart3, Columns3, Filter, ListFilter, MoreVertical, Plus, Search, Share2, X } from 'lucide-react';
import type { Client, Entry, Project, Summary } from '../../types';
import { dateKey, defaultEntryRange, hoursLabel, localDateTimeValue, money, weekNumber } from '../../utils';
import { SelectClients, SelectProjects } from '../../components/Shared';

type PeriodMode = 'year' | 'month' | 'half' | 'fourWeeks' | 'twoWeeks' | 'week' | 'day';
type EntryFilter = 'all' | 'open' | 'paid';

const periodLabels: Record<PeriodMode, string> = {
  year: 'Рік',
  month: 'Місяць',
  half: 'Півмісяця',
  fourWeeks: 'Чотири тижні',
  twoWeeks: 'Два тижні',
  week: 'Тиждень',
  day: 'День',
};

const periodOptions: PeriodMode[] = ['year', 'month', 'half', 'fourWeeks', 'twoWeeks', 'week', 'day'];

export function TimeTab(props: {
  summary: Summary;
  clients: Client[];
  projects: Project[];
  entries: Entry[];
  onSubmit: (event: React.FormEvent<HTMLFormElement>, entry?: Entry) => void;
  onRefresh: () => void;
  onMarkPaid: (entry: Entry) => void;
  onDelete: (entry: Entry) => void;
  onCopy: (event: React.MouseEvent<HTMLButtonElement>, entry: Entry) => void;
  onEdit: (entry: Entry) => void;
  draftDay: Date | null;
  editEntry: Entry | null;
  lastClientId: string;
  lastProjectId: string;
  onAdd?: (day: Date) => void;
  onBack?: () => void;
  onCancel?: () => void;
}) {
  const isEditing = Boolean(props.editEntry);
  const { start, end } = props.editEntry
    ? { start: new Date(props.editEntry.start_at), end: new Date(props.editEntry.end_at) }
    : defaultEntryRange(props.draftDay || new Date());
  const formKey = props.editEntry
    ? `edit-${props.editEntry.id}`
    : `${props.draftDay ? dateKey(props.draftDay) : 'today'}-${props.lastClientId}-${props.lastProjectId}`;
  const entryMode = props.draftDay !== null || props.editEntry !== null;
  const initialWorkHours = decimalHours(props.editEntry?.worked_minutes ?? 8 * 60);
  const initialStartDate = dateInputValue(start);
  const initialStartTime = timeInputValue(start);
  const initialEndDate = dateInputValue(end);
  const initialEndTime = timeInputValue(end);
  const defaultProjectId = props.editEntry ? String(props.editEntry.project_id) : props.lastProjectId;
  const defaultClientId = props.editEntry?.client_id ? String(props.editEntry.client_id) : props.lastClientId;
  const defaultBreakMinutes = String(props.editEntry?.break_minutes ?? 0);
  const [selectedProjectId, setSelectedProjectId] = React.useState(defaultProjectId);
  const [startDate, setStartDate] = React.useState(initialStartDate);
  const [startTime, setStartTime] = React.useState(initialStartTime);
  const [endDate, setEndDate] = React.useState(initialEndDate);
  const [endTime, setEndTime] = React.useState(initialEndTime);
  const [breakMinutes, setBreakMinutes] = React.useState(defaultBreakMinutes);
  const [workHours, setWorkHours] = React.useState(initialWorkHours);
  const [periodMode, setPeriodMode] = React.useState<PeriodMode>('week');
  const [anchorDate, setAnchorDate] = React.useState(() => new Date());
  const [periodMenuOpen, setPeriodMenuOpen] = React.useState(false);
  const [moreMenuOpen, setMoreMenuOpen] = React.useState(false);
  const [searchOpen, setSearchOpen] = React.useState(false);
  const [searchQuery, setSearchQuery] = React.useState('');
  const [entryFilter, setEntryFilter] = React.useState<EntryFilter>('all');
  const searchInputRef = React.useRef<HTMLInputElement>(null);
  const ledgerTouchStart = React.useRef({ x: 0, y: 0 });
  const selectedProject = props.projects.find((project) => String(project.id) === selectedProjectId);
  const defaultAppliedRate = props.editEntry
    ? Number(props.editEntry.applied_rate || 0)
    : selectedProject
      ? Number(selectedProject.billing_type === 'fixed' ? selectedProject.fixed_rate : selectedProject.hourly_rate)
      : 0;
  const rateLabel = selectedProject?.billing_type === 'fixed' ? 'Ставка' : 'За год.';

  React.useEffect(() => {
    setSelectedProjectId(defaultProjectId);
    setStartDate(initialStartDate);
    setStartTime(initialStartTime);
    setEndDate(initialEndDate);
    setEndTime(initialEndTime);
    setBreakMinutes(defaultBreakMinutes);
    setWorkHours(initialWorkHours);
  }, [formKey, defaultProjectId, defaultBreakMinutes, initialWorkHours, initialStartDate, initialStartTime, initialEndDate, initialEndTime]);

  React.useEffect(() => {
    if (searchOpen) searchInputRef.current?.focus();
  }, [searchOpen]);

  const setEndFromWorkHours = (nextStartDate = startDate, nextStartTime = startTime, nextWorkHours = workHours, nextBreakMinutes = breakMinutes) => {
    const nextEnd = addWorkTime(nextStartDate, nextStartTime, nextWorkHours, nextBreakMinutes);
    setEndDate(nextEnd.date);
    setEndTime(nextEnd.time);
  };

  const setWorkHoursFromEnd = (nextEndDate = endDate, nextEndTime = endTime) => {
    setWorkHours(workHoursBetween(startDate, startTime, nextEndDate, nextEndTime, breakMinutes));
  };

  if (entryMode) {
    return (
      <section className="entry-page tab-page active">
        <header className="entry-header">
          <button type="button" className="entry-back" onClick={props.onCancel} aria-label="Назад">‹</button>
          <h1>{isEditing ? 'Редагувати час' : 'Додати час'}</h1>
        </header>
        <form key={formKey} className="panel form-grid matrix-form time-entry-form entry-time-form" onSubmit={(event) => props.onSubmit(event, props.editEntry || undefined)}>
          <label data-title="Проект"><SelectProjects projects={props.projects} defaultValue={defaultProjectId} onChange={setSelectedProjectId} /></label>
          <label data-title="Клієнт"><SelectClients clients={props.clients} autoLabel="Клієнт за замовчуванням" defaultValue={defaultClientId} /></label>
          <label data-title="Час початку" className="date-time-row">
            <input name="start_at" type="hidden" value={combineLocalDateTime(startDate, startTime)} readOnly />
            <DateTimeControl
              date={startDate}
              time={startTime}
              onDateChange={(value) => {
                setStartDate(value);
                setEndFromWorkHours(value, startTime);
              }}
              onTimeChange={(value) => {
                setStartTime(value);
                setEndFromWorkHours(startDate, value);
              }}
            />
          </label>
          <label data-title="Час закінчення" className="date-time-row">
            <input name="end_at" type="hidden" value={combineLocalDateTime(endDate, endTime)} readOnly />
            <DateTimeControl
              date={endDate}
              time={endTime}
              onDateChange={(value) => {
                setEndDate(value);
                setWorkHoursFromEnd(value, endTime);
              }}
              onTimeChange={(value) => {
                setEndTime(value);
                setWorkHoursFromEnd(endDate, value);
              }}
            />
          </label>
          <label data-title="Перерва"><input name="break_minutes" type="number" min="0" placeholder="за хвилини" value={breakMinutes} onChange={(event) => {
            const nextBreak = event.currentTarget.value;
            setBreakMinutes(nextBreak);
            setEndFromWorkHours(startDate, startTime, workHours, nextBreak);
          }} /></label>
          <label data-title="Робочі години" className="work-hours-row"><input data-role="worked-hours" type="number" step="0.25" min="0" value={workHours} onChange={(event) => {
            const nextHours = event.currentTarget.value;
            setWorkHours(nextHours);
            setEndFromWorkHours(startDate, startTime, nextHours);
          }} /></label>
          <label data-title={rateLabel}><input key={`${formKey}-${selectedProjectId}-${defaultAppliedRate}`} name="applied_rate" type="number" step="0.01" min="0" defaultValue={defaultAppliedRate ? String(defaultAppliedRate.toFixed(2)) : ''} placeholder="0.00" /></label>
          <label data-title="опис"><input name="task_description" placeholder="Яке завдання ви виконали?" defaultValue={props.editEntry?.task_description || ''} /></label>
          <label data-title="Примітка"><input name="note" /></label>
          <label data-title="Статус"><select name="is_paid" defaultValue={String(props.editEntry?.is_paid ?? false)}><option value="false">Відкрити</option><option value="true">Оплачено</option></select></label>
          <label data-title="Тег"><input name="tag" /></label>
          <label data-title="Підлягає оплаті" className="billable-row"><input name="is_billable" type="checkbox" defaultChecked={props.editEntry?.is_billable ?? true} /></label>
          <div className="entry-actions">
            {isEditing && props.editEntry ? (
              <>
                <button type="button" className="danger" onClick={() => props.onDelete(props.editEntry as Entry)}>Видалити</button>
                <button type="button" onClick={(event) => props.onCopy(event, props.editEntry as Entry)}>Скопіювати</button>
                <button type="submit" name="after_submit" value="finish">Оновити</button>
              </>
            ) : (
              <>
                <button type="submit" name="after_submit" value="create">Зберегти та створити</button>
                <button type="submit" name="after_submit" value="finish">Зберегти та завершити</button>
              </>
            )}
          </div>
        </form>
      </section>
    );
  }

  const range = periodRange(anchorDate, periodMode);
  const shownEntries = props.entries
    .filter((entry) => {
      const started = new Date(entry.start_at);
      if (started < range.start || started > range.end) return false;
      if (entryFilter === 'paid' && !entry.is_paid) return false;
      if (entryFilter === 'open' && entry.is_paid) return false;
      return matchesEntrySearch(entry, searchQuery);
    })
    .sort((a, b) => new Date(a.start_at).getTime() - new Date(b.start_at).getTime());
  const totalMinutes = shownEntries.reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
  const totalAmount = shownEntries.reduce((sum, entry) => sum + Number(entry.amount || 0), 0);
  const groupedEntries = groupEntriesByDay(shownEntries);

  return (
    <section
      className="tab-page active time-ledger-page"
      onTouchStart={(event) => {
        ledgerTouchStart.current = { x: event.changedTouches[0].clientX, y: event.changedTouches[0].clientY };
      }}
      onTouchEnd={(event) => {
        const dx = event.changedTouches[0].clientX - ledgerTouchStart.current.x;
        const dy = event.changedTouches[0].clientY - ledgerTouchStart.current.y;
        if (Math.abs(dx) > 70 && Math.abs(dy) < 70) {
          shiftPeriod(dx < 0 ? 1 : -1, periodMode, setAnchorDate);
          setPeriodMenuOpen(false);
          setMoreMenuOpen(false);
        }
      }}
    >
      <header className="time-ledger-header">
        <button type="button" className="time-icon" onClick={props.onBack} aria-label="Назад"><ArrowLeft /></button>
        <div className="time-title-wrap">
          {searchOpen ? (
            <input
              ref={searchInputRef}
              className="time-search-input"
              value={searchQuery}
              onChange={(event) => setSearchQuery(event.currentTarget.value)}
              placeholder="Пошук"
              aria-label="Пошук записів часу"
            />
          ) : (
            <button type="button" className="time-period-button" onClick={() => setPeriodMenuOpen((value) => !value)}>
              <span>Час</span>
              <strong>{periodLabels[periodMode]}</strong>
            </button>
          )}
          {!searchOpen && <button type="button" className="time-period-caret" onClick={() => setPeriodMenuOpen((value) => !value)} aria-label="Вибрати період">▾</button>}
          {periodMenuOpen && (
            <div className="time-period-menu">
              {periodOptions.map((option) => (
                <button
                  key={option}
                  type="button"
                  className={option === periodMode ? 'active' : ''}
                  onClick={() => {
                    setPeriodMode(option);
                    setPeriodMenuOpen(false);
                  }}
                >
                  {periodLabels[option]}
                </button>
              ))}
            </div>
          )}
        </div>
        <button
          type="button"
          className="time-icon"
          aria-label={searchOpen ? 'Закрити пошук' : 'Пошук'}
          onClick={() => {
            if (searchOpen) setSearchQuery('');
            setSearchOpen((value) => !value);
            setPeriodMenuOpen(false);
          }}
        >
          {searchOpen ? <X /> : <Search />}
        </button>
        <div className="time-menu-wrap">
          <button type="button" className="time-icon" aria-label="Меню" onClick={() => setMoreMenuOpen((value) => !value)}><MoreVertical /></button>
          {moreMenuOpen && (
            <div className="time-more-menu">
              <button type="button" onClick={() => { shiftPeriod(-1, periodMode, setAnchorDate); setMoreMenuOpen(false); }}>Назад</button>
              <button type="button" onClick={() => { shiftPeriod(1, periodMode, setAnchorDate); setMoreMenuOpen(false); }}>Далі</button>
              <button type="button" onClick={() => setMoreMenuOpen(false)}>Настроюваний період</button>
              <button type="button" onClick={() => setMoreMenuOpen(false)}>Кілька записів</button>
              <button type="button" onClick={() => setMoreMenuOpen(false)}>Імпорт</button>
            </div>
          )}
        </div>
      </header>

      <section className="time-ledger-summary">
        <div>
          <strong>{rangeTitle(range, periodMode)}</strong>
          <span>Фільтр: {filterLabel(entryFilter)}</span>
        </div>
        <div>
          <strong>#{shownEntries.length} {hoursLabel(totalMinutes)}</strong>
          <span>{moneyComma(totalAmount)}</span>
        </div>
      </section>

      <section className="time-ledger-list">
        {groupedEntries.map((group) => (
          <article key={group.key} className="time-day-group">
            <header>
              <strong>{dayHeader(group.date)}</strong>
              <span>{moneyComma(group.amount)} {hoursLabel(group.minutes)}</span>
            </header>
            {group.entries.map((entry) => <TimeEntryRow key={entry.id} entry={entry} onClick={() => props.onEdit(entry)} />)}
          </article>
        ))}
      </section>

      <nav className="time-bottom-bar" aria-label="Дії часу">
        <button type="button" aria-label="Поділитися"><Share2 /></button>
        <button type="button" aria-label="Фільтр" onClick={() => setEntryFilter(nextFilter(entryFilter))}><Filter /></button>
        <button type="button" aria-label="Сортування"><ListFilter /></button>
        <button type="button" aria-label="Вигляд"><Columns3 /></button>
        <button type="button" aria-label="Звіт"><BarChart3 /></button>
        <button type="button" className="time-add" aria-label="Додати час" onClick={() => props.onAdd?.(new Date())}><Plus /></button>
      </nav>
    </section>
  );
}

function TimeEntryRow({ entry, onClick }: { entry: Entry; onClick: () => void }) {
  const start = new Date(entry.start_at);
  const end = new Date(entry.end_at);
  return (
    <button type="button" className={`time-entry-row ${entry.is_paid ? 'paid' : 'open'}`} onClick={onClick}>
      <span className="time-entry-marker" />
      <span className="time-entry-main">
        <strong>{timeRangeLabel(start, end)}</strong>
        <span><b>{entry.client_name || 'Клієнт за замовчуванням'}</b> <em>{entry.project_name || entry.task_description || 'Запис часу'}</em></span>
      </span>
      <span className="time-entry-total">
        <strong>{hoursLabel(entry.worked_minutes)}</strong>
        <span>{moneyComma(entry.amount)}</span>
      </span>
    </button>
  );
}

function periodRange(anchor: Date, mode: PeriodMode) {
  const base = startOfDay(anchor);
  if (mode === 'day') return { start: base, end: endOfDay(base) };
  if (mode === 'week') {
    const start = startOfWeek(base);
    return { start, end: endOfDay(addDays(start, 6)) };
  }
  if (mode === 'twoWeeks') {
    const start = startOfWeek(base);
    return { start, end: endOfDay(addDays(start, 13)) };
  }
  if (mode === 'fourWeeks') {
    const start = startOfWeek(base);
    return { start, end: endOfDay(addDays(start, 27)) };
  }
  if (mode === 'half') {
    const firstHalf = base.getDate() <= 15;
    const start = new Date(base.getFullYear(), base.getMonth(), firstHalf ? 1 : 16);
    const end = firstHalf ? new Date(base.getFullYear(), base.getMonth(), 15) : new Date(base.getFullYear(), base.getMonth() + 1, 0);
    return { start, end: endOfDay(end) };
  }
  if (mode === 'month') {
    const start = new Date(base.getFullYear(), base.getMonth(), 1);
    return { start, end: endOfDay(new Date(base.getFullYear(), base.getMonth() + 1, 0)) };
  }
  const start = new Date(base.getFullYear(), 0, 1);
  return { start, end: endOfDay(new Date(base.getFullYear(), 11, 31)) };
}

function shiftPeriod(direction: -1 | 1, mode: PeriodMode, setAnchorDate: React.Dispatch<React.SetStateAction<Date>>) {
  setAnchorDate((current) => {
    const next = new Date(current);
    if (mode === 'year') next.setFullYear(next.getFullYear() + direction);
    else if (mode === 'month') next.setMonth(next.getMonth() + direction);
    else if (mode === 'half') next.setDate(next.getDate() + direction * 15);
    else if (mode === 'fourWeeks') next.setDate(next.getDate() + direction * 28);
    else if (mode === 'twoWeeks') next.setDate(next.getDate() + direction * 14);
    else if (mode === 'week') next.setDate(next.getDate() + direction * 7);
    else next.setDate(next.getDate() + direction);
    return next;
  });
}

function groupEntriesByDay(entries: Entry[]) {
  const groups = new Map<string, { key: string; date: Date; entries: Entry[]; minutes: number; amount: number }>();
  for (const entry of entries) {
    const date = new Date(entry.start_at);
    const key = dateKey(date);
    const group = groups.get(key) || { key, date, entries: [], minutes: 0, amount: 0 };
    group.entries.push(entry);
    group.minutes += Number(entry.worked_minutes || 0);
    group.amount += Number(entry.amount || 0);
    groups.set(key, group);
  }
  return Array.from(groups.values());
}

function rangeTitle(range: { start: Date; end: Date }, mode: PeriodMode) {
  if (mode === 'day') return range.start.toLocaleDateString('uk-UA', { weekday: 'short', day: 'numeric', month: 'long', year: 'numeric' });
  if (mode === 'month') return range.start.toLocaleDateString('uk-UA', { month: 'long', year: 'numeric' }).replace(/^./, (value) => value.toUpperCase());
  if (mode === 'year') return String(range.start.getFullYear());
  const startDay = range.start.getDate();
  const endDay = range.end.getDate();
  const month = range.end.toLocaleDateString('uk-UA', { month: 'long' }).replace(/^./, (value) => value.toUpperCase());
  return `т${weekNumber(range.start)} · ${startDay}–${endDay} ${month} ${range.end.getFullYear()}`;
}

function dayHeader(date: Date) {
  return date.toLocaleDateString('uk-UA', { weekday: 'short', day: 'numeric' }).replace('.', '');
}

function timeRangeLabel(start: Date, end: Date) {
  return `${timeLabel(start)} - ${timeLabel(end)}`;
}

function timeLabel(date: Date) {
  return date.toLocaleTimeString('uk-UA', { hour: '2-digit', minute: '2-digit' });
}

function filterLabel(filter: EntryFilter) {
  if (filter === 'paid') return 'Оплачено';
  if (filter === 'open') return 'Неоплачено';
  return 'Немає';
}

function nextFilter(filter: EntryFilter): EntryFilter {
  if (filter === 'all') return 'open';
  if (filter === 'open') return 'paid';
  return 'all';
}

function matchesEntrySearch(entry: Entry, query: string) {
  const value = query.trim().toLocaleLowerCase('uk-UA');
  if (!value) return true;
  return [entry.project_name || '', entry.client_name || '', entry.task_description || '', moneyComma(entry.amount)]
    .join(' ')
    .toLocaleLowerCase('uk-UA')
    .includes(value);
}

function startOfWeek(date: Date) {
  const start = startOfDay(date);
  start.setDate(start.getDate() - ((start.getDay() + 6) % 7));
  return start;
}

function startOfDay(date: Date) {
  const result = new Date(date);
  result.setHours(0, 0, 0, 0);
  return result;
}

function endOfDay(date: Date) {
  const result = new Date(date);
  result.setHours(23, 59, 59, 999);
  return result;
}

function addDays(date: Date, days: number) {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

function moneyComma(value: number | string | null | undefined) {
  return money(value).replace('.', ',');
}

function DateTimeControl(props: {
  date: string;
  time: string;
  onDateChange: (value: string) => void;
  onTimeChange: (value: string) => void;
}) {
  const dateInputRef = React.useRef<HTMLInputElement>(null);
  const timeInputRef = React.useRef<HTMLInputElement>(null);

  return (
    <div className="date-time-control">
      <button type="button" className="date-time-display date-part" onClick={() => openPicker(dateInputRef)}>{shortDate(props.date)}</button>
      <button type="button" className="date-time-display time-part" onClick={() => openPicker(timeInputRef)}>{shortTime(props.time)}</button>
      <input ref={dateInputRef} className="date-time-native" type="date" value={props.date} onChange={(event) => props.onDateChange(event.currentTarget.value)} aria-label="Дата" />
      <input ref={timeInputRef} className="date-time-native" type="time" value={props.time} onChange={(event) => props.onTimeChange(event.currentTarget.value)} aria-label="Час" />
    </div>
  );
}

function openPicker(ref: React.RefObject<HTMLInputElement | null>) {
  const input = ref.current;
  if (!input) return;
  if (typeof input.showPicker === 'function') {
    input.showPicker();
    return;
  }
  input.focus();
}

function dateInputValue(date: Date) {
  return localDateTimeValue(date).slice(0, 10);
}

function timeInputValue(date: Date) {
  return localDateTimeValue(date).slice(11, 16);
}

function combineLocalDateTime(date: string, time: string) {
  return `${date}T${time || '00:00'}`;
}

function shortDate(date: string) {
  const [, month = '', day = ''] = date.split('-');
  return `${day}.${month}`;
}

function shortTime(time: string) {
  return (time || '00:00').replace(/^0/, '');
}

function decimalHours(minutes: number | string | null | undefined) {
  const value = Number(minutes || 0) / 60;
  return trimNumber(value);
}

function parseDecimal(value: string) {
  const parsed = Number(value.replace(',', '.'));
  return Number.isFinite(parsed) ? parsed : 0;
}

function parseBreakMinutes(value: string) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

function addWorkTime(date: string, time: string, workHours: string, breakMinutes: string) {
  const start = new Date(combineLocalDateTime(date, time));
  const minutes = Math.round(parseDecimal(workHours) * 60) + parseBreakMinutes(breakMinutes);
  const end = new Date(start.getTime() + minutes * 60000);
  return { date: dateInputValue(end), time: timeInputValue(end) };
}

function workHoursBetween(startDate: string, startTime: string, endDate: string, endTime: string, breakMinutes: string) {
  const start = new Date(combineLocalDateTime(startDate, startTime));
  const end = new Date(combineLocalDateTime(endDate, endTime));
  const totalMinutes = Math.max(0, Math.round((end.getTime() - start.getTime()) / 60000) - parseBreakMinutes(breakMinutes));
  return trimNumber(totalMinutes / 60);
}

function trimNumber(value: number) {
  return Number.isInteger(value) ? String(value) : value.toFixed(2).replace(/0+$/, '').replace(/\.$/, '');
}
