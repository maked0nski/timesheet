const baseUrl = process.env.APP_URL || 'http://localhost:3000';

async function expectStatus(path, expected) {
  const response = await fetch(`${baseUrl}${path}`);
  if (response.status !== expected) {
    throw new Error(`${path}: expected ${expected}, got ${response.status}`);
  }
  return response;
}

await expectStatus('/api/session', 200);
await expectStatus('/api/summary', 401);
await expectStatus('/api/clients', 401);
await expectStatus('/manifest.webmanifest', 200);

const manifest = await (await fetch(`${baseUrl}/manifest.webmanifest`)).json();
if (manifest.display !== 'standalone') throw new Error('PWA manifest is not standalone');

console.log('api smoke ok');
