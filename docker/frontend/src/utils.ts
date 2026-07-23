export function money(value: number | string | null | undefined) {
  return `£${Number(value || 0).toFixed(2)}`;
}

export function hours(minutes: number | string | null | undefined) {
  const value = Number(minutes || 0);
  return `${String(Math.floor(value / 60)).padStart(2, '0')}:${String(value % 60).padStart(2, '0')}`;
}

export function hoursLabel(minutes: number | string | null | undefined) {
  return `${hours(minutes)}г`;
}

export function localDateTimeValue(date = new Date()) {
  const shifted = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
  return shifted.toISOString().slice(0, 16);
}

export function defaultEntryRange(day = new Date()) {
  const start = new Date(day);
  start.setHours(9, 0, 0, 0);
  const end = new Date(day);
  end.setHours(17, 0, 0, 0);
  return { start, end };
}

export function todayValue() {
  return new Date().toISOString().slice(0, 10);
}

export function dateKey(date: Date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

export function sameDay(a: Date, b: Date) {
  return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
}

export function weekNumber(date: Date) {
  const first = new Date(date.getFullYear(), 0, 1);
  const dayMs = 24 * 60 * 60 * 1000;
  return Math.ceil(((date.getTime() - first.getTime()) / dayMs + first.getDay() + 1) / 7);
}

export function monthName(date: Date) {
  return date.toLocaleDateString('uk-UA', { month: 'long', year: 'numeric' }).replace(/^./, (c) => c.toUpperCase());
}
