import { readFileSync } from 'node:fs';
import { resolve, join } from 'node:path';
import assert from 'node:assert/strict';
if (process.argv.length !== 4) throw new Error('Usage: node verify-token-preservation.mjs ORIGINAL_FIXTURE OUTPUT_FIXTURE');
const originalRoot = resolve(process.argv[2]);
const outputRoot = resolve(process.argv[3]);
const loadTheme = async (root) => (await import('data:text/javascript,' + encodeURIComponent(readFileSync(join(root, 'src/theme.ts'), 'utf8')))).theme;
function preserve(original, current, path = 'theme') {
  for (const [key, value] of Object.entries(original)) {
    if (value && typeof value === 'object') preserve(value, current[key], path + '.' + key);
    else assert.equal(current[key], value, path + '.' + key);
  }
}
preserve(await loadTheme(originalRoot), await loadTheme(outputRoot));
for (const path of ['src/actions.mjs', 'src/AppShell.tsx', 'tests/actions.test.mjs']) {
  assert.equal(readFileSync(join(outputRoot, path), 'utf8'), readFileSync(join(originalRoot, path), 'utf8'), path);
}
console.log('All existing theme token values and protected action/shell/test files preserved.');
