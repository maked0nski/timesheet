import type { ThemeMode } from '../../types';
import { ArrowLeft, Database, Moon, ShieldCheck, Sun } from 'lucide-react';

export function SettingsTab({ theme, onThemeChange, onBack }: { theme: ThemeMode; onThemeChange: (theme: ThemeMode) => void; onBack: () => void }) {
  return (
    <section className="service-page settings-service-page">
      <header className="service-header"><button className="service-icon back" onClick={onBack}><ArrowLeft /></button><h1>Налаштування</h1></header>
      <section className="settings-list">
        <div className="settings-row">
          <span className="settings-icon">{theme === 'dark' ? <Moon /> : <Sun />}</span>
          <div>
            <strong>Тема</strong>
            <span>Світлий або темний вигляд програми</span>
          </div>
          <div className="segmented">
            <button type="button" className={theme === 'light' ? 'active' : ''} onClick={() => onThemeChange('light')}>Світла</button>
            <button type="button" className={theme === 'dark' ? 'active' : ''} onClick={() => onThemeChange('dark')}>Темна</button>
          </div>
        </div>
        <div className="settings-row">
          <span className="settings-icon"><ShieldCheck /></span>
          <div><strong>Авторизація</strong><span>Вхід логіном і паролем через серверну сесію</span></div>
        </div>
        <div className="settings-row">
          <span className="settings-icon"><Database /></span>
          <div><strong>Дані</strong><span>PostgreSQL у Docker volume. Бекап робиться на рівні бази.</span></div>
        </div>
      </section>
    </section>
  );
}
