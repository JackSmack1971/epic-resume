import { toggleTheme } from '../src/theme.js';

describe('toggleTheme', () => {
  test('toggles between dark and light', () => {
    document.documentElement.setAttribute('data-theme', 'light');
    toggleTheme();
    expect(document.documentElement.getAttribute('data-theme')).toBe('dark');
    toggleTheme();
    expect(document.documentElement.getAttribute('data-theme')).toBe('light');
  });
});
