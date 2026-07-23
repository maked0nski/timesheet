export async function api<T>(path: string, options: RequestInit = {}): Promise<T> {
  const res = await fetch(path, {
    credentials: 'same-origin',
    headers: { 'Content-Type': 'application/json', ...(options.headers || {}) },
    ...options,
  });
  const text = await res.text();
  const data = text ? JSON.parse(text) : null;
  if (!res.ok) throw new Error(data?.error || 'Request failed');
  return data as T;
}

export function formPayload(form: HTMLFormElement) {
  const payload = Object.fromEntries(new FormData(form).entries()) as Record<string, FormDataEntryValue | boolean>;
  for (const checkbox of Array.from(form.querySelectorAll<HTMLInputElement>('input[type="checkbox"]'))) {
    payload[checkbox.name] = checkbox.checked;
  }
  return payload;
}
