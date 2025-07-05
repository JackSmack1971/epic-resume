import {
  isPerformanceMetrics,
  isUserPreferences,
  isApplicationState,
  isNavigationItem,
  isResumeData,
  isGlassCardProps,
  isApiResponse,
  isContactEvent,
  Skill,
  Project,
  ExperienceItem
} from '../src/types/app.ts';

// Runtime type tests

describe('runtime type guards', () => {
  test('valid PerformanceMetrics', () => {
    const obj = { firstPaint: 0.2, timeToInteractive: 1, resourcesLoaded: 10 };
    expect(isPerformanceMetrics(obj)).toBe(true);
  });

  test('invalid PerformanceMetrics', () => {
    expect(isPerformanceMetrics({})).toBe(false);
  });

  test('valid UserPreferences', () => {
    const obj = { theme: 'light', language: 'en', showParticles: true };
    expect(isUserPreferences(obj)).toBe(true);
  });

  test('valid ApplicationState', () => {
    const obj = {
      metrics: { firstPaint: 1, timeToInteractive: 2, resourcesLoaded: 3 },
      prefs: { theme: 'dark', language: 'en', showParticles: false }
    };
    expect(isApplicationState(obj)).toBe(true);
  });

  test('invalid ApplicationState', () => {
    expect(isApplicationState({})).toBe(false);
  });

  test('NavigationItem guard', () => {
    expect(isNavigationItem({ id: 'home', label: 'Home' })).toBe(true);
    expect(isNavigationItem({ id: 'home' })).toBe(false);
  });

  test('GlassCardProps guard', () => {
    expect(
      isGlassCardProps({ title: 't', content: 'c', footer: 'f' })
    ).toBe(true);
    expect(isGlassCardProps({ title: 't' })).toBe(false);
  });

  test('ResumeData guard', () => {
    const resume = {
      basics: { name: 'N', label: 'L', email: 'e@mail.com' },
      skills: [{ name: 'JS', level: 3 } as Skill],
      projects: [{ name: 'p', description: 'd', url: 'u' } as Project],
      experience: [
        {
          title: 't',
          company: 'c',
          start: '2020',
          details: []
        } as ExperienceItem
      ]
    };
    expect(isResumeData(resume)).toBe(true);
    expect(isResumeData({})).toBe(false);
  });

  test('ApiResponse guard', () => {
    const res = { data: 1 };
    const check = (v: unknown): v is number => typeof v === 'number';
    expect(isApiResponse(res, check)).toBe(true);
    expect(isApiResponse({}, check)).toBe(false);
  });

  test('ContactEvent guard', () => {
    expect(
      isContactEvent({ email: 'a@b.com', message: 'hi' })
    ).toBe(true);
    expect(isContactEvent({ email: 'a@b.com' })).toBe(false);
  });
});
