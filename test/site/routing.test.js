import test from 'node:test';
import assert from 'node:assert/strict';
import { onRequest } from '../../functions/_middleware.js';

for (const ua of ['curl/', 'curl/8.7.1', 'curl/8 extra', 'curl', 'CURL/8', 'Curl/8', 'xcurl/8', 'Mozilla curl/8', 'Mozilla/5.0', 'Wget/1.21', 'Googlebot', '']) {
  for (const path of ['/', '/script.sh', '/robots.txt', '/missing?query=value']) {
    test(`${ua || 'empty UA'} ${path}`, async () => {
      let requested;
      const response = await onRequest({ request: new Request(`https://phx.tools${path}`, { headers: { 'User-Agent': ua } }), env: { ASSETS: { fetch: async request => { requested = new URL(request.url); return new Response('asset'); } } } });
      assert.equal(requested.pathname, ua.startsWith('curl/') ? '/script.sh' : new URL(`https://phx.tools${path}`).pathname);
      assert.equal(response.headers.get('Vary'), 'User-Agent, Accept-Encoding');
      if (ua.startsWith('curl/') || path === '/script.sh') assert.equal(response.headers.get('Content-Type'), 'application/x-shellscript');
    });
  }
}
for (const method of ['POST', 'OPTIONS', 'PUT']) test(`${method} stays unsupported`, async () => {
  assert.equal((await onRequest({ request: new Request('https://phx.tools/', { method }) })).status, 405);
});
