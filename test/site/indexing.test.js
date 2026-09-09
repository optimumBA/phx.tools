import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

test('built robots contains real lines and the canonical sitemap', async () => {
  const robots = await readFile(new URL('../../dist/robots.txt', import.meta.url), 'utf8');
  assert.ok(!robots.includes('\\n'));
  assert.deepEqual(robots.trim().split('\n'), [
    'User-agent: *', 'Allow: /', '',
    'User-agent: OAI-SearchBot', 'Allow: /', '',
    'Sitemap: https://phx.tools/sitemap.xml',
  ]);
  const sitemap = await readFile(new URL('../../dist/sitemap.xml', import.meta.url), 'utf8');
  assert.ok(sitemap.includes('<loc>https://phx.tools/</loc>'));
});
