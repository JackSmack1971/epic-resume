import { toggleTheme } from './theme.js';
import { initParticles } from './particles.js';
import { initNavigation } from './navigation.js';
import { initScrollAnimations } from './animation.js';
import './styles/style.css';

window.addEventListener('DOMContentLoaded', () => {
  const toggle = document.getElementById('themeToggle');
  if (toggle) {
    toggle.addEventListener('click', toggleTheme);
  }

  initParticles();
  initNavigation();
  initScrollAnimations();
});
