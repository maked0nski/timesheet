// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Табель';

  @override
  String get menuTime => 'Час';

  @override
  String get menuCalendar => 'Календар';

  @override
  String get menuInvoice => 'Рахунок';

  @override
  String get menuInvoiceDisabled => 'Рахунок (вимкнено)';

  @override
  String get menuStatistics => 'Статистика';

  @override
  String get menuSettings => 'Налаштування';

  @override
  String get menuData => 'Дані';

  @override
  String get tooltipProjects => 'Проекти';

  @override
  String get tooltipClients => 'Клієнти';

  @override
  String get tooltipAppDescription => 'Опис роботи програми';

  @override
  String get tooltipContactDeveloper => 'Написати розробнику';

  @override
  String get moreTabTitle => 'Додатково';

  @override
  String get localizationSection => 'Локалізація';

  @override
  String get languageLabel => 'Мова';

  @override
  String get currencyLabel => 'Валюта';

  @override
  String get shareLabel => 'Поділитися';

  @override
  String get privacyLabel => 'Політика конфіденційності';

  @override
  String get themeLabel => 'Тема';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeLight => 'Світла';

  @override
  String get prefsDefaultsTitle => 'Значення за замовчуванням';

  @override
  String get prefsUseLastTitle => 'Використовувати останнє введене значення';

  @override
  String get prefsUseLastSubtitle =>
      'Використовувати останнє введене значення під час додавання запису';

  @override
  String get prefsMonthlyCalendarTitle => 'Місячний календар';

  @override
  String get prefsMonthlyCalendarSubtitle =>
      'Відображення даних у місячному календарі';

  @override
  String get prefsCurrencyFormatTitle => 'Формат валюти';

  @override
  String get prefsDateFormatTitle => 'Формат дати';

  @override
  String get prefsHoursFormatTitle => 'Формат годин';

  @override
  String get prefsTimeFormatTitle => 'Формат часу';

  @override
  String get prefsTimeFormatSubtitle => '24 години';

  @override
  String get prefsTimePickerStyleTitle => 'Стиль вибору часу';

  @override
  String get prefsTimePickerStyleSubtitle => 'Використовуйте циферблат';

  @override
  String get commonYes => 'Так';

  @override
  String get commonNo => 'Ні';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonSave => 'Зберегти';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonUpdate => 'Оновити';

  @override
  String get commonAdd => 'Додати';

  @override
  String get commonApply => 'Застосувати';

  @override
  String get commonReset => 'Скинути';

  @override
  String get commonFilterNone => 'Немає';

  @override
  String get commonStatus => 'Статус';

  @override
  String get statusOpen => 'Відкритий';

  @override
  String get statusPaid => 'Оплачений';

  @override
  String get commonProject => 'Проект';

  @override
  String get commonClient => 'Клієнт';

  @override
  String get commonTag => 'Тег';

  @override
  String get commonNote => 'Примітка';

  @override
  String get commonDescription => 'Опис';

  @override
  String get commonBreak => 'Перерва';

  @override
  String get commonStartTime => 'Час початку';

  @override
  String get commonEndTime => 'Час закінчення';

  @override
  String get commonWorkHours => 'Робочі години';

  @override
  String get commonHourlyRate => 'За год.';

  @override
  String get commonBillable => 'Підлягає оплаті';

  @override
  String get commonAddExpense => 'Додати витр./відр.';

  @override
  String get commonAddMileage => 'Додати пробіг';

  @override
  String get commonAddTime => 'Додати час';

  @override
  String get commonEditTime => 'Оновити час';

  @override
  String get commonSaveAndCreate => 'Зберегти та\nстворити';

  @override
  String get commonSaveAndFinish => 'Зберегти та\nзавершити';

  @override
  String get commonBreakMinutesSuffix => 'за хвилини';

  @override
  String get commonTaskHint => 'Яке завдання ви виконали?';

  @override
  String get commonDefaultClient => 'Клієнт за замовчуванням';

  @override
  String get commonAmount => 'Сума';

  @override
  String get commonDistanceKm => 'Дистанція (км)';

  @override
  String get expenseAddTitle => 'Додати витрати';

  @override
  String get mileageAddTitle => 'Додати пробіг';

  @override
  String get expenseAdded => 'Витрати додано';

  @override
  String get mileageAdded => 'Пробіг додано';

  @override
  String calendarFilter(Object value) {
    return 'Фільтр: $value';
  }

  @override
  String get calendarAddEntry => 'Додати запис (+)';

  @override
  String get calendarWeek => 'тиж';

  @override
  String get calendarMon => 'Пн';

  @override
  String get calendarTue => 'Вт';

  @override
  String get calendarWed => 'Ср';

  @override
  String get calendarThu => 'Чт';

  @override
  String get calendarFri => 'Пт';

  @override
  String get calendarSat => 'Сб';

  @override
  String get calendarSun => 'Нд';

  @override
  String get calendarRate => 'Тариф';

  @override
  String get timePeriodMonth => 'Місяць';

  @override
  String get timePeriodWeek => 'Тиждень';

  @override
  String get timeNoEntries => 'Немає записів за період';

  @override
  String get timeFilterTitle => 'Фільтр';

  @override
  String get timeFilterAll => 'Всі';

  @override
  String get timeFilterOpen => 'Відкриті';

  @override
  String get timeFilterPaid => 'Оплачені';

  @override
  String get timeSortDate => 'Дата';

  @override
  String get timeSortAmount => 'Сума';

  @override
  String get timeSortProject => 'Проект';

  @override
  String get timeSortClient => 'Клієнт';

  @override
  String get timeCreateProjectFirst => 'Спочатку створіть проект';

  @override
  String get clientTitle => 'Клієнт';

  @override
  String get clientAddTitle => 'Додати клієнта';

  @override
  String get clientUpdateTitle => 'Оновити клієнта';

  @override
  String get clientName => 'Ім\'я';

  @override
  String get clientAddress => 'Адреса';

  @override
  String get clientGeo => 'Геолокація';

  @override
  String get clientPhone => 'Телефон';

  @override
  String get clientEmail => 'Ел. пошта';

  @override
  String get clientDesc => 'Опис';

  @override
  String get clientNotFound => 'Клієнта не знайдено';

  @override
  String get clientNoClients => 'Немає клієнтів';

  @override
  String get clientQuickInfoTitle => 'Коротка інфор...';

  @override
  String get clientNameHint => 'Максимум 30 символів';

  @override
  String get projectTitle => 'Проект';

  @override
  String get projectAddTitle => 'Додати проект';

  @override
  String get projectUpdateTitle => 'Оновити проект';

  @override
  String get projectNoProjects => 'Немає проектів';

  @override
  String get projectNoName => 'Без назви';

  @override
  String get projectName => 'Проект';

  @override
  String get projectTypeHourly => 'За год.';

  @override
  String get projectTypeFixed => 'Фікс. тариф';

  @override
  String get projectNotBillable => 'Не підлягає оплаті';

  @override
  String get projectBudget => 'Бюджет';

  @override
  String get projectNoBudget => 'Немає бюджету';

  @override
  String get projectBudgetHours => 'Бюджетні години';

  @override
  String get projectBudgetFees => 'Бюджетні збори';

  @override
  String get projectClientAll => 'Порожньо означає всіх клієнтів';

  @override
  String get projectRoundHour => 'Кругла година';

  @override
  String get projectTypeLabel => 'Тип';

  @override
  String get projectTypeHourlyDesc =>
      'Оплата погодинна за певною погодинною ставкою. Чим довше ви працюєте, тим більше вам платять.';

  @override
  String get projectTypeFixedDesc =>
      'Незалежно від того, скільки годин ви працюєте щоразу, з вас стягується фіксована плата.';

  @override
  String get projectPremiumStub =>
      'Прем. тариф, Преміум години, Через деякий час (заглушка)';

  @override
  String get projectAmountHint => 'У сумі';

  @override
  String get dataTitle => 'База даних';

  @override
  String get dataAutoBackupTitle => 'Автоматичне резервне копіювання';

  @override
  String get dataAutoBackupSubtitle =>
      'Зберігати локальну копію БД в папці backups';

  @override
  String get dataCreateBackup => 'Створити резервну копію бази даних';

  @override
  String get dataCreateBackupSubtitle => 'Локальна копія .sqlite';

  @override
  String get dataRestoreBackup => 'Відновити базу даних';

  @override
  String get dataRestoreBackupSubtitle =>
      'Відновити з останньої резервної копії';

  @override
  String get dataEmailBackup => 'Надіслати базу даних ел. поштою';

  @override
  String get dataEmailBackupSubtitle => 'Показати шлях до останньої копії';

  @override
  String get dataDeleteAll => 'Видалити всі записи';

  @override
  String get dataDeleteAllSubtitle => 'Очистити таблиці клієнтів/проектів/часу';

  @override
  String get dataRecentBackups => 'Останні резервні копії';

  @override
  String get dataNoBackupsTitle => 'Немає резервних копій';

  @override
  String get dataNoBackupsSubtitle => 'Створіть першу копію кнопкою вище';

  @override
  String get dataRestoreConfirmTitle => 'Відновити копію';

  @override
  String get dataRestoreConfirmBody =>
      'Поточні дані будуть замінені. Продовжити?';

  @override
  String get dataRestored => 'Базу відновлено';

  @override
  String get dataBackupCreated => 'Backup створено';

  @override
  String get dataBackupNotFound => 'Backup не знайдено';

  @override
  String get dataRestoredRestart => 'Базу відновлено. Перезапустіть додаток.';

  @override
  String get dataBackupFolderLabel => 'Папка backup';

  @override
  String get dataConfirmTitle => 'Підтвердження';

  @override
  String get dataConfirmDeleteBody => 'Видалити всі записи?';

  @override
  String get dataCleared => 'Дані очищено';

  @override
  String get commonHoursSuffix => 'г';

  @override
  String get commonPerHourSuffix => '/год';

  @override
  String get commonDay => 'День';

  @override
  String get commonWeek => 'Тиждень';

  @override
  String get commonEnabled => 'Включити';

  @override
  String get commonDisabled => 'Відключити';

  @override
  String commonError(Object value) {
    return 'Помилка: $value';
  }

  @override
  String get calendarThisMonth => 'Цього місяця';

  @override
  String get startSampleProject => 'Джейн За Годину';

  @override
  String get startSampleClient => 'Джейн';

  @override
  String get startStartWork => 'Початок роботи';

  @override
  String get startStartedAt => 'Розпочато в';

  @override
  String get startDayLabel => 'День';

  @override
  String get startWeekLabel => 'Тиждень';

  @override
  String get clientHoursTitle => 'Години';

  @override
  String get clientTotalLabel => 'Загалом';

  @override
  String get clientPaidLabel => 'Оплачено';

  @override
  String get clientUnpaidLabel => 'Неоплачений';

  @override
  String get clientIncomeTitle => 'Дохід';

  @override
  String get clientWorkLabel => 'Робота';

  @override
  String get clientExpensesLabel => 'Витрати';

  @override
  String get clientMileageLabel => 'Пробіг';

  @override
  String get clientInvoiceTitle => 'Рахунок';

  @override
  String get clientExpectedLabel => 'Очікується';

  @override
  String get clientEffectiveRateTitle => 'Ефективна погодинна ставка';

  @override
  String get clientTotalHoursLabel => 'Загальна кількість годин';

  @override
  String get clientPerHourLabel => 'За год.';

  @override
  String get clientStatusLabel => 'Статус';

  @override
  String get clientStatusActive => 'Активний';

  @override
  String clientProjectFallback(Object id) {
    return 'Проект #$id';
  }

  @override
  String get settingsTabGeneral => 'Загальні';

  @override
  String get settingsTabTime => 'Час';

  @override
  String get settingsTabPreferences => 'Уподобання';

  @override
  String get settingsClientTitle => 'Клієнт';

  @override
  String get settingsClientSubtitle => 'Налаштувати декількох клієнтів';

  @override
  String get settingsProjectTitle => 'Проект';

  @override
  String get settingsProjectSubtitle =>
      'Заздалегідь задані проекти із вказаними ставками та правилами';

  @override
  String get settingsWorkDescTitle => 'Опис роботи';

  @override
  String get settingsWorkDescSubtitle => 'Попередній опис роботи';

  @override
  String get settingsExpensesTitle => 'Витрати/відрахування';

  @override
  String get settingsExpensesSubtitle => 'Встановлені витрати/вирахування';

  @override
  String get settingsHolidayTitle => 'Управління святом';

  @override
  String get settingsHolidaySubtitle =>
      'Якщо вихідний день застосовано, преміальні/понаднормові не використовуються';

  @override
  String get settingsPremiumTitle => 'Преміум години';

  @override
  String get settingsPremiumSubtitle =>
      'Якщо до запису часу застосовано преміум-годину, понаднормова робота не використовується';

  @override
  String get settingsAfterTimeTitle => 'Через деякий час';

  @override
  String get settingsAfterTimeSubtitle =>
      'Автоматично розраховувати понаднормову роботу';

  @override
  String get settingsTagTitle => 'Тег';

  @override
  String get settingsTagSubtitle => 'Фільтрувати та упорядкувати свої дані';

  @override
  String get settingsEmpty => 'Немає записів';

  @override
  String get settingsAddPreset => 'Додати запис';

  @override
  String get settingsEditPreset => 'Редагувати запис';

  @override
  String get settingsNameLabel => 'Назва';

  @override
  String get settingsIsDeduction => 'Відрахування';

  @override
  String get settingsMultiplierLabel => 'Множник';

  @override
  String get settingsWorkDescHint => 'Текст опису';

  @override
  String get settingsTagHint => 'Назва тегу';

  @override
  String get settingsTimeSection => 'Час';

  @override
  String get settingsConfirmStopTitle => 'Підтвердіть зупинку таймера';

  @override
  String get settingsConfirmStopSubtitle => 'Включити';

  @override
  String get settingsEditAfterStopTitle => 'Редагувати запис часу';

  @override
  String get settingsEditAfterStopSubtitle => 'Після зупинки таймера';

  @override
  String get settingsSwitchTimerTitle => 'Перемикання таймера';

  @override
  String get settingsSwitchTimerSubtitle => 'Дозволити перемикання проекту';

  @override
  String get settingsCheckinLocationTitle => 'Місце реєстрації приходу/виходу';

  @override
  String get settingsCheckinLocationSubtitle => 'Відключити';

  @override
  String get settingsCurrencyFormatTitle => 'Формат валюти';

  @override
  String get settingsTimeFormatTitle => 'Формат часу';

  @override
  String get settingsTimeFormatSubtitle => '24 години';

  @override
  String get settingsTimePickerStyleTitle => 'Стиль вибору часу';

  @override
  String get settingsTimePickerStyleSubtitle => 'Використовуйте циферблат';

  @override
  String get shareDescription => 'Поділіться додатком з друзями';

  @override
  String get languageNameUkr => 'Українська';

  @override
  String get languageNameEng => 'English (US)';

  @override
  String get languageNamePl => 'Polski';

  @override
  String get currencyGbp => '£ GBP';

  @override
  String get currencyEur => '€ EUR';

  @override
  String get currencyUsd => '\$ USD';

  @override
  String get currencyUah => '₴ UAH';

  @override
  String get currencyPln => 'zł PLN';

  @override
  String get helpTitle => 'Опис роботи програми';

  @override
  String get helpContent =>
      'Як користуватися\nПеред початком роботи вам потрібно налаштувати Клієнтів, Проекти та Компанію в налаштуваннях.\nПотім ви можете додати запис часу.\nВи можете аналізувати записи часу за допомогою гістограми/лінійної діаграми.\nВи можете експортувати записи у форматі HTML, EXCEL та CSV.\nВи можете виставити рахунок у форматі PDF та надіслати його клієнту для оплати.\n\nТабель обліку робочого часу\nНатисніть «Назва», щоб змінити період.\nНатисніть іконку Плюс, щоб додати новий запис часу.\nНатисніть на іконку «Додати кілька записів», щоб додати кілька записів одночасно.\nНатисніть іконку Експорт/Електронна пошта, щоб експортувати/надіслати у форматі HTML, EXCEL або CSV.\nНатисніть значок календаря, щоб переглянути в режимі календаря.\nНатисніть іконку Фільтр, щоб відфільтрувати дані за тегом, статусом, клієнтом та проектом.\nНатисніть іконку Сортувати, щоб відсортувати дані за Датою, Сумою, Проектом та Клієнтом.\nНатисніть Запис часу, щоб оновити, видалити та скопіювати.\nТривале натискання Часовий запис для багаторазового вибору.\n\nДодати запис про погодинну/фіксовану ставку\nУ налаштуваннях проекту ви можете вибрати погодинну/фіксовану ставку.\nКоли ви додаєте новий запис часу, виберіть проект Погодинна/Фіксована ставка.\nНовий запис часу буде Година/Фіксована ставка на основі налаштувань проекту.\n\nЯк налаштувати понаднормові години\nУ налаштуваннях проекту ви можете вибрати щоденні/щотижневі/двотижневі/щомісячні понаднормові години.\nУ налаштуванні понаднормових введіть поріг годин і ставку понаднормових.\n\nЯк налаштувати преміум-годинник\nУ налаштуваннях проєкту ви можете вибрати преміум-годинник.\nУ преміум-годиннику налаштуйте час і дату початку/завершення.\nПреміум-година буде розраховуватися в залежності від проекту.\n\nСерійні операції\nВи можете вибрати кілька записів часу, довго натискаючи на запис часу.\nВибравши кілька записів, ви можете змінювати статус, тегувати, копіювати та видаляти їх пакетами.\nВи можете додавати кілька записів часу в пакетах і пропускати певні дати.\n\nЕкспорт запису часу\nНа екрані запису часу натисніть іконку «Поділитися».\nНа екрані даних ви можете вибрати період часу та відфільтрувати дані.\nНа екрані формату ви можете вибрати формат звіту Excel, Html та Csv.\nЗвіт може групувати дані за датою, тижнем, статусом, тегом, проектом і клієнтом.\nЗвіт може бути показаний у вигляді зведеного або детального звіту.\nВи також можете сортувати поля стовпців у звіті.\n\nІмпорт запису часу\nНа екрані запису часу натисніть іконку імпорту.\nВи можете імпортувати записи часу з інших додатків.\nФайл імпорту має формат Csv.\n\nРахунок-фактура\nНатисніть іконку «Плюс», щоб додати новий інвойс.\nНатисніть на запис інвойсу, щоб відкрити його за допомогою програми для читання PDF-файлів.\n\nДодати новий інвойс\nСпочатку вам потрібно вибрати Клієнт.\nПотім ви можете вибрати години роботи, натиснувши «Години», доступні лише статуси «відкрито» або «продовження».\n\nГрафіки\nПоказує щомісячну суму та години у вигляді гістограми та лінійної діаграми.\nНатисніть іконку Фільтр, щоб відфільтрувати дані діаграми за проектом, клієнтом, тегом і статусом.\nНатисніть на іконку долара, щоб показати графік суми.\n\nЯк створити резервну копію/відновити дані\nУ додатку ви можете створити резервну копію бази даних на електронну пошту, SD-карту або Google Drive.\nУ додатку ви можете відновити базу даних з SD-карти або Google Drive.\n\n1. Експорт звіту в CSV, HTML та EXCEL.\n2. Необмежена кількість рахунків-фактур.';

  @override
  String get contactTitle => 'Написати розробнику';

  @override
  String get contactHeader => 'Зв\'язок з розробником';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get contactTelegramLabel => 'Telegram';

  @override
  String get contactBody =>
      'Опиши проблему або побажання, додай скрін і версію додатку.';

  @override
  String stubInProgress(Object title) {
    return 'Сторінка \"$title\" в розробці';
  }

  @override
  String get statsTitle => 'Статистика';

  @override
  String get statsHistogramTitle => 'Гістограма';

  @override
  String get statsHistogramSubtitle =>
      'Показує годину роботи, понаднормову роботу, суму, витрати, пробіг за певний період часу';

  @override
  String get statsLineTitle => 'Лінійна діаграма';

  @override
  String get statsLineSubtitle =>
      'Показує робочі години/кількість за певний період часу';

  @override
  String get statsPieTitle => 'Кругова діаграма';

  @override
  String get statsPieSubtitle =>
      'Показує розподіл робочих годин/кількості у відсотках';

  @override
  String get statsMileageTitle => 'Графік пробігу';

  @override
  String get statsMileageSubtitle =>
      'Відображає години/суму пробігу на графіку';

  @override
  String get statsFilterIncludeNonBillable =>
      'Фільтр: Включити непідлягаючі оплаті';

  @override
  String get statsNoData => 'Немає даних';

  @override
  String get statsNoMetrics => 'Немає вибраних показників';

  @override
  String statsAverageLabel(Object value) {
    return 'Середній ($value)';
  }

  @override
  String get statsLegendWork => 'Робота';

  @override
  String get statsLegendOvertime => 'З часом';

  @override
  String get statsLegendExpenses => 'Витрати';

  @override
  String get statsLegendMileage => 'Пробіг';

  @override
  String get statsMetricHours => 'Година';

  @override
  String get statsMetricAmount => 'Сума';

  @override
  String get statsTypeShortHistogram => 'Гістог...';

  @override
  String get statsTypeShortLine => 'Лінійн...';

  @override
  String get statsTypeShortPie => 'Кругов...';

  @override
  String get statsTypeShortMileage => 'Пробіг...';

  @override
  String get statsTypeHistogram => 'Гістограма';

  @override
  String get statsTypeLine => 'Лінійна';

  @override
  String get statsTypePie => 'Кругова';

  @override
  String get statsTypeMileage => 'Графік пробігу';

  @override
  String get statsPeriodWeek => 'Тиждень';

  @override
  String get statsPeriodMonth => 'Місяць';

  @override
  String get statsPeriodYear => 'Рік';

  @override
  String statsWeekRange(Object range, Object week) {
    return 't$week · $range';
  }

  @override
  String get settingsAfterMinutesLabel => 'Після (хвилин)';

  @override
  String validationRequired(Object field) {
    return 'Заповніть поле: $field';
  }

  @override
  String get validationInvalidNumber => 'Некоректне числове значення';

  @override
  String get validationTimeRange =>
      'Час закінчення має бути пізніше за час початку';
}
