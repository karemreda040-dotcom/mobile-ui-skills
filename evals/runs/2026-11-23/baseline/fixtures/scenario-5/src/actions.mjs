export const routes = Object.freeze({ tasks: 'TaskList', focus: 'FocusTimer', profile: 'Profile' });
export function openSection(section, navigate, track) {
  if (!Object.hasOwn(routes, section)) throw new Error('Unknown section');
  track('section_opened', { section });
  navigate(routes[section]);
}
