import React from 'react';

export type Locale = 'uk' | 'en';

const languageKey = 'timesheet.locale';

const messages = {
  uk: {
    loginSubtitle: 'Вхід до веб-версії обліку часу',
    email: 'Email',
    password: 'Пароль',
    signIn: 'Увійти',
    register: 'Реєстрація',
    forgotPassword: 'Забули пароль?',
    registerSubtitle: 'Після створення акаунта потрібно підтвердити email',
    name: "Ім'я",
    createAccount: 'Створити акаунт',
    backToLogin: 'До входу',
    passwordTitle: 'Пароль',
    forgotSubtitle: 'Надішлемо посилання для встановлення нового паролю',
    sendEmail: 'Надіслати лист',
    newPassword: 'Новий пароль',
    newPasswordSubtitle: 'Вкажіть новий пароль для акаунта',
    updatePassword: 'Оновити пароль',
    verifyEmail: 'Підтвердити email',
    profile: 'Профіль',
    changePhoto: 'Змінити фото',
    phone: 'Телефон',
    info: 'Інформація',
    language: 'Мова',
    back: 'Назад',
    save: 'Зберегти',
    logout: 'Вийти з акаунта',
    currentPassword: 'Поточний пароль',
    changePassword: 'Змінити пароль',
    changeEmail: 'Змінити email',
    deleteAccount: 'Видалити акаунт',
    deleteAccountHint: 'Видалення акаунта прибере всі клієнти, проєкти й записи часу.',
    admin: 'Адмін',
    users: 'Користувачі',
    activity: 'Активність',
    block: 'Заблокувати',
    unblock: 'Розблокувати',
    delete: 'Видалити',
    exportCsv: 'Експорт CSV',
    resendVerification: 'Надіслати підтвердження ще раз',
    savedProfile: 'Профіль оновлено',
    passwordChanged: 'Пароль змінено',
    emailChangeSent: 'Лист підтвердження відправлено на новий email',
    accountDeleted: 'Акаунт видалено',
  },
  en: {
    loginSubtitle: 'Sign in to the web time tracking app',
    email: 'Email',
    password: 'Password',
    signIn: 'Sign in',
    register: 'Register',
    forgotPassword: 'Forgot password?',
    registerSubtitle: 'Confirm your email after creating an account',
    name: 'Name',
    createAccount: 'Create account',
    backToLogin: 'Back to sign in',
    passwordTitle: 'Password',
    forgotSubtitle: 'We will send a link to set a new password',
    sendEmail: 'Send email',
    newPassword: 'New password',
    newPasswordSubtitle: 'Enter a new password for your account',
    updatePassword: 'Update password',
    verifyEmail: 'Verify email',
    profile: 'Profile',
    changePhoto: 'Change photo',
    phone: 'Phone',
    info: 'Info',
    language: 'Language',
    back: 'Back',
    save: 'Save',
    logout: 'Sign out',
    currentPassword: 'Current password',
    changePassword: 'Change password',
    changeEmail: 'Change email',
    deleteAccount: 'Delete account',
    deleteAccountHint: 'Deleting your account removes all clients, projects, and time entries.',
    admin: 'Admin',
    users: 'Users',
    activity: 'Activity',
    block: 'Block',
    unblock: 'Unblock',
    delete: 'Delete',
    exportCsv: 'Export CSV',
    resendVerification: 'Resend verification',
    savedProfile: 'Profile updated',
    passwordChanged: 'Password changed',
    emailChangeSent: 'Confirmation email sent to the new address',
    accountDeleted: 'Account deleted',
  },
} satisfies Record<Locale, Record<string, string>>;

export function useI18n(initialLocale?: string | null) {
  const [locale, setLocaleState] = React.useState<Locale>(() => {
    const stored = localStorage.getItem(languageKey);
    return stored === 'en' || initialLocale === 'en' ? 'en' : 'uk';
  });

  function setLocale(nextLocale: Locale) {
    setLocaleState(nextLocale);
    localStorage.setItem(languageKey, nextLocale);
    document.documentElement.lang = nextLocale;
  }

  React.useEffect(() => {
    document.documentElement.lang = locale;
  }, [locale]);

  const t = React.useCallback((key: keyof typeof messages.uk) => messages[locale][key] || messages.uk[key], [locale]);

  return { locale, setLocale, t };
}

export function LanguageSelect({ locale, onChange }: { locale: Locale; onChange: (locale: Locale) => void }) {
  return (
    <label className="language-select">
      <span>{messages[locale].language}</span>
      <select value={locale} onChange={(event) => onChange(event.currentTarget.value as Locale)}>
        <option value="uk">Українська</option>
        <option value="en">English</option>
      </select>
    </label>
  );
}
