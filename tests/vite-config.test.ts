/**
 * @jest-environment node
 */
import configFactory from '../vite.config.ts';

describe('vite configuration', () => {
  test('loads plugins and server options', async () => {
    const cfg = await configFactory({ mode: 'test', command: 'build' });
    expect(Array.isArray(cfg.plugins) && cfg.plugins.length > 0).toBe(true);
    expect(cfg.server?.open).toBe(true);
  });

  test('manualChunks splits node modules', async () => {
    const cfg = await configFactory({ mode: 'test', command: 'build' });
    const manual = cfg.build?.rollupOptions?.output?.manualChunks as (id: string) => string | undefined;
    expect(typeof manual).toBe('function');
    if (typeof manual === 'function') {
      expect(manual('node_modules/foo/index.js')).toBe('foo');
    }
  });

  test('visualizer plugin added when ANALYZE=true', async () => {
    process.env.ANALYZE = 'true';
    const cfg = await configFactory({ mode: 'test', command: 'build' });
    const hasVisualizer = (cfg.plugins || []).some((p) => p && p.name === 'visualizer');
    expect(hasVisualizer).toBe(true);
    delete process.env.ANALYZE;
  });
});
