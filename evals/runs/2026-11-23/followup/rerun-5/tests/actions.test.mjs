import test from 'node:test';
import assert from 'node:assert/strict';
import { openSection, routes } from '../src/actions.mjs';
test('each action preserves analytics then navigation contract', () => {
 for (const section of Object.keys(routes)) { const calls=[]; openSection(section, route=>calls.push(['navigate',route]), (event,data)=>calls.push(['track',event,data])); assert.deepEqual(calls,[['track','section_opened',{section}],['navigate',routes[section]]]); }
});
test('invalid section has no side effects', () => {let count=0; assert.throws(()=>openSection('unknown',()=>count++,()=>count++));assert.equal(count,0);});
