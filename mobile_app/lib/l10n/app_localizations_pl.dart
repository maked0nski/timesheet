// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Ewidencja czasu';

  @override
  String get menuTime => 'Czas';

  @override
  String get menuCalendar => 'Kalendarz';

  @override
  String get menuInvoice => 'Faktura';

  @override
  String get menuInvoiceDisabled => 'Faktura (wyłączona)';

  @override
  String get menuStatistics => 'Statystyka';

  @override
  String get menuSettings => 'Ustawienia';

  @override
  String get menuData => 'Dane';

  @override
  String get tooltipProjects => 'Projekty';

  @override
  String get tooltipClients => 'Klienci';

  @override
  String get tooltipAppDescription => 'Opis aplikacji';

  @override
  String get tooltipContactDeveloper => 'Kontakt z twórcą';

  @override
  String get moreTabTitle => 'Więcej';

  @override
  String get localizationSection => 'Lokalizacja';

  @override
  String get languageLabel => 'Język';

  @override
  String get currencyLabel => 'Waluta';

  @override
  String get shareLabel => 'Udostępnij';

  @override
  String get privacyLabel => 'Polityka prywatności';

  @override
  String get themeLabel => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeLight => 'Jasny';

  @override
  String get prefsDefaultsTitle => 'Wartości domyślne';

  @override
  String get prefsUseLastTitle => 'Użyj ostatnich wartości';

  @override
  String get prefsUseLastSubtitle =>
      'Używaj ostatnio wprowadzonych wartości przy dodawaniu wpisu';

  @override
  String get prefsMonthlyCalendarTitle => 'Kalendarz miesięczny';

  @override
  String get prefsMonthlyCalendarSubtitle =>
      'Wyświetlaj dane w kalendarzu miesięcznym';

  @override
  String get prefsCurrencyFormatTitle => 'Format waluty';

  @override
  String get prefsDateFormatTitle => 'Format daty';

  @override
  String get prefsHoursFormatTitle => 'Format godzin';

  @override
  String get prefsTimeFormatTitle => 'Format czasu';

  @override
  String get prefsTimeFormatSubtitle => '24 godziny';

  @override
  String get prefsTimePickerStyleTitle => 'Styl wyboru czasu';

  @override
  String get prefsTimePickerStyleSubtitle => 'Użyj tarczy';

  @override
  String get commonYes => 'Tak';

  @override
  String get commonNo => 'Nie';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonUpdate => 'Aktualizuj';

  @override
  String get commonAdd => 'Dodaj';

  @override
  String get commonApply => 'Zastosuj';

  @override
  String get commonReset => 'Resetuj';

  @override
  String get commonFilterNone => 'Brak';

  @override
  String get commonStatus => 'Status';

  @override
  String get statusOpen => 'Otwarte';

  @override
  String get statusPaid => 'Opłacone';

  @override
  String get commonProject => 'Projekt';

  @override
  String get commonClient => 'Klient';

  @override
  String get commonTag => 'Tag';

  @override
  String get commonNote => 'Notatka';

  @override
  String get commonDescription => 'Opis';

  @override
  String get commonBreak => 'Przerwa';

  @override
  String get commonStartTime => 'Czas startu';

  @override
  String get commonEndTime => 'Czas zakończenia';

  @override
  String get commonWorkHours => 'Godziny pracy';

  @override
  String get commonHourlyRate => 'Stawka / godz.';

  @override
  String get commonBillable => 'Podlega płatności';

  @override
  String get commonAddExpense => 'Dodaj koszt';

  @override
  String get commonAddMileage => 'Dodaj przebieg';

  @override
  String get commonAddTime => 'Dodaj czas';

  @override
  String get commonEditTime => 'Edytuj czas';

  @override
  String get commonSaveAndCreate => 'Zapisz i\nutwórz';

  @override
  String get commonSaveAndFinish => 'Zapisz i\nzakończ';

  @override
  String get commonBreakMinutesSuffix => 'w minutach';

  @override
  String get commonTaskHint => 'Jakie zadanie wykonałeś?';

  @override
  String get commonDefaultClient => 'Domyślny klient';

  @override
  String get commonAmount => 'Kwota';

  @override
  String get commonDistanceKm => 'Dystans (km)';

  @override
  String get expenseAddTitle => 'Dodaj koszt';

  @override
  String get mileageAddTitle => 'Dodaj przebieg';

  @override
  String get expenseAdded => 'Dodano koszt';

  @override
  String get mileageAdded => 'Dodano przebieg';

  @override
  String calendarFilter(Object value) {
    return 'Filtr: $value';
  }

  @override
  String get calendarAddEntry => 'Dodaj wpis (+)';

  @override
  String get calendarWeek => 'tyg';

  @override
  String get calendarMon => 'Pn';

  @override
  String get calendarTue => 'Wt';

  @override
  String get calendarWed => 'Śr';

  @override
  String get calendarThu => 'Czw';

  @override
  String get calendarFri => 'Pt';

  @override
  String get calendarSat => 'Sb';

  @override
  String get calendarSun => 'Nd';

  @override
  String get calendarRate => 'Stawka';

  @override
  String get timePeriodMonth => 'Miesiąc';

  @override
  String get timePeriodWeek => 'Tydzień';

  @override
  String get timeNoEntries => 'Brak wpisów w okresie';

  @override
  String get timeFilterTitle => 'Filtr';

  @override
  String get timeFilterAll => 'Wszystkie';

  @override
  String get timeFilterOpen => 'Otwarte';

  @override
  String get timeFilterPaid => 'Opłacone';

  @override
  String get timeSortDate => 'Data';

  @override
  String get timeSortAmount => 'Kwota';

  @override
  String get timeSortProject => 'Projekt';

  @override
  String get timeSortClient => 'Klient';

  @override
  String get timeCreateProjectFirst => 'Najpierw utwórz projekt';

  @override
  String get clientTitle => 'Klient';

  @override
  String get clientAddTitle => 'Dodaj klienta';

  @override
  String get clientUpdateTitle => 'Aktualizuj klienta';

  @override
  String get clientName => 'Imię';

  @override
  String get clientAddress => 'Adres';

  @override
  String get clientGeo => 'Geolokalizacja';

  @override
  String get clientPhone => 'Telefon';

  @override
  String get clientEmail => 'Email';

  @override
  String get clientDesc => 'Opis';

  @override
  String get clientNotFound => 'Nie znaleziono klienta';

  @override
  String get clientNoClients => 'Brak klientów';

  @override
  String get clientQuickInfoTitle => 'Szybka informacja';

  @override
  String get clientNameHint => 'Maks. 30 znaków';

  @override
  String get projectTitle => 'Projekt';

  @override
  String get projectAddTitle => 'Dodaj projekt';

  @override
  String get projectUpdateTitle => 'Aktualizuj projekt';

  @override
  String get projectNoProjects => 'Brak projektów';

  @override
  String get projectNoName => 'Bez nazwy';

  @override
  String get projectName => 'Projekt';

  @override
  String get projectTypeHourly => 'Godzinowo';

  @override
  String get projectTypeFixed => 'Stała stawka';

  @override
  String get projectNotBillable => 'Niepłatne';

  @override
  String get projectBudget => 'Budżet';

  @override
  String get projectNoBudget => 'Brak budżetu';

  @override
  String get projectBudgetHours => 'Godziny budżetu';

  @override
  String get projectBudgetFees => 'Opłaty budżetu';

  @override
  String get projectClientAll => 'Puste oznacza wszystkich klientów';

  @override
  String get projectRoundHour => 'Zaokrąglone godziny';

  @override
  String get projectTypeLabel => 'Typ';

  @override
  String get projectTypeHourlyDesc =>
      'Płatność godzinowa według stawki. Im dłużej pracujesz, tym więcej zarabiasz.';

  @override
  String get projectTypeFixedDesc =>
      'Stała opłata za zlecenie niezależnie od godzin.';

  @override
  String get projectPremiumStub =>
      'Stawka premium, Godziny premium, Po pewnym czasie (placeholder)';

  @override
  String get projectAmountHint => 'Kwota';

  @override
  String get dataTitle => 'Baza danych';

  @override
  String get dataAutoBackupTitle => 'Automatyczne kopie';

  @override
  String get dataAutoBackupSubtitle =>
      'Zapisuj lokalną kopię w folderze backups';

  @override
  String get dataCreateBackup => 'Utwórz kopię bazy';

  @override
  String get dataCreateBackupSubtitle => 'Lokalna kopia .sqlite';

  @override
  String get dataRestoreBackup => 'Przywróć bazę';

  @override
  String get dataRestoreBackupSubtitle => 'Przywróć ostatnią kopię';

  @override
  String get dataEmailBackup => 'Wyślij bazę e-mailem';

  @override
  String get dataEmailBackupSubtitle => 'Pokaż ścieżkę ostatniej kopii';

  @override
  String get dataDeleteAll => 'Usuń wszystkie wpisy';

  @override
  String get dataDeleteAllSubtitle => 'Wyczyść tabele klientów/projektów/czasu';

  @override
  String get dataRecentBackups => 'Ostatnie kopie';

  @override
  String get dataNoBackupsTitle => 'Brak kopii';

  @override
  String get dataNoBackupsSubtitle => 'Utwórz pierwszą kopię powyżej';

  @override
  String get dataRestoreConfirmTitle => 'Przywróć kopię';

  @override
  String get dataRestoreConfirmBody =>
      'Bieżące dane zostaną zastąpione. Kontynuować?';

  @override
  String get dataRestored => 'Baza przywrócona';

  @override
  String get dataBackupCreated => 'Utworzono kopię';

  @override
  String get dataBackupNotFound => 'Nie znaleziono kopii';

  @override
  String get dataRestoredRestart => 'Baza przywrócona. Uruchom ponownie.';

  @override
  String get dataBackupFolderLabel => 'Folder backup';

  @override
  String get dataConfirmTitle => 'Potwierdzenie';

  @override
  String get dataConfirmDeleteBody => 'Usunąć wszystkie wpisy?';

  @override
  String get dataCleared => 'Dane wyczyszczone';

  @override
  String get commonHoursSuffix => 'h';

  @override
  String get commonPerHourSuffix => '/godz';

  @override
  String get commonDay => 'Dzień';

  @override
  String get commonWeek => 'Tydzień';

  @override
  String get commonEnabled => 'Włącz';

  @override
  String get commonDisabled => 'Wyłącz';

  @override
  String commonError(Object value) {
    return 'Błąd: $value';
  }

  @override
  String get calendarThisMonth => 'W tym miesiącu';

  @override
  String get startSampleProject => 'Jane Godzinowo';

  @override
  String get startSampleClient => 'Jane';

  @override
  String get startStartWork => 'Start pracy';

  @override
  String get startStartedAt => 'Rozpoczęto o';

  @override
  String get startDayLabel => 'Dzień';

  @override
  String get startWeekLabel => 'Tydzień';

  @override
  String get clientHoursTitle => 'Godziny';

  @override
  String get clientTotalLabel => 'Razem';

  @override
  String get clientPaidLabel => 'Opłacone';

  @override
  String get clientUnpaidLabel => 'Nieopłacone';

  @override
  String get clientIncomeTitle => 'Dochód';

  @override
  String get clientWorkLabel => 'Praca';

  @override
  String get clientExpensesLabel => 'Wydatki';

  @override
  String get clientMileageLabel => 'Przebieg';

  @override
  String get clientInvoiceTitle => 'Faktura';

  @override
  String get clientExpectedLabel => 'Oczekujące';

  @override
  String get clientEffectiveRateTitle => 'Efektywna stawka godzinowa';

  @override
  String get clientTotalHoursLabel => 'Łączna liczba godzin';

  @override
  String get clientPerHourLabel => 'Za godz.';

  @override
  String get clientStatusLabel => 'Status';

  @override
  String get clientStatusActive => 'Aktywny';

  @override
  String clientProjectFallback(Object id) {
    return 'Projekt #$id';
  }

  @override
  String get settingsTabGeneral => 'Ogólne';

  @override
  String get settingsTabTime => 'Czas';

  @override
  String get settingsTabPreferences => 'Preferencje';

  @override
  String get settingsClientTitle => 'Klient';

  @override
  String get settingsClientSubtitle => 'Skonfiguruj wielu klientów';

  @override
  String get settingsProjectTitle => 'Projekt';

  @override
  String get settingsProjectSubtitle =>
      'Wstępnie zdefiniowane projekty ze stawkami i zasadami';

  @override
  String get settingsWorkDescTitle => 'Opis pracy';

  @override
  String get settingsWorkDescSubtitle => 'Domyślny opis pracy';

  @override
  String get settingsExpensesTitle => 'Wydatki/odliczenia';

  @override
  String get settingsExpensesSubtitle => 'Zdefiniowane wydatki/odliczenia';

  @override
  String get settingsHolidayTitle => 'Zarządzanie świętami';

  @override
  String get settingsHolidaySubtitle =>
      'Gdy obowiązuje święto, premie/nadgodziny nie są używane';

  @override
  String get settingsPremiumTitle => 'Godziny premium';

  @override
  String get settingsPremiumSubtitle =>
      'Jeśli użyto godzin premium, nadgodziny nie są naliczane';

  @override
  String get settingsAfterTimeTitle => 'Po pewnym czasie';

  @override
  String get settingsAfterTimeSubtitle => 'Automatycznie obliczaj nadgodziny';

  @override
  String get settingsTagTitle => 'Tag';

  @override
  String get settingsTagSubtitle => 'Filtruj i porządkuj dane';

  @override
  String get settingsEmpty => 'Brak wpisów';

  @override
  String get settingsAddPreset => 'Dodaj wpis';

  @override
  String get settingsEditPreset => 'Edytuj wpis';

  @override
  String get settingsNameLabel => 'Nazwa';

  @override
  String get settingsIsDeduction => 'Odliczenie';

  @override
  String get settingsMultiplierLabel => 'Mnożnik';

  @override
  String get settingsWorkDescHint => 'Tekst opisu';

  @override
  String get settingsTagHint => 'Nazwa tagu';

  @override
  String get settingsTimeSection => 'Czas';

  @override
  String get settingsConfirmStopTitle => 'Potwierdź zatrzymanie timera';

  @override
  String get settingsConfirmStopSubtitle => 'Włącz';

  @override
  String get settingsEditAfterStopTitle => 'Edytuj wpis czasu';

  @override
  String get settingsEditAfterStopSubtitle => 'Po zatrzymaniu timera';

  @override
  String get settingsSwitchTimerTitle => 'Przełączanie timera';

  @override
  String get settingsSwitchTimerSubtitle => 'Pozwól przełączać projekt';

  @override
  String get settingsCheckinLocationTitle => 'Miejsce zameldowania';

  @override
  String get settingsCheckinLocationSubtitle => 'Wyłącz';

  @override
  String get settingsCurrencyFormatTitle => 'Format waluty';

  @override
  String get settingsTimeFormatTitle => 'Format czasu';

  @override
  String get settingsTimeFormatSubtitle => '24 godziny';

  @override
  String get settingsTimePickerStyleTitle => 'Styl wyboru czasu';

  @override
  String get settingsTimePickerStyleSubtitle => 'Użyj tarczy';

  @override
  String get shareDescription => 'Udostępnij aplikację znajomym';

  @override
  String get languageNameUkr => 'Ukraiński';

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
  String get helpTitle => 'Opis aplikacji';

  @override
  String get helpContent =>
      'Jak używać\nPrzed rozpoczęciem skonfiguruj Klientów, Projekty i Firmę w Ustawieniach.\nNastępnie możesz dodać wpis czasu.\nMożesz analizować wpisy czasu za pomocą histogramu/wykresu liniowego.\nMożesz eksportować wpisy do HTML, EXCEL i CSV.\nMożesz wystawić fakturę w PDF i wysłać klientowi.\n\nEwidencja czasu pracy\nDotknij „Tytuł”, aby zmienić okres.\nDotknij Plusa, aby dodać nowy wpis czasu.\nDotknij „Dodaj wiele wpisów”, aby dodać kilka wpisów naraz.\nDotknij Eksport/E-mail, aby wyeksportować/wysłać HTML, EXCEL lub CSV.\nDotknij ikony kalendarza, aby przejść do widoku kalendarza.\nDotknij Filtr, aby filtrować wg tagu, statusu, klienta i projektu.\nDotknij Sortuj, aby sortować wg Daty, Kwoty, Projektu i Klienta.\nDotknij wpis czasu, aby zaktualizować, usunąć lub skopiować.\nDługie przytrzymanie wpisu czasu umożliwia wielokrotny wybór.\n\nDodawanie wpisu godzinowego/stałego\nW ustawieniach projektu wybierz stawkę godzinową/stałą.\nPodczas dodawania wpisu wybierz projekt godzinowy/stały.\nNowy wpis użyje stawki na podstawie ustawień projektu.\n\nNadgodziny\nW ustawieniach projektu wybierz dzienne/tygodniowe/dwutygodniowe/miesięczne nadgodziny.\nUstaw próg godzin i stawkę nadgodzin.\n\nGodziny premium\nW ustawieniach projektu wybierz godziny premium.\nUstaw czas i datę początku/końca.\nGodziny premium są liczone per projekt.\n\nOperacje seryjne\nWybierz wiele wpisów czasu przez długie przytrzymanie.\nPo zaznaczeniu możesz masowo zmieniać status, tagować, kopiować i usuwać.\nMożesz dodawać wpisy w paczkach i pomijać daty.\n\nEksport wpisów czasu\nNa ekranie czasu dotknij ikony Udostępnij.\nNa ekranie danych wybierz okres i filtry.\nNa ekranie formatu wybierz Excel, Html lub Csv.\nRaport może grupować wg daty, tygodnia, statusu, tagu, projektu i klienta.\nRaport może być zbiorczy lub szczegółowy.\nMożesz też sortować kolumny.\n\nImport wpisów czasu\nNa ekranie czasu dotknij ikony importu.\nMożesz importować wpisy z innych aplikacji.\nPlik importu ma format Csv.\n\nFaktura\nDotknij Plusa, aby dodać nową fakturę.\nDotknij faktury, aby otworzyć ją w czytniku PDF.\n\nDodaj nową fakturę\nNajpierw wybierz Klienta.\nNastępnie wybierz godziny pracy klikając „Godziny”; dostępne są tylko statusy „otwarte” lub „w toku”.\n\nWykresy\nPokazuje miesięczną kwotę i godziny na histogramie i wykresie liniowym.\nDotknij Filtr, aby filtrować dane wykresu wg projektu, klienta, tagu i statusu.\nDotknij ikony dolara, aby pokazać wykres kwoty.\n\nKopia zapasowa/przywracanie\nMożesz wykonać kopię bazy danych na e-mail, kartę SD lub Google Drive.\nMożesz przywrócić bazę z karty SD lub Google Drive.\n\n1. Eksport raportów do CSV, HTML i EXCEL.\n2. Nielimitowana liczba faktur.';

  @override
  String get contactTitle => 'Kontakt z twórcą';

  @override
  String get contactHeader => 'Kontakt z twórcą';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get contactTelegramLabel => 'Telegram';

  @override
  String get contactBody =>
      'Opisz problem lub sugestię, dodaj zrzut ekranu i wersję aplikacji.';

  @override
  String stubInProgress(Object title) {
    return 'Strona \"$title\" w budowie';
  }

  @override
  String get statsTitle => 'Statystyka';

  @override
  String get statsHistogramTitle => 'Histogram';

  @override
  String get statsHistogramSubtitle =>
      'Pokazuje godziny pracy, nadgodziny, kwotę, wydatki, przebieg w okresie';

  @override
  String get statsLineTitle => 'Wykres liniowy';

  @override
  String get statsLineSubtitle => 'Pokazuje godziny/ilość pracy w okresie';

  @override
  String get statsPieTitle => 'Wykres kołowy';

  @override
  String get statsPieSubtitle => 'Pokazuje rozkład godzin/ilości w procentach';

  @override
  String get statsMileageTitle => 'Wykres przebiegu';

  @override
  String get statsMileageSubtitle =>
      'Wyświetla godziny/kwotę przebiegu na wykresie';

  @override
  String get statsFilterIncludeNonBillable => 'Filtr: uwzględnij niepłatne';

  @override
  String get statsNoData => 'Brak danych';

  @override
  String get statsNoMetrics => 'Brak wybranych wskaźników';

  @override
  String statsAverageLabel(Object value) {
    return 'Średnia ($value)';
  }

  @override
  String get statsLegendWork => 'Praca';

  @override
  String get statsLegendOvertime => 'Nadgodziny';

  @override
  String get statsLegendExpenses => 'Wydatki';

  @override
  String get statsLegendMileage => 'Przebieg';

  @override
  String get statsMetricHours => 'Godziny';

  @override
  String get statsMetricAmount => 'Kwota';

  @override
  String get statsTypeShortHistogram => 'Hist...';

  @override
  String get statsTypeShortLine => 'Linia...';

  @override
  String get statsTypeShortPie => 'Koło...';

  @override
  String get statsTypeShortMileage => 'Przeb...';

  @override
  String get statsTypeHistogram => 'Histogram';

  @override
  String get statsTypeLine => 'Liniowy';

  @override
  String get statsTypePie => 'Kołowy';

  @override
  String get statsTypeMileage => 'Wykres przebiegu';

  @override
  String get statsPeriodWeek => 'Tydzień';

  @override
  String get statsPeriodMonth => 'Miesiąc';

  @override
  String get statsPeriodYear => 'Rok';

  @override
  String statsWeekRange(Object range, Object week) {
    return 't$week · $range';
  }

  @override
  String get settingsAfterMinutesLabel => 'Po (minuty)';

  @override
  String validationRequired(Object field) {
    return 'Wypełnij pole: $field';
  }

  @override
  String get validationInvalidNumber => 'Nieprawidłowa wartość liczbowa';

  @override
  String get validationTimeRange =>
      'Czas zakończenia musi być późniejszy niż czas rozpoczęcia';
}
