import type { Client, Project } from '../types';
import { ArrowLeft } from 'lucide-react';

export function SelectClients({ clients, autoLabel, defaultValue = '' }: { clients: Client[]; autoLabel: string; defaultValue?: string }) {
  return <select name="client_id" defaultValue={defaultValue}><option value="">{autoLabel}</option>{clients.map((client) => <option key={client.id} value={client.id}>{client.name}</option>)}</select>;
}

export function SelectProjects({ projects, defaultValue = '', onChange }: { projects: Project[]; defaultValue?: string; onChange?: (projectId: string) => void }) {
  return (
    <select name="project_id" required defaultValue={defaultValue} onChange={(event) => onChange?.(event.currentTarget.value)}>
      <option value="">Оберіть проєкт</option>
      {projects.map((project) => <option key={project.id} value={project.id}>{project.name}</option>)}
    </select>
  );
}

export function MetricCard({ title, items }: { title: string; items: Array<[string, string]> }) {
  return (
    <section className="metric-card">
      <h2>{title}</h2>
      <div className="metric-grid">
        {items.map(([value, label]) => (
          <div key={label}>
            <strong>{value}</strong>
            <span>{label}</span>
          </div>
        ))}
      </div>
    </section>
  );
}

export function TabHeader({ title, onBack }: { title: string; onBack: () => void }) {
  return (
    <header className="section-header">
      <button className="section-back" type="button" onClick={onBack} title="Назад"><ArrowLeft /></button>
      <h1>{title}</h1>
      <span />
    </header>
  );
}

export function InfoTab({ title, main, text, onBack }: { title: string; main?: string; text: string; onBack: () => void }) {
  return <section className="tab-page active"><TabHeader title={title} onBack={onBack} /><section className="panel empty-page"><h2>{title}</h2>{main && <div className="big-number">{main}</div>}<p>{text}</p></section></section>;
}
