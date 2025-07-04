import { toggleTheme } from './theme.js';
import { initParticles } from './particles.js';

window.addEventListener('DOMContentLoaded', () => {
  const toggle = document.getElementById('theme-toggle');
  if (toggle) {
    toggle.addEventListener('click', toggleTheme);
  }
  initParticles();
});
