import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Timesheet'**
  String get appTitle;

  /// No description provided for @menuTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get menuTime;

  /// No description provided for @menuCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get menuCalendar;

  /// No description provided for @menuInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get menuInvoice;

  /// No description provided for @menuInvoiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Invoice (disabled)'**
  String get menuInvoiceDisabled;

  /// No description provided for @menuStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get menuStatistics;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get menuData;

  /// No description provided for @tooltipProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get tooltipProjects;

  /// No description provided for @tooltipClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get tooltipClients;

  /// No description provided for @tooltipAppDescription.
  ///
  /// In en, this message translates to:
  /// **'App description'**
  String get tooltipAppDescription;

  /// No description provided for @tooltipContactDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Contact developer'**
  String get tooltipContactDeveloper;

  /// No description provided for @moreTabTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTabTitle;

  /// No description provided for @localizationSection.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localizationSection;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @shareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareLabel;

  /// No description provided for @privacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @prefsDefaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get prefsDefaultsTitle;

  /// No description provided for @prefsUseLastTitle.
  ///
  /// In en, this message translates to:
  /// **'Use last values'**
  String get prefsUseLastTitle;

  /// No description provided for @prefsUseLastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the last entered values when adding entries'**
  String get prefsUseLastSubtitle;

  /// No description provided for @prefsMonthlyCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly calendar'**
  String get prefsMonthlyCalendarTitle;

  /// No description provided for @prefsMonthlyCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show data in monthly calendar'**
  String get prefsMonthlyCalendarSubtitle;

  /// No description provided for @prefsCurrencyFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency format'**
  String get prefsCurrencyFormatTitle;

  /// No description provided for @prefsDateFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get prefsDateFormatTitle;

  /// No description provided for @prefsHoursFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Hours format'**
  String get prefsHoursFormatTitle;

  /// No description provided for @prefsTimeFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get prefsTimeFormatTitle;

  /// No description provided for @prefsTimeFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get prefsTimeFormatSubtitle;

  /// No description provided for @prefsTimePickerStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Time picker style'**
  String get prefsTimePickerStyleTitle;

  /// No description provided for @prefsTimePickerStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use dial'**
  String get prefsTimePickerStyleSubtitle;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// No description provided for @commonFilterNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonFilterNone;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @statusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @commonProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get commonProject;

  /// No description provided for @commonClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get commonClient;

  /// No description provided for @commonTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get commonTag;

  /// No description provided for @commonNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get commonNote;

  /// No description provided for @commonDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get commonDescription;

  /// No description provided for @commonBreak.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get commonBreak;

  /// No description provided for @commonStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get commonStartTime;

  /// No description provided for @commonEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get commonEndTime;

  /// No description provided for @commonWorkHours.
  ///
  /// In en, this message translates to:
  /// **'Work hours'**
  String get commonWorkHours;

  /// No description provided for @commonHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Rate / hour'**
  String get commonHourlyRate;

  /// No description provided for @commonBillable.
  ///
  /// In en, this message translates to:
  /// **'Billable'**
  String get commonBillable;

  /// No description provided for @commonAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get commonAddExpense;

  /// No description provided for @commonAddMileage.
  ///
  /// In en, this message translates to:
  /// **'Add mileage'**
  String get commonAddMileage;

  /// No description provided for @commonAddTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get commonAddTime;

  /// No description provided for @commonEditTime.
  ///
  /// In en, this message translates to:
  /// **'Edit time'**
  String get commonEditTime;

  /// No description provided for @commonSaveAndCreate.
  ///
  /// In en, this message translates to:
  /// **'Save and create'**
  String get commonSaveAndCreate;

  /// No description provided for @commonSaveAndFinish.
  ///
  /// In en, this message translates to:
  /// **'Save and finish'**
  String get commonSaveAndFinish;

  /// No description provided for @commonBreakMinutesSuffix.
  ///
  /// In en, this message translates to:
  /// **'in minutes'**
  String get commonBreakMinutesSuffix;

  /// No description provided for @commonTaskHint.
  ///
  /// In en, this message translates to:
  /// **'What task did you do?'**
  String get commonTaskHint;

  /// No description provided for @commonDefaultClient.
  ///
  /// In en, this message translates to:
  /// **'Default client'**
  String get commonDefaultClient;

  /// No description provided for @commonAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// No description provided for @commonDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get commonDistanceKm;

  /// No description provided for @expenseAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAddTitle;

  /// No description provided for @mileageAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add mileage'**
  String get mileageAddTitle;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense added'**
  String get expenseAdded;

  /// No description provided for @mileageAdded.
  ///
  /// In en, this message translates to:
  /// **'Mileage added'**
  String get mileageAdded;

  /// No description provided for @calendarFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter: {value}'**
  String calendarFilter(Object value);

  /// No description provided for @calendarAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry (+)'**
  String get calendarAddEntry;

  /// No description provided for @calendarWeek.
  ///
  /// In en, this message translates to:
  /// **'wk'**
  String get calendarWeek;

  /// No description provided for @calendarMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get calendarMon;

  /// No description provided for @calendarTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get calendarTue;

  /// No description provided for @calendarWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get calendarWed;

  /// No description provided for @calendarThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get calendarThu;

  /// No description provided for @calendarFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get calendarFri;

  /// No description provided for @calendarSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get calendarSat;

  /// No description provided for @calendarSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get calendarSun;

  /// No description provided for @calendarRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get calendarRate;

  /// No description provided for @timePeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get timePeriodMonth;

  /// No description provided for @timePeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get timePeriodWeek;

  /// No description provided for @timeNoEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries for period'**
  String get timeNoEntries;

  /// No description provided for @timeFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get timeFilterTitle;

  /// No description provided for @timeFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get timeFilterAll;

  /// No description provided for @timeFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get timeFilterOpen;

  /// No description provided for @timeFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get timeFilterPaid;

  /// No description provided for @timeSortDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get timeSortDate;

  /// No description provided for @timeSortAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get timeSortAmount;

  /// No description provided for @timeSortProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get timeSortProject;

  /// No description provided for @timeSortClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get timeSortClient;

  /// No description provided for @timeCreateProjectFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a project first'**
  String get timeCreateProjectFirst;

  /// No description provided for @clientTitle.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get clientTitle;

  /// No description provided for @clientAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get clientAddTitle;

  /// No description provided for @clientUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update client'**
  String get clientUpdateTitle;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get clientName;

  /// No description provided for @clientAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get clientAddress;

  /// No description provided for @clientGeo.
  ///
  /// In en, this message translates to:
  /// **'Geolocation'**
  String get clientGeo;

  /// No description provided for @clientPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get clientPhone;

  /// No description provided for @clientEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get clientEmail;

  /// No description provided for @clientDesc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get clientDesc;

  /// No description provided for @clientNotFound.
  ///
  /// In en, this message translates to:
  /// **'Client not found'**
  String get clientNotFound;

  /// No description provided for @clientNoClients.
  ///
  /// In en, this message translates to:
  /// **'No clients'**
  String get clientNoClients;

  /// No description provided for @clientQuickInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick info'**
  String get clientQuickInfoTitle;

  /// No description provided for @clientNameHint.
  ///
  /// In en, this message translates to:
  /// **'Max 30 characters'**
  String get clientNameHint;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectTitle;

  /// No description provided for @projectAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add project'**
  String get projectAddTitle;

  /// No description provided for @projectUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update project'**
  String get projectUpdateTitle;

  /// No description provided for @projectNoProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects'**
  String get projectNoProjects;

  /// No description provided for @projectNoName.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get projectNoName;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectName;

  /// No description provided for @projectTypeHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get projectTypeHourly;

  /// No description provided for @projectTypeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get projectTypeFixed;

  /// No description provided for @projectNotBillable.
  ///
  /// In en, this message translates to:
  /// **'Not billable'**
  String get projectNotBillable;

  /// No description provided for @projectBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get projectBudget;

  /// No description provided for @projectNoBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget'**
  String get projectNoBudget;

  /// No description provided for @projectBudgetHours.
  ///
  /// In en, this message translates to:
  /// **'Budget hours'**
  String get projectBudgetHours;

  /// No description provided for @projectBudgetFees.
  ///
  /// In en, this message translates to:
  /// **'Budget fees'**
  String get projectBudgetFees;

  /// No description provided for @projectClientAll.
  ///
  /// In en, this message translates to:
  /// **'Empty means all clients'**
  String get projectClientAll;

  /// No description provided for @projectRoundHour.
  ///
  /// In en, this message translates to:
  /// **'Round hour'**
  String get projectRoundHour;

  /// No description provided for @projectTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get projectTypeLabel;

  /// No description provided for @projectTypeHourlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Hourly payment based on rate. The longer you work, the more you earn.'**
  String get projectTypeHourlyDesc;

  /// No description provided for @projectTypeFixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Fixed fee per job regardless of hours.'**
  String get projectTypeFixedDesc;

  /// No description provided for @projectPremiumStub.
  ///
  /// In en, this message translates to:
  /// **'Premium rate, Premium hours, After some time (stub)'**
  String get projectPremiumStub;

  /// No description provided for @projectAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get projectAmountHint;

  /// No description provided for @dataTitle.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get dataTitle;

  /// No description provided for @dataAutoBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get dataAutoBackupTitle;

  /// No description provided for @dataAutoBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save local DB copy in backups folder'**
  String get dataAutoBackupSubtitle;

  /// No description provided for @dataCreateBackup.
  ///
  /// In en, this message translates to:
  /// **'Create database backup'**
  String get dataCreateBackup;

  /// No description provided for @dataCreateBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local .sqlite copy'**
  String get dataCreateBackupSubtitle;

  /// No description provided for @dataRestoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore database'**
  String get dataRestoreBackup;

  /// No description provided for @dataRestoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore latest backup'**
  String get dataRestoreBackupSubtitle;

  /// No description provided for @dataEmailBackup.
  ///
  /// In en, this message translates to:
  /// **'Email database'**
  String get dataEmailBackup;

  /// No description provided for @dataEmailBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show last backup path'**
  String get dataEmailBackupSubtitle;

  /// No description provided for @dataDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all records'**
  String get dataDeleteAll;

  /// No description provided for @dataDeleteAllSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear clients/projects/time tables'**
  String get dataDeleteAllSubtitle;

  /// No description provided for @dataRecentBackups.
  ///
  /// In en, this message translates to:
  /// **'Recent backups'**
  String get dataRecentBackups;

  /// No description provided for @dataNoBackupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No backups'**
  String get dataNoBackupsTitle;

  /// No description provided for @dataNoBackupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first backup above'**
  String get dataNoBackupsSubtitle;

  /// No description provided for @dataRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get dataRestoreConfirmTitle;

  /// No description provided for @dataRestoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Current data will be replaced. Continue?'**
  String get dataRestoreConfirmBody;

  /// No description provided for @dataRestored.
  ///
  /// In en, this message translates to:
  /// **'Database restored'**
  String get dataRestored;

  /// No description provided for @dataBackupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get dataBackupCreated;

  /// No description provided for @dataBackupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Backup not found'**
  String get dataBackupNotFound;

  /// No description provided for @dataRestoredRestart.
  ///
  /// In en, this message translates to:
  /// **'Database restored. Restart app.'**
  String get dataRestoredRestart;

  /// No description provided for @dataBackupFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Backup folder'**
  String get dataBackupFolderLabel;

  /// No description provided for @dataConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get dataConfirmTitle;

  /// No description provided for @dataConfirmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete all records?'**
  String get dataConfirmDeleteBody;

  /// No description provided for @dataCleared.
  ///
  /// In en, this message translates to:
  /// **'Data cleared'**
  String get dataCleared;

  /// No description provided for @commonHoursSuffix.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get commonHoursSuffix;

  /// No description provided for @commonPerHourSuffix.
  ///
  /// In en, this message translates to:
  /// **'/h'**
  String get commonPerHourSuffix;

  /// No description provided for @commonDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get commonDay;

  /// No description provided for @commonWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get commonWeek;

  /// No description provided for @commonEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get commonEnabled;

  /// No description provided for @commonDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get commonDisabled;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error: {value}'**
  String commonError(Object value);

  /// No description provided for @calendarThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get calendarThisMonth;

  /// No description provided for @startSampleProject.
  ///
  /// In en, this message translates to:
  /// **'Jane Hourly'**
  String get startSampleProject;

  /// No description provided for @startSampleClient.
  ///
  /// In en, this message translates to:
  /// **'Jane'**
  String get startSampleClient;

  /// No description provided for @startStartWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get startStartWork;

  /// No description provided for @startStartedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at'**
  String get startStartedAt;

  /// No description provided for @startDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get startDayLabel;

  /// No description provided for @startWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get startWeekLabel;

  /// No description provided for @clientHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get clientHoursTitle;

  /// No description provided for @clientTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get clientTotalLabel;

  /// No description provided for @clientPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get clientPaidLabel;

  /// No description provided for @clientUnpaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get clientUnpaidLabel;

  /// No description provided for @clientIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get clientIncomeTitle;

  /// No description provided for @clientWorkLabel.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get clientWorkLabel;

  /// No description provided for @clientExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get clientExpensesLabel;

  /// No description provided for @clientMileageLabel.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get clientMileageLabel;

  /// No description provided for @clientInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get clientInvoiceTitle;

  /// No description provided for @clientExpectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get clientExpectedLabel;

  /// No description provided for @clientEffectiveRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Effective hourly rate'**
  String get clientEffectiveRateTitle;

  /// No description provided for @clientTotalHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Total hours'**
  String get clientTotalHoursLabel;

  /// No description provided for @clientPerHourLabel.
  ///
  /// In en, this message translates to:
  /// **'Per hour'**
  String get clientPerHourLabel;

  /// No description provided for @clientStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get clientStatusLabel;

  /// No description provided for @clientStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get clientStatusActive;

  /// No description provided for @clientProjectFallback.
  ///
  /// In en, this message translates to:
  /// **'Project #{id}'**
  String clientProjectFallback(Object id);

  /// No description provided for @settingsTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsTabGeneral;

  /// No description provided for @settingsTabTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsTabTime;

  /// No description provided for @settingsTabPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsTabPreferences;

  /// No description provided for @settingsClientTitle.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get settingsClientTitle;

  /// No description provided for @settingsClientSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure multiple clients'**
  String get settingsClientSubtitle;

  /// No description provided for @settingsProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get settingsProjectTitle;

  /// No description provided for @settingsProjectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Predefined projects with rates and rules'**
  String get settingsProjectSubtitle;

  /// No description provided for @settingsWorkDescTitle.
  ///
  /// In en, this message translates to:
  /// **'Work description'**
  String get settingsWorkDescTitle;

  /// No description provided for @settingsWorkDescSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Default work description'**
  String get settingsWorkDescSubtitle;

  /// No description provided for @settingsExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses/deductions'**
  String get settingsExpensesTitle;

  /// No description provided for @settingsExpensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Predefined expenses/deductions'**
  String get settingsExpensesSubtitle;

  /// No description provided for @settingsHolidayTitle.
  ///
  /// In en, this message translates to:
  /// **'Holiday management'**
  String get settingsHolidayTitle;

  /// No description provided for @settingsHolidaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'If a holiday applies, premium/overtime is not used'**
  String get settingsHolidaySubtitle;

  /// No description provided for @settingsPremiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium hours'**
  String get settingsPremiumTitle;

  /// No description provided for @settingsPremiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If premium hours are used, overtime is not applied'**
  String get settingsPremiumSubtitle;

  /// No description provided for @settingsAfterTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'After some time'**
  String get settingsAfterTimeTitle;

  /// No description provided for @settingsAfterTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-calculate overtime'**
  String get settingsAfterTimeSubtitle;

  /// No description provided for @settingsTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get settingsTagTitle;

  /// No description provided for @settingsTagSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Filter and organize your data'**
  String get settingsTagSubtitle;

  /// No description provided for @settingsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get settingsEmpty;

  /// No description provided for @settingsAddPreset.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get settingsAddPreset;

  /// No description provided for @settingsEditPreset.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get settingsEditPreset;

  /// No description provided for @settingsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsNameLabel;

  /// No description provided for @settingsIsDeduction.
  ///
  /// In en, this message translates to:
  /// **'Deduction'**
  String get settingsIsDeduction;

  /// No description provided for @settingsMultiplierLabel.
  ///
  /// In en, this message translates to:
  /// **'Multiplier'**
  String get settingsMultiplierLabel;

  /// No description provided for @settingsWorkDescHint.
  ///
  /// In en, this message translates to:
  /// **'Description text'**
  String get settingsWorkDescHint;

  /// No description provided for @settingsTagHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get settingsTagHint;

  /// No description provided for @settingsTimeSection.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsTimeSection;

  /// No description provided for @settingsConfirmStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm timer stop'**
  String get settingsConfirmStopTitle;

  /// No description provided for @settingsConfirmStopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get settingsConfirmStopSubtitle;

  /// No description provided for @settingsEditAfterStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit time entry'**
  String get settingsEditAfterStopTitle;

  /// No description provided for @settingsEditAfterStopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'After stopping timer'**
  String get settingsEditAfterStopSubtitle;

  /// No description provided for @settingsSwitchTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer switching'**
  String get settingsSwitchTimerTitle;

  /// No description provided for @settingsSwitchTimerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow switching project'**
  String get settingsSwitchTimerSubtitle;

  /// No description provided for @settingsCheckinLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in location'**
  String get settingsCheckinLocationTitle;

  /// No description provided for @settingsCheckinLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get settingsCheckinLocationSubtitle;

  /// No description provided for @settingsCurrencyFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency format'**
  String get settingsCurrencyFormatTitle;

  /// No description provided for @settingsTimeFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get settingsTimeFormatTitle;

  /// No description provided for @settingsTimeFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get settingsTimeFormatSubtitle;

  /// No description provided for @settingsTimePickerStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Time picker style'**
  String get settingsTimePickerStyleTitle;

  /// No description provided for @settingsTimePickerStyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use dial'**
  String get settingsTimePickerStyleSubtitle;

  /// No description provided for @shareDescription.
  ///
  /// In en, this message translates to:
  /// **'Share the app with friends'**
  String get shareDescription;

  /// No description provided for @languageNameUkr.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get languageNameUkr;

  /// No description provided for @languageNameEng.
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get languageNameEng;

  /// No description provided for @languageNamePl.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get languageNamePl;

  /// No description provided for @currencyGbp.
  ///
  /// In en, this message translates to:
  /// **'£ GBP'**
  String get currencyGbp;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'€ EUR'**
  String get currencyEur;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'\$ USD'**
  String get currencyUsd;

  /// No description provided for @currencyUah.
  ///
  /// In en, this message translates to:
  /// **'₴ UAH'**
  String get currencyUah;

  /// No description provided for @currencyPln.
  ///
  /// In en, this message translates to:
  /// **'zł PLN'**
  String get currencyPln;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'App description'**
  String get helpTitle;

  /// No description provided for @helpContent.
  ///
  /// In en, this message translates to:
  /// **'How to use\nBefore you start, set up Clients, Projects, and Company in Settings.\nThen you can add a time entry.\nYou can analyze time entries with histogram/line chart.\nYou can export entries to HTML, EXCEL, and CSV.\nYou can issue invoices in PDF and send to clients.\n\nTimesheet\nTap “Title” to change period.\nTap Plus to add a new time entry.\nTap “Add multiple entries” to add multiple entries at once.\nTap Export/Email to export/send HTML, EXCEL, or CSV.\nTap calendar icon to view calendar mode.\nTap Filter to filter by tag, status, client, and project.\nTap Sort to sort by Date, Amount, Project, and Client.\nTap a time entry to update, delete, or copy.\nLong press a time entry to multi-select.\n\nAdd hourly/fixed rate entry\nIn project settings you can select hourly/fixed rate.\nWhen adding a time entry, select a project with Hourly/Fixed rate.\nThe new entry uses Hourly/Fixed rate based on project settings.\n\nOvertime setup\nIn project settings choose daily/weekly/bi-weekly/monthly overtime.\nSet threshold hours and overtime rate.\n\nPremium hours setup\nIn project settings choose premium hours.\nSet premium hours start/end time and date.\nPremium hours are calculated per project.\n\nBatch operations\nSelect multiple time entries by long pressing.\nWith multiple selected, you can change status, tag, copy, and delete in bulk.\nYou can add multiple entries in batches and skip dates.\n\nExport time entries\nOn time screen tap Share icon.\nOn data screen select period and filters.\nOn format screen choose Excel, Html, or Csv.\nReport can group by date, week, status, tag, project, and client.\nReport can be summary or detailed.\nYou can also sort column fields.\n\nImport time entries\nOn time screen tap Import icon.\nYou can import entries from other apps.\nImport file is Csv.\n\nInvoice\nTap Plus to add a new invoice.\nTap an invoice to open it with a PDF reader.\n\nAdd new invoice\nFirst choose Client.\nThen choose work hours by tapping Hours; only Open or In Progress statuses are available.\n\nCharts\nShows monthly amount and hours in histogram and line chart.\nTap Filter to filter chart data by project, client, tag, and status.\nTap dollar icon to show amount chart.\n\nBackup/restore data\nYou can back up the database via email, SD card, or Google Drive.\nYou can restore the database from SD card or Google Drive.\n\n1. Export reports to CSV, HTML, and EXCEL.\n2. Unlimited invoices.'**
  String get helpContent;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact developer'**
  String get contactTitle;

  /// No description provided for @contactHeader.
  ///
  /// In en, this message translates to:
  /// **'Developer contact'**
  String get contactHeader;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmailLabel;

  /// No description provided for @contactTelegramLabel.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get contactTelegramLabel;

  /// No description provided for @contactBody.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue or suggestion, add a screenshot and app version.'**
  String get contactBody;

  /// No description provided for @stubInProgress.
  ///
  /// In en, this message translates to:
  /// **'Page \"{title}\" is in progress'**
  String stubInProgress(Object title);

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsHistogramTitle.
  ///
  /// In en, this message translates to:
  /// **'Histogram'**
  String get statsHistogramTitle;

  /// No description provided for @statsHistogramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows work hours, overtime, amount, expenses, mileage for a period'**
  String get statsHistogramSubtitle;

  /// No description provided for @statsLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Line chart'**
  String get statsLineTitle;

  /// No description provided for @statsLineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows work hours/count for a period'**
  String get statsLineSubtitle;

  /// No description provided for @statsPieTitle.
  ///
  /// In en, this message translates to:
  /// **'Pie chart'**
  String get statsPieTitle;

  /// No description provided for @statsPieSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows distribution of work hours/count in percent'**
  String get statsPieSubtitle;

  /// No description provided for @statsMileageTitle.
  ///
  /// In en, this message translates to:
  /// **'Mileage chart'**
  String get statsMileageTitle;

  /// No description provided for @statsMileageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Displays mileage hours/amount on the chart'**
  String get statsMileageSubtitle;

  /// No description provided for @statsFilterIncludeNonBillable.
  ///
  /// In en, this message translates to:
  /// **'Filter: include non-billable'**
  String get statsFilterIncludeNonBillable;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get statsNoData;

  /// No description provided for @statsNoMetrics.
  ///
  /// In en, this message translates to:
  /// **'No metrics selected'**
  String get statsNoMetrics;

  /// No description provided for @statsAverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Average ({value})'**
  String statsAverageLabel(Object value);

  /// No description provided for @statsLegendWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get statsLegendWork;

  /// No description provided for @statsLegendOvertime.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get statsLegendOvertime;

  /// No description provided for @statsLegendExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get statsLegendExpenses;

  /// No description provided for @statsLegendMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get statsLegendMileage;

  /// No description provided for @statsMetricHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get statsMetricHours;

  /// No description provided for @statsMetricAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get statsMetricAmount;

  /// No description provided for @statsTypeShortHistogram.
  ///
  /// In en, this message translates to:
  /// **'Hist...'**
  String get statsTypeShortHistogram;

  /// No description provided for @statsTypeShortLine.
  ///
  /// In en, this message translates to:
  /// **'Line...'**
  String get statsTypeShortLine;

  /// No description provided for @statsTypeShortPie.
  ///
  /// In en, this message translates to:
  /// **'Pie...'**
  String get statsTypeShortPie;

  /// No description provided for @statsTypeShortMileage.
  ///
  /// In en, this message translates to:
  /// **'Miles...'**
  String get statsTypeShortMileage;

  /// No description provided for @statsTypeHistogram.
  ///
  /// In en, this message translates to:
  /// **'Histogram'**
  String get statsTypeHistogram;

  /// No description provided for @statsTypeLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get statsTypeLine;

  /// No description provided for @statsTypePie.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get statsTypePie;

  /// No description provided for @statsTypeMileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage chart'**
  String get statsTypeMileage;

  /// No description provided for @statsPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get statsPeriodWeek;

  /// No description provided for @statsPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsPeriodMonth;

  /// No description provided for @statsPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsPeriodYear;

  /// No description provided for @statsWeekRange.
  ///
  /// In en, this message translates to:
  /// **'w{week} · {range}'**
  String statsWeekRange(Object range, Object week);

  /// No description provided for @settingsAfterMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'After (minutes)'**
  String get settingsAfterMinutesLabel;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Fill in field: {field}'**
  String validationRequired(Object field);

  /// No description provided for @validationInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid numeric value'**
  String get validationInvalidNumber;

  /// No description provided for @validationTimeRange.
  ///
  /// In en, this message translates to:
  /// **'End time must be later than start time'**
  String get validationTimeRange;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
