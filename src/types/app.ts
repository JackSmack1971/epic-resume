export interface PerformanceMetrics {
  firstPaint: number;
  timeToInteractive: number;
  resourcesLoaded: number;
}

export interface UserPreferences {
  theme: 'light' | 'dark';
  language: string;
  showParticles: boolean;
}

export interface ApplicationState {
  metrics: PerformanceMetrics;
  prefs: UserPreferences;
}

export interface GlassCardProps {
  title: string;
  content: string;
  footer?: string;
}

export interface NavigationItem {
  id: string;
  label: string;
}

export interface ThemeConfig {
  primary: string;
  secondary: string;
  accent: string;
}

export interface AnimationConfig {
  duration: number;
  delay?: number;
  easing: string;
}

export interface DeviceCapabilities {
  touch: boolean;
  hover: boolean;
  prefersReducedMotion: boolean;
}

export interface Skill {
  name: string;
  level: number;
}

export interface Project {
  name: string;
  description: string;
  url: string;
}

export interface ExperienceItem {
  title: string;
  company: string;
  start: string;
  end?: string;
  details: string[];
}

export interface ResumeData {
  basics: {
    name: string;
    label: string;
    email: string;
  };
  skills: Skill[];
  projects: Project[];
  experience: ExperienceItem[];
}

export interface ApiResponse<T> {
  data: T;
  error?: string;
}

export interface ContactEvent {
  email: string;
  message: string;
}

declare global {
  interface Window {
    APP_STATE?: ApplicationState;
  }

  namespace NodeJS {
    interface ProcessEnv {
      VITE_APP_ENV: string;
      VITE_API_URL: string;
    }
  }
}

function isObj(record: unknown): record is Record<string, unknown> {
  return typeof record === 'object' && record !== null;
}

export function isPerformanceMetrics(obj: unknown): obj is PerformanceMetrics {
  return (
    isObj(obj) &&
    typeof obj.firstPaint === 'number' &&
    typeof obj.timeToInteractive === 'number' &&
    typeof obj.resourcesLoaded === 'number'
  );
}

export function isUserPreferences(obj: unknown): obj is UserPreferences {
  return (
    isObj(obj) &&
    (obj.theme === 'light' || obj.theme === 'dark') &&
    typeof obj.language === 'string' &&
    typeof obj.showParticles === 'boolean'
  );
}

export function isApplicationState(obj: unknown): obj is ApplicationState {
  return (
    isObj(obj) &&
    isPerformanceMetrics(obj.metrics) &&
    isUserPreferences(obj.prefs)
  );
}

export function isGlassCardProps(obj: unknown): obj is GlassCardProps {
  return (
    isObj(obj) &&
    typeof obj.title === 'string' &&
    typeof obj.content === 'string' &&
    (typeof obj.footer === 'string' || obj.footer === undefined)
  );
}

export function isNavigationItem(obj: unknown): obj is NavigationItem {
  return (
    isObj(obj) &&
    typeof obj.id === 'string' &&
    typeof obj.label === 'string'
  );
}

export function isResumeData(obj: unknown): obj is ResumeData {
  if (!isObj(obj) || !isObj(obj.basics)) return false;
  const basics = obj.basics as Record<string, unknown>;
  return (
    typeof basics.name === 'string' &&
    typeof basics.label === 'string' &&
    typeof basics.email === 'string' &&
    Array.isArray(obj.skills) && obj.skills.every(isSkill) &&
    Array.isArray(obj.projects) && obj.projects.every(isProject) &&
    Array.isArray(obj.experience) && obj.experience.every(isExperienceItem)
  );
}

export function isSkill(obj: unknown): obj is Skill {
  return isObj(obj) && typeof obj.name === 'string' && typeof obj.level === 'number';
}

export function isProject(obj: unknown): obj is Project {
  return (
    isObj(obj) &&
    typeof obj.name === 'string' &&
    typeof obj.description === 'string' &&
    typeof obj.url === 'string'
  );
}

export function isExperienceItem(obj: unknown): obj is ExperienceItem {
  return (
    isObj(obj) &&
    typeof obj.title === 'string' &&
    typeof obj.company === 'string' &&
    typeof obj.start === 'string' &&
    (typeof obj.end === 'string' || obj.end === undefined) &&
    Array.isArray(obj.details) && obj.details.every(d => typeof d === 'string')
  );
}

export function isApiResponse<T>(obj: unknown, itemCheck: (d: unknown) => d is T): obj is ApiResponse<T> {
  return (
    isObj(obj) &&
    'data' in obj &&
    itemCheck((obj as ApiResponse<T>).data) &&
    (typeof obj.error === 'string' || obj.error === undefined)
  );
}

export function isContactEvent(obj: unknown): obj is ContactEvent {
  return (
    isObj(obj) &&
    typeof obj.email === 'string' &&
    typeof obj.message === 'string'
  );
}

export {};
