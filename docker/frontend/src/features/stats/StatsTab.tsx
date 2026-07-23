import type { Summary } from '../../types';
import { MetricCard, TabHeader } from '../../components/Shared';
import { hoursLabel, money } from '../../utils';

export function StatsTab({ summary, onBack }: { summary: Summary; onBack: () => void }) {
  const totalHours = Number(summary.total_minutes || 0);
  const workIncome = Number(summary.total_amount || 0);
  const costs = Number(summary.expenses_amount || 0) + Number(summary.mileage_amount || 0);
  const effectiveRate = totalHours > 0 ? (workIncome - costs) / (totalHours / 60) : 0;
  return (
    <section className="tab-page active stats-page">
      <TabHeader title="Статистика" onBack={onBack} />
      <section className="info-card">
        <h2>Коротка інформація</h2>
        <div className="status-line"><span>Фільтр</span><strong>Немає</strong></div>
      </section>
      <MetricCard title="години" items={[[hoursLabel(summary.total_minutes), 'Загалом'], [hoursLabel(summary.paid_minutes), 'Оплачено'], [hoursLabel(summary.unpaid_minutes), 'Неоплачений']]} />
      <MetricCard title="Сума" items={[[money(summary.total_amount), 'Загалом'], [money(summary.paid_amount), 'Оплачено'], [money(summary.unpaid_amount), 'Неоплачений']]} />
      <MetricCard title="Дохід" items={[[money(summary.total_amount), 'Робота'], [money(summary.expenses_amount), 'Витрати'], [money(summary.mileage_amount), 'Пробіг']]} />
      <MetricCard title="Ефективна погодинна ставка" items={[[money(workIncome - costs), 'Робота'], [hoursLabel(summary.total_minutes), 'Загальна'], [money(effectiveRate), 'За год.']]} />
    </section>
  );
}
