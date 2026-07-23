// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Timesheet';

  @override
  String get menuTime => 'Time';

  @override
  String get menuCalendar => 'Calendar';

  @override
  String get menuInvoice => 'Invoice';

  @override
  String get menuInvoiceDisabled => 'Invoice (disabled)';

  @override
  String get menuStatistics => 'Statistics';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuData => 'Data';

  @override
  String get tooltipProjects => 'Projects';

  @override
  String get tooltipClients => 'Clients';

  @override
  String get tooltipAppDescription => 'App description';

  @override
  String get tooltipContactDeveloper => 'Contact developer';

  @override
  String get moreTabTitle => 'More';

  @override
  String get localizationSection => 'Localization';

  @override
  String get languageLabel => 'Language';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get shareLabel => 'Share';

  @override
  String get privacyLabel => 'Privacy policy';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get prefsDefaultsTitle => 'Defaults';

  @override
  String get prefsUseLastTitle => 'Use last values';

  @override
  String get prefsUseLastSubtitle =>
      'Use the last entered values when adding entries';

  @override
  String get prefsMonthlyCalendarTitle => 'Monthly calendar';

  @override
  String get prefsMonthlyCalendarSubtitle => 'Show data in monthly calendar';

  @override
  String get prefsCurrencyFormatTitle => 'Currency format';

  @override
  String get prefsDateFormatTitle => 'Date format';

  @override
  String get prefsHoursFormatTitle => 'Hours format';

  @override
  String get prefsTimeFormatTitle => 'Time format';

  @override
  String get prefsTimeFormatSubtitle => '24 hours';

  @override
  String get prefsTimePickerStyleTitle => 'Time picker style';

  @override
  String get prefsTimePickerStyleSubtitle => 'Use dial';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonFilterNone => 'None';

  @override
  String get commonStatus => 'Status';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusPaid => 'Paid';

  @override
  String get commonProject => 'Project';

  @override
  String get commonClient => 'Client';

  @override
  String get commonTag => 'Tag';

  @override
  String get commonNote => 'Note';

  @override
  String get commonDescription => 'Description';

  @override
  String get commonBreak => 'Break';

  @override
  String get commonStartTime => 'Start time';

  @override
  String get commonEndTime => 'End time';

  @override
  String get commonWorkHours => 'Work hours';

  @override
  String get commonHourlyRate => 'Rate / hour';

  @override
  String get commonBillable => 'Billable';

  @override
  String get commonAddExpense => 'Add expense';

  @override
  String get commonAddMileage => 'Add mileage';

  @override
  String get commonAddTime => 'Add time';

  @override
  String get commonEditTime => 'Edit time';

  @override
  String get commonSaveAndCreate => 'Save and create';

  @override
  String get commonSaveAndFinish => 'Save and finish';

  @override
  String get commonBreakMinutesSuffix => 'in minutes';

  @override
  String get commonTaskHint => 'What task did you do?';

  @override
  String get commonDefaultClient => 'Default client';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonDistanceKm => 'Distance (km)';

  @override
  String get expenseAddTitle => 'Add expense';

  @override
  String get mileageAddTitle => 'Add mileage';

  @override
  String get expenseAdded => 'Expense added';

  @override
  String get mileageAdded => 'Mileage added';

  @override
  String calendarFilter(Object value) {
    return 'Filter: $value';
  }

  @override
  String get calendarAddEntry => 'Add entry (+)';

  @override
  String get calendarWeek => 'wk';

  @override
  String get calendarMon => 'Mon';

  @override
  String get calendarTue => 'Tue';

  @override
  String get calendarWed => 'Wed';

  @override
  String get calendarThu => 'Thu';

  @override
  String get calendarFri => 'Fri';

  @override
  String get calendarSat => 'Sat';

  @override
  String get calendarSun => 'Sun';

  @override
  String get calendarRate => 'Rate';

  @override
  String get timePeriodMonth => 'Month';

  @override
  String get timePeriodWeek => 'Week';

  @override
  String get timeNoEntries => 'No entries for period';

  @override
  String get timeFilterTitle => 'Filter';

  @override
  String get timeFilterAll => 'All';

  @override
  String get timeFilterOpen => 'Open';

  @override
  String get timeFilterPaid => 'Paid';

  @override
  String get timeSortDate => 'Date';

  @override
  String get timeSortAmount => 'Amount';

  @override
  String get timeSortProject => 'Project';

  @override
  String get timeSortClient => 'Client';

  @override
  String get timeCreateProjectFirst => 'Create a project first';

  @override
  String get clientTitle => 'Client';

  @override
  String get clientAddTitle => 'Add client';

  @override
  String get clientUpdateTitle => 'Update client';

  @override
  String get clientName => 'Name';

  @override
  String get clientAddress => 'Address';

  @override
  String get clientGeo => 'Geolocation';

  @override
  String get clientPhone => 'Phone';

  @override
  String get clientEmail => 'Email';

  @override
  String get clientDesc => 'Description';

  @override
  String get clientNotFound => 'Client not found';

  @override
  String get clientNoClients => 'No clients';

  @override
  String get clientQuickInfoTitle => 'Quick info';

  @override
  String get clientNameHint => 'Max 30 characters';

  @override
  String get projectTitle => 'Project';

  @override
  String get projectAddTitle => 'Add project';

  @override
  String get projectUpdateTitle => 'Update project';

  @override
  String get projectNoProjects => 'No projects';

  @override
  String get projectNoName => 'Untitled';

  @override
  String get projectName => 'Project';

  @override
  String get projectTypeHourly => 'Hourly';

  @override
  String get projectTypeFixed => 'Fixed';

  @override
  String get projectNotBillable => 'Not billable';

  @override
  String get projectBudget => 'Budget';

  @override
  String get projectNoBudget => 'No budget';

  @override
  String get projectBudgetHours => 'Budget hours';

  @override
  String get projectBudgetFees => 'Budget fees';

  @override
  String get projectClientAll => 'Empty means all clients';

  @override
  String get projectRoundHour => 'Round hour';

  @override
  String get projectTypeLabel => 'Type';

  @override
  String get projectTypeHourlyDesc =>
      'Hourly payment based on rate. The longer you work, the more you earn.';

  @override
  String get projectTypeFixedDesc => 'Fixed fee per job regardless of hours.';

  @override
  String get projectPremiumStub =>
      'Premium rate, Premium hours, After some time (stub)';

  @override
  String get projectAmountHint => 'Amount';

  @override
  String get dataTitle => 'Database';

  @override
  String get dataAutoBackupTitle => 'Automatic backups';

  @override
  String get dataAutoBackupSubtitle => 'Save local DB copy in backups folder';

  @override
  String get dataCreateBackup => 'Create database backup';

  @override
  String get dataCreateBackupSubtitle => 'Local .sqlite copy';

  @override
  String get dataRestoreBackup => 'Restore database';

  @override
  String get dataRestoreBackupSubtitle => 'Restore latest backup';

  @override
  String get dataEmailBackup => 'Email database';

  @override
  String get dataEmailBackupSubtitle => 'Show last backup path';

  @override
  String get dataDeleteAll => 'Delete all records';

  @override
  String get dataDeleteAllSubtitle => 'Clear clients/projects/time tables';

  @override
  String get dataRecentBackups => 'Recent backups';

  @override
  String get dataNoBackupsTitle => 'No backups';

  @override
  String get dataNoBackupsSubtitle => 'Create your first backup above';

  @override
  String get dataRestoreConfirmTitle => 'Restore backup';

  @override
  String get dataRestoreConfirmBody =>
      'Current data will be replaced. Continue?';

  @override
  String get dataRestored => 'Database restored';

  @override
  String get dataBackupCreated => 'Backup created';

  @override
  String get dataBackupNotFound => 'Backup not found';

  @override
  String get dataRestoredRestart => 'Database restored. Restart app.';

  @override
  String get dataBackupFolderLabel => 'Backup folder';

  @override
  String get dataConfirmTitle => 'Confirmation';

  @override
  String get dataConfirmDeleteBody => 'Delete all records?';

  @override
  String get dataCleared => 'Data cleared';

  @override
  String get commonHoursSuffix => 'h';

  @override
  String get commonPerHourSuffix => '/h';

  @override
  String get commonDay => 'Day';

  @override
  String get commonWeek => 'Week';

  @override
  String get commonEnabled => 'Enable';

  @override
  String get commonDisabled => 'Disable';

  @override
  String commonError(Object value) {
    return 'Error: $value';
  }

  @override
  String get calendarThisMonth => 'This month';

  @override
  String get startSampleProject => 'Jane Hourly';

  @override
  String get startSampleClient => 'Jane';

  @override
  String get startStartWork => 'Start work';

  @override
  String get startStartedAt => 'Started at';

  @override
  String get startDayLabel => 'Day';

  @override
  String get startWeekLabel => 'Week';

  @override
  String get clientHoursTitle => 'Hours';

  @override
  String get clientTotalLabel => 'Total';

  @override
  String get clientPaidLabel => 'Paid';

  @override
  String get clientUnpaidLabel => 'Unpaid';

  @override
  String get clientIncomeTitle => 'Income';

  @override
  String get clientWorkLabel => 'Work';

  @override
  String get clientExpensesLabel => 'Expenses';

  @override
  String get clientMileageLabel => 'Mileage';

  @override
  String get clientInvoiceTitle => 'Invoice';

  @override
  String get clientExpectedLabel => 'Expected';

  @override
  String get clientEffectiveRateTitle => 'Effective hourly rate';

  @override
  String get clientTotalHoursLabel => 'Total hours';

  @override
  String get clientPerHourLabel => 'Per hour';

  @override
  String get clientStatusLabel => 'Status';

  @override
  String get clientStatusActive => 'Active';

  @override
  String clientProjectFallback(Object id) {
    return 'Project #$id';
  }

  @override
  String get settingsTabGeneral => 'General';

  @override
  String get settingsTabTime => 'Time';

  @override
  String get settingsTabPreferences => 'Preferences';

  @override
  String get settingsClientTitle => 'Client';

  @override
  String get settingsClientSubtitle => 'Configure multiple clients';

  @override
  String get settingsProjectTitle => 'Project';

  @override
  String get settingsProjectSubtitle =>
      'Predefined projects with rates and rules';

  @override
  String get settingsWorkDescTitle => 'Work description';

  @override
  String get settingsWorkDescSubtitle => 'Default work description';

  @override
  String get settingsExpensesTitle => 'Expenses/deductions';

  @override
  String get settingsExpensesSubtitle => 'Predefined expenses/deductions';

  @override
  String get settingsHolidayTitle => 'Holiday management';

  @override
  String get settingsHolidaySubtitle =>
      'If a holiday applies, premium/overtime is not used';

  @override
  String get settingsPremiumTitle => 'Premium hours';

  @override
  String get settingsPremiumSubtitle =>
      'If premium hours are used, overtime is not applied';

  @override
  String get settingsAfterTimeTitle => 'After some time';

  @override
  String get settingsAfterTimeSubtitle => 'Auto-calculate overtime';

  @override
  String get settingsTagTitle => 'Tag';

  @override
  String get settingsTagSubtitle => 'Filter and organize your data';

  @override
  String get settingsEmpty => 'No items';

  @override
  String get settingsAddPreset => 'Add item';

  @override
  String get settingsEditPreset => 'Edit item';

  @override
  String get settingsNameLabel => 'Name';

  @override
  String get settingsIsDeduction => 'Deduction';

  @override
  String get settingsMultiplierLabel => 'Multiplier';

  @override
  String get settingsWorkDescHint => 'Description text';

  @override
  String get settingsTagHint => 'Tag name';

  @override
  String get settingsTimeSection => 'Time';

  @override
  String get settingsConfirmStopTitle => 'Confirm timer stop';

  @override
  String get settingsConfirmStopSubtitle => 'Enable';

  @override
  String get settingsEditAfterStopTitle => 'Edit time entry';

  @override
  String get settingsEditAfterStopSubtitle => 'After stopping timer';

  @override
  String get settingsSwitchTimerTitle => 'Timer switching';

  @override
  String get settingsSwitchTimerSubtitle => 'Allow switching project';

  @override
  String get settingsCheckinLocationTitle => 'Check-in location';

  @override
  String get settingsCheckinLocationSubtitle => 'Disable';

  @override
  String get settingsCurrencyFormatTitle => 'Currency format';

  @override
  String get settingsTimeFormatTitle => 'Time format';

  @override
  String get settingsTimeFormatSubtitle => '24 hours';

  @override
  String get settingsTimePickerStyleTitle => 'Time picker style';

  @override
  String get settingsTimePickerStyleSubtitle => 'Use dial';

  @override
  String get shareDescription => 'Share the app with friends';

  @override
  String get languageNameUkr => 'Ukrainian';

  @override
  String get languageNameEng => 'English (US)';

  @override
  String get languageNamePl => 'Polish';

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
  String get helpTitle => 'App description';

  @override
  String get helpContent =>
      'How to use\nBefore you start, set up Clients, Projects, and Company in Settings.\nThen you can add a time entry.\nYou can analyze time entries with histogram/line chart.\nYou can export entries to HTML, EXCEL, and CSV.\nYou can issue invoices in PDF and send to clients.\n\nTimesheet\nTap “Title” to change period.\nTap Plus to add a new time entry.\nTap “Add multiple entries” to add multiple entries at once.\nTap Export/Email to export/send HTML, EXCEL, or CSV.\nTap calendar icon to view calendar mode.\nTap Filter to filter by tag, status, client, and project.\nTap Sort to sort by Date, Amount, Project, and Client.\nTap a time entry to update, delete, or copy.\nLong press a time entry to multi-select.\n\nAdd hourly/fixed rate entry\nIn project settings you can select hourly/fixed rate.\nWhen adding a time entry, select a project with Hourly/Fixed rate.\nThe new entry uses Hourly/Fixed rate based on project settings.\n\nOvertime setup\nIn project settings choose daily/weekly/bi-weekly/monthly overtime.\nSet threshold hours and overtime rate.\n\nPremium hours setup\nIn project settings choose premium hours.\nSet premium hours start/end time and date.\nPremium hours are calculated per project.\n\nBatch operations\nSelect multiple time entries by long pressing.\nWith multiple selected, you can change status, tag, copy, and delete in bulk.\nYou can add multiple entries in batches and skip dates.\n\nExport time entries\nOn time screen tap Share icon.\nOn data screen select period and filters.\nOn format screen choose Excel, Html, or Csv.\nReport can group by date, week, status, tag, project, and client.\nReport can be summary or detailed.\nYou can also sort column fields.\n\nImport time entries\nOn time screen tap Import icon.\nYou can import entries from other apps.\nImport file is Csv.\n\nInvoice\nTap Plus to add a new invoice.\nTap an invoice to open it with a PDF reader.\n\nAdd new invoice\nFirst choose Client.\nThen choose work hours by tapping Hours; only Open or In Progress statuses are available.\n\nCharts\nShows monthly amount and hours in histogram and line chart.\nTap Filter to filter chart data by project, client, tag, and status.\nTap dollar icon to show amount chart.\n\nBackup/restore data\nYou can back up the database via email, SD card, or Google Drive.\nYou can restore the database from SD card or Google Drive.\n\n1. Export reports to CSV, HTML, and EXCEL.\n2. Unlimited invoices.';

  @override
  String get contactTitle => 'Contact developer';

  @override
  String get contactHeader => 'Developer contact';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get contactTelegramLabel => 'Telegram';

  @override
  String get contactBody =>
      'Describe the issue or suggestion, add a screenshot and app version.';

  @override
  String stubInProgress(Object title) {
    return 'Page \"$title\" is in progress';
  }

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsHistogramTitle => 'Histogram';

  @override
  String get statsHistogramSubtitle =>
      'Shows work hours, overtime, amount, expenses, mileage for a period';

  @override
  String get statsLineTitle => 'Line chart';

  @override
  String get statsLineSubtitle => 'Shows work hours/count for a period';

  @override
  String get statsPieTitle => 'Pie chart';

  @override
  String get statsPieSubtitle =>
      'Shows distribution of work hours/count in percent';

  @override
  String get statsMileageTitle => 'Mileage chart';

  @override
  String get statsMileageSubtitle =>
      'Displays mileage hours/amount on the chart';

  @override
  String get statsFilterIncludeNonBillable => 'Filter: include non-billable';

  @override
  String get statsNoData => 'No data';

  @override
  String get statsNoMetrics => 'No metrics selected';

  @override
  String statsAverageLabel(Object value) {
    return 'Average ($value)';
  }

  @override
  String get statsLegendWork => 'Work';

  @override
  String get statsLegendOvertime => 'Overtime';

  @override
  String get statsLegendExpenses => 'Expenses';

  @override
  String get statsLegendMileage => 'Mileage';

  @override
  String get statsMetricHours => 'Hours';

  @override
  String get statsMetricAmount => 'Amount';

  @override
  String get statsTypeShortHistogram => 'Hist...';

  @override
  String get statsTypeShortLine => 'Line...';

  @override
  String get statsTypeShortPie => 'Pie...';

  @override
  String get statsTypeShortMileage => 'Miles...';

  @override
  String get statsTypeHistogram => 'Histogram';

  @override
  String get statsTypeLine => 'Line';

  @override
  String get statsTypePie => 'Pie';

  @override
  String get statsTypeMileage => 'Mileage chart';

  @override
  String get statsPeriodWeek => 'Week';

  @override
  String get statsPeriodMonth => 'Month';

  @override
  String get statsPeriodYear => 'Year';

  @override
  String statsWeekRange(Object range, Object week) {
    return 'w$week · $range';
  }

  @override
  String get settingsAfterMinutesLabel => 'After (minutes)';

  @override
  String validationRequired(Object field) {
    return 'Fill in field: $field';
  }

  @override
  String get validationInvalidNumber => 'Invalid numeric value';

  @override
  String get validationTimeRange => 'End time must be later than start time';
}
