import { initParticles } from '../src/particles.js';

describe('initParticles', () => {
  test('creates particles in container', () => {
    document.body.innerHTML = '<div class="particles"></div>';
    initParticles(5);
    const container = document.querySelector('.particles');
    expect(container.children.length).toBe(5);
  });
});
