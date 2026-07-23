import type React from 'react';

export type Session = UserProfile & { authenticated: boolean; username: string | null };

export type UserProfile = {
  id?: number;
  username: string | null;
  email?: string | null;
  display_name?: string | null;
  phone?: string | null;
  bio?: string | null;
  avatar_url?: string | null;
  email_verified?: boolean;
  role?: 'user' | 'admin';
  is_active?: boolean;
  locale?: 'uk' | 'en';
};

export type Summary = {
  total_minutes: number;
  paid_minutes: number;
  unpaid_minutes: number;
  total_amount: number;
  paid_amount: number;
  unpaid_amount: number;
  expenses_amount: number;
  mileage_amount: number;
};

export type Client = {
  id: number;
  name: string;
  address: string | null;
  phone: string | null;
  email: string | null;
  description: string | null;
  is_active: boolean;
};

export type Project = {
  id: number;
  client_id: number | null;
  client_name: string | null;
  name: string;
  billing_type: 'hourly' | 'fixed';
  hourly_rate: number | string;
  fixed_rate: number | string;
  default_break_minutes: number;
  is_billable_default: boolean;
  color: string | null;
  is_active: boolean;
};

export type Entry = {
  id: number;
  project_id: number;
  client_id: number | null;
  project_name: string | null;
  client_name: string | null;
  start_at: string;
  end_at: string;
  break_minutes: number;
  worked_minutes: number;
  applied_rate: number | string;
  amount: number | string;
  task_description: string | null;
  is_billable: boolean;
  is_paid: boolean;
};

export type Expense = { id: number; occurred_at: string; amount: number | string; note: string | null };
export type Mileage = { id: number; occurred_at: string; distance: number | string; amount: number | string; note: string | null };

export type TabName = 'time' | 'calendar' | 'finance' | 'stats' | 'settings' | 'data' | 'clients' | 'projects' | 'profile' | 'admin';
export type ThemeMode = 'light' | 'dark';

export type SubmitHandler = (event: React.FormEvent<HTMLFormElement>) => void;

export type AdminUser = {
  id: number;
  username: string;
  email: string | null;
  display_name: string | null;
  role: 'user' | 'admin';
  is_active: boolean;
  email_verified: boolean;
  entries_count: number;
  worked_minutes: number;
  created_at: string;
};

export type AuditEvent = {
  id: number;
  user_id: number | null;
  action: string;
  target_type: string | null;
  target_id: number | null;
  meta: Record<string, unknown>;
  created_at: string;
  email: string | null;
  display_name: string | null;
};
