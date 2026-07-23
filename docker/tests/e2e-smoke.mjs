import { chromium } from 'playwright';

const baseUrl = process.env.APP_URL || 'http://localhost:3000';
const browser = await chromium.launch();
const page = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true });

await page.goto(baseUrl, { waitUntil: 'networkidle' });
await page.getByLabel('Мова').selectOption('en');
await page.getByRole('button', { name: 'Sign in' }).waitFor();
await page.getByRole('button', { name: 'Register' }).click();
await page.getByText('Create account').waitFor();
await page.getByLabel('Language').selectOption('uk');
await page.getByText('Створити акаунт').waitFor();

await browser.close();
console.log('e2e smoke ok');
