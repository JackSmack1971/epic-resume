export function initScrollAnimations() {
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.fade-in').forEach(el => observer.observe(el));

  const loader = document.getElementById('loading');
  if (loader) {
    window.addEventListener('load', () => {
      loader.classList.add('hidden');
    });
  }
}
