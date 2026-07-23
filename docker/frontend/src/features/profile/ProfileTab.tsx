import React from 'react';
import { ArrowLeft, Camera, LogOut, Save } from 'lucide-react';
import type { UserProfile } from '../../types';
import { LanguageSelect, type Locale } from '../../i18n';

type Props = {
  profile: UserProfile;
  onBack: () => void;
  onLogout: () => void;
  onPasswordChange: (event: React.FormEvent<HTMLFormElement>) => Promise<void>;
  onEmailChange: (event: React.FormEvent<HTMLFormElement>) => Promise<void>;
  onDeleteAccount: (event: React.FormEvent<HTMLFormElement>) => Promise<void>;
  onSave: (event: React.FormEvent<HTMLFormElement>, avatarUrl: string) => Promise<void>;
  locale: Locale;
  onLocaleChange: (locale: Locale) => void;
  t: (key: 'profile' | 'changePhoto' | 'name' | 'email' | 'phone' | 'info' | 'back' | 'save' | 'logout' | 'password' | 'currentPassword' | 'newPassword' | 'changePassword' | 'changeEmail' | 'deleteAccount' | 'deleteAccountHint') => string;
};

export function ProfileTab({ profile, onBack, onLogout, onPasswordChange, onEmailChange, onDeleteAccount, onSave, locale, onLocaleChange, t }: Props) {
  const [avatarUrl, setAvatarUrl] = React.useState(profile.avatar_url || '');

  React.useEffect(() => {
    setAvatarUrl(profile.avatar_url || '');
  }, [profile.avatar_url]);

  function readAvatar(event: React.ChangeEvent<HTMLInputElement>) {
    const file = event.currentTarget.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => setAvatarUrl(String(reader.result || ''));
    reader.readAsDataURL(file);
  }

  return (
    <section className="service-page profile-page">
      <header className="service-header">
        <button className="service-icon back" onClick={onBack} title={t('back')}><ArrowLeft /></button>
        <h1>{t('profile')}</h1>
        <span />
      </header>

      <form className="profile-form" onSubmit={(event) => onSave(event, avatarUrl)}>
        <div className="profile-avatar-row">
          <label className="profile-avatar" title={t('changePhoto')}>
            {avatarUrl ? <img src={avatarUrl} alt={t('changePhoto')} /> : <span>{(profile.display_name || profile.username || 'U').slice(0, 1).toUpperCase()}</span>}
            <input type="file" accept="image/*" onChange={readAvatar} />
            <Camera />
          </label>
          <div>
            <strong>{profile.display_name || profile.username}</strong>
            <span>{profile.email || profile.username}</span>
          </div>
        </div>

        <label>
          {t('name')}
          <input name="display_name" defaultValue={profile.display_name || profile.username || ''} required />
        </label>
        <label>
          {t('email')}
          <input value={profile.email || profile.username || ''} readOnly />
        </label>
        <label>
          {t('phone')}
          <input name="phone" defaultValue={profile.phone || ''} inputMode="tel" />
        </label>
        <label>
          {t('info')}
          <textarea name="bio" defaultValue={profile.bio || ''} rows={5} />
        </label>
        <LanguageSelect locale={locale} onChange={onLocaleChange} />
        <input type="hidden" name="locale" value={locale} />
        <input type="hidden" name="avatar_url" value={avatarUrl} />

        <div className="service-actions">
          <button type="button" onClick={onBack}>{t('back')}</button>
          <button type="submit"><Save /> {t('save')}</button>
        </div>
      </form>

      <form className="profile-form compact" onSubmit={onPasswordChange}>
        <h2>{t('changePassword')}</h2>
        <label>{t('currentPassword')}<input name="current_password" type="password" autoComplete="current-password" required /></label>
        <label>{t('newPassword')}<input name="new_password" type="password" autoComplete="new-password" minLength={8} required /></label>
        <button type="submit">{t('changePassword')}</button>
      </form>

      <form className="profile-form compact" onSubmit={onEmailChange}>
        <h2>{t('changeEmail')}</h2>
        <label>{t('email')}<input name="email" type="email" autoComplete="email" required /></label>
        <button type="submit">{t('changeEmail')}</button>
      </form>

      <form className="profile-form compact danger" onSubmit={onDeleteAccount}>
        <h2>{t('deleteAccount')}</h2>
        <p>{t('deleteAccountHint')}</p>
        <label>{t('password')}<input name="password" type="password" autoComplete="current-password" required /></label>
        <button type="submit">{t('deleteAccount')}</button>
      </form>

      <div className="profile-form compact">
        <button className="profile-logout" type="button" onClick={onLogout}><LogOut /> {t('logout')}</button>
      </div>
    </section>
  );
}
