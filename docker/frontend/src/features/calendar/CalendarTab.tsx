import React from 'react';
import type { Entry } from '../../types';
import { dateKey, hours, hoursLabel, money, monthName, sameDay, weekNumber } from '../../utils';

const monthLabels = ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'];

export function CalendarTab(props: {
  month: Date;
  selectedDay: Date;
  entries: Entry[];
  setMonth: (date: Date) => void;
  setSelectedDay: (date: Date) => void;
  onSwipeBack: () => void;
  onAddEntry: (day: Date) => void;
  onEditEntry: (entry: Entry) => void;
  touchStart: React.MutableRefObject<{ x: number; y: number }>;
}) {
  const [pickerOpen, setPickerOpen] = React.useState(false);
  const lastTap = React.useRef<{ key: string; time: number }>({ key: '', time: 0 });
  const byDay = new Map<string, { minutes: number; amount: number; paidAmount: number; unpaidAmount: number; entries: Entry[] }>();
  for (const entry of props.entries) {
    const key = dateKey(new Date(entry.start_at));
    const acc = byDay.get(key) || { minutes: 0, amount: 0, paidAmount: 0, unpaidAmount: 0, entries: [] };
    acc.minutes += Number(entry.worked_minutes || 0);
    acc.amount += Number(entry.amount || 0);
    if (entry.is_paid) acc.paidAmount += Number(entry.amount || 0);
    else acc.unpaidAmount += Number(entry.amount || 0);
    acc.entries.push(entry);
    byDay.set(key, acc);
  }

  const first = new Date(props.month.getFullYear(), props.month.getMonth(), 1);
  const gridStart = new Date(first);
  gridStart.setDate(first.getDate() - ((first.getDay() + 6) % 7));
  const today = new Date();
  const cells: React.ReactNode[] = [];
  let monthMinutes = 0;
  let monthAmount = 0;
  let monthPaidAmount = 0;
  let monthUnpaidAmount = 0;

  for (let week = 0; week < 5; week += 1) {
    const weekStart = new Date(gridStart);
    weekStart.setDate(gridStart.getDate() + week * 7);
    let weekMinutes = 0;
    let weekAmount = 0;
    const weekCells: React.ReactNode[] = [];

    for (let day = 0; day < 7; day += 1) {
      const current = new Date(weekStart);
      current.setDate(weekStart.getDate() + day);
      const acc = byDay.get(dateKey(current));
      const isThisMonth = current.getMonth() === props.month.getMonth();
      const isSelected = sameDay(current, props.selectedDay);
      const currentKey = dateKey(current);
      const selectedKey = dateKey(props.selectedDay);
      if (isThisMonth && acc) {
        weekMinutes += acc.minutes;
        weekAmount += acc.amount;
        monthMinutes += acc.minutes;
        monthAmount += acc.amount;
        monthPaidAmount += acc.paidAmount;
        monthUnpaidAmount += acc.unpaidAmount;
      }
      const statusClass = acc ? (acc.paidAmount > 0 && acc.unpaidAmount > 0 ? 'mixed' : acc.unpaidAmount > 0 ? 'open-entry' : 'paid-entry') : '';
      weekCells.push(
        <button
          key={dateKey(current)}
          className={`calendar-cell ${isThisMonth ? '' : 'muted'} ${statusClass} ${current.getDay() === 0 || current.getDay() === 6 ? 'weekend' : ''} ${sameDay(current, today) ? 'today' : ''} ${isSelected ? 'selected' : ''}`}
          onClick={() => {
            if (!isThisMonth) return;
            const now = Date.now();
            const repeatedTap = lastTap.current.key === currentKey && now - lastTap.current.time < 800;
            lastTap.current = { key: currentKey, time: now };
            if (currentKey === selectedKey || repeatedTap) {
              props.onAddEntry(current);
              return;
            }
            props.setSelectedDay(new Date(current));
          }}
        >
          <span className="day-num">{current.getDate()}</span>
          {isThisMonth && isSelected && <span className="day-plus">+</span>}
          {acc && <div className="day-lines"><span className="day-hours">{hours(acc.minutes)}</span><span>{Math.round(acc.amount)}</span></div>}
        </button>,
      );
    }

    cells.push(<div key={`w-${week}`} className="calendar-cell week"><strong>{weekNumber(weekStart)}</strong><div className="day-lines"><span>{hours(weekMinutes)}</span><span>{Math.round(weekAmount)}</span></div></div>, ...weekCells);
  }

  const selectedEntries = props.entries.filter((entry) => dateKey(new Date(entry.start_at)) === dateKey(props.selectedDay));
  const selectedMinutes = selectedEntries.reduce((sum, entry) => sum + Number(entry.worked_minutes || 0), 0);
  const selectedAmount = selectedEntries.reduce((sum, entry) => sum + Number(entry.amount || 0), 0);
  const pickerYears = Array.from({ length: 11 }, (_, index) => props.month.getFullYear() - 5 + index);

  function changeMonth(delta: number) {
    props.setMonth(new Date(props.month.getFullYear(), props.month.getMonth() + delta, 1));
    setPickerOpen(false);
  }

  function chooseMonth(monthIndex: number, year: number) {
    props.setMonth(new Date(year, monthIndex, 1));
    setPickerOpen(false);
  }

  return (
    <section
      className="tab-page active"
      onTouchStart={(event) => {
        props.touchStart.current = { x: event.changedTouches[0].clientX, y: event.changedTouches[0].clientY };
      }}
      onTouchEnd={(event) => {
        const dx = event.changedTouches[0].clientX - props.touchStart.current.x;
        const dy = event.changedTouches[0].clientY - props.touchStart.current.y;
        if (Math.abs(dx) > 70 && Math.abs(dy) < 70) changeMonth(dx < 0 ? 1 : -1);
      }}
    >
      <section className="calendar-screen">
        <div className="calendar-toolbar">
          <button className="calendar-back" onClick={props.onSwipeBack} aria-label="Назад">‹</button>
          <div className="calendar-title-wrap">
            <button type="button" className="calendar-title" onClick={() => setPickerOpen((value) => !value)}>{monthName(props.month)} <span>⌄</span></button>
            {pickerOpen && (
              <div className="calendar-picker">
                <select value={props.month.getMonth()} onChange={(event) => chooseMonth(Number(event.target.value), props.month.getFullYear())}>
                  {monthLabels.map((label, index) => <option key={label} value={index}>{label}</option>)}
                </select>
                <select value={props.month.getFullYear()} onChange={(event) => chooseMonth(props.month.getMonth(), Number(event.target.value))}>
                  {pickerYears.map((year) => <option key={year} value={year}>{year}</option>)}
                </select>
              </div>
            )}
          </div>
          <div className="calendar-tools">
            <button type="button" onClick={() => changeMonth(-1)} aria-label="Попередній місяць">‹</button>
            <button type="button" onClick={() => changeMonth(1)} aria-label="Наступний місяць">›</button>
          </div>
        </div>
        <div className="calendar-total">
          <div><strong>#{weekNumber(first)}</strong><span>Фільтр: Немає</span></div>
          <div className="calendar-money-row">
            <span>Опл. {money(monthPaidAmount)}</span>
            <span>Борг {money(monthUnpaidAmount)}</span>
            <strong>{hoursLabel(monthMinutes)} {money(monthAmount)}</strong>
          </div>
        </div>
        <div className="calendar-weekdays"><span>тиж</span><span>Пн</span><span>Вт</span><span>Ср</span><span>Чт</span><span>Пт</span><span>Сб</span><span>Нд</span></div>
        <div className="calendar-grid">{cells}</div>
        <div className="calendar-details">
          <div className="calendar-day-summary">
            <strong>{props.selectedDay.toLocaleDateString('uk-UA', { day: '2-digit', month: '2-digit', weekday: 'short' })}</strong>
            <span>{hoursLabel(selectedMinutes)} {money(selectedAmount)}</span>
            <button className="calendar-add" onClick={() => props.onAddEntry(props.selectedDay)}>+</button>
          </div>
          <div className="calendar-entry-list" aria-label="Записи за день">
            {selectedEntries.map((entry) => <DetailEntry key={entry.id} entry={entry} onEdit={props.onEditEntry} />)}
          </div>
        </div>
      </section>
    </section>
  );
}

function DetailEntry({ entry, onEdit }: { entry: Entry; onEdit: (entry: Entry) => void }) {
  const start = new Date(entry.start_at);
  const end = new Date(entry.end_at);
  return (
    <button type="button" className={`detail-row detail-entry-button ${entry.is_paid ? 'paid-entry' : 'open-entry'}`} onClick={() => onEdit(entry)}>
      <span className="detail-main">
        <strong>{start.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })} - {end.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</strong>
        <p>{entry.project_name || entry.task_description || 'Запис часу'}</p>
      </span>
      <span className="amounts"><strong>{hoursLabel(entry.worked_minutes)}</strong><p>{money(entry.amount)}</p></span>
    </button>
  );
}
