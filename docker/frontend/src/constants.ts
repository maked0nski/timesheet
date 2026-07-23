import type { Summary, TabName } from './types';

export const tabTitles: Record<TabName, string> = {
  time: 'Табель',
  calendar: 'Календар',
  finance: 'Рахунок',
  stats: 'Статистика',
  settings: 'Налаштування',
  data: 'Дані',
  clients: 'Клієнти',
  projects: 'Проєкти',
  profile: 'Профіль',
  admin: 'Адмін',
};

export const emptySummary: Summary = {
  total_minutes: 0,
  paid_minutes: 0,
  unpaid_minutes: 0,
  total_amount: 0,
  paid_amount: 0,
  unpaid_amount: 0,
  expenses_amount: 0,
  mileage_amount: 0,
};
