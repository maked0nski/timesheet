import type React from 'react';
import type { Expense, Mileage, Summary } from '../../types';
import { money, todayValue } from '../../utils';
import { TabHeader } from '../../components/Shared';

export function FinanceTab(props: {
  summary: Summary;
  expenses: Expense[];
  mileages: Mileage[];
  onExpense: (event: React.FormEvent<HTMLFormElement>) => void;
  onMileage: (event: React.FormEvent<HTMLFormElement>) => void;
  onBack: () => void;
}) {
  const rows = [
    ...props.expenses.map((item) => ({ type: 'Expense', date: item.occurred_at, amount: item.amount, note: item.note })),
    ...props.mileages.map((item) => ({ type: 'Mileage', date: item.occurred_at, amount: item.amount, note: item.note })),
  ].sort((a, b) => String(b.date).localeCompare(String(a.date)));

  return (
    <section className="tab-page active">
      <TabHeader title="Рахунок" onBack={props.onBack} />
      <section className="summary-strip"><article><strong>{money(props.summary.paid_amount)}</strong><span>Оплачено</span></article><article><strong>{money(props.summary.expenses_amount)}</strong><span>Витрати</span></article><article><strong>{money(props.summary.mileage_amount)}</strong><span>Mileage</span></article></section>
      <div className="finance-grid">
        <form className="panel form-grid compact" onSubmit={props.onExpense}><h2>Витрата</h2><label>Дата<input name="occurred_at" type="date" required defaultValue={todayValue()} /></label><label>Сума<input name="amount" type="number" step="0.01" min="0" required /></label><label className="wide">Нотатка<input name="note" /></label><button type="submit">Додати витрату</button></form>
        <form className="panel form-grid compact" onSubmit={props.onMileage}><h2>Mileage</h2><label>Дата<input name="occurred_at" type="date" required defaultValue={todayValue()} /></label><label>Дистанція<input name="distance" type="number" step="0.01" min="0" required /></label><label>Сума<input name="amount" type="number" step="0.01" min="0" required /></label><label className="wide">Нотатка<input name="note" /></label><button type="submit">Додати mileage</button></form>
      </div>
      <section className="panel"><div className="table-wrap"><table><thead><tr><th>Тип</th><th>Дата</th><th>Сума</th><th>Нотатка</th></tr></thead><tbody>{rows.map((row, index) => <tr key={`${row.type}-${index}`}><td>{row.type}</td><td>{new Date(row.date).toLocaleDateString()}</td><td>{money(row.amount)}</td><td>{row.note}</td></tr>)}</tbody></table></div></section>
    </section>
  );
}
