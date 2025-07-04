export function initParticles(count = 30) {
  const container = document.querySelector('.particles');
  if (!container) return;
  for (let i = 0; i < count; i++) {
    const el = document.createElement('div');
    el.className = 'particle';
    el.style.left = `${Math.random() * 100}%`;
    el.style.top = `${Math.random() * 100}%`;
    container.appendChild(el);
  }
}
