export async function onRequest({ request, env }) {
  if (request.method !== 'GET' && request.method !== 'HEAD') {
    return new Response(null, { status: 405, headers: { Allow: 'GET, HEAD' } });
  }

  const url = new URL(request.url);
  const installer = (request.headers.get('User-Agent') || '').startsWith('curl/');
  if (installer) {
    url.pathname = '/script.sh';
    url.search = '';
  }
  const asset = await env.ASSETS.fetch(new Request(url, request));
  const response = new Response(asset.body, asset);
  response.headers.set('Vary', 'User-Agent, Accept-Encoding');
  response.headers.set('Cache-Control', 'no-store');
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  response.headers.set('Content-Security-Policy', "default-src 'self'; base-uri 'self'; object-src 'none'; frame-ancestors 'self'; script-src 'self' 'unsafe-inline' https://plausible.io https://asciinema.org; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://asciinema.org; font-src 'self' https://fonts.gstatic.com https://asciinema.org; img-src 'self' data: https://asciinema.org https://*.asciinema.org; connect-src 'self' https://plausible.io https://asciinema.org https://*.asciinema.org; frame-src https://asciinema.org; media-src 'self' https://asciinema.org https://*.asciinema.org; form-action 'self'");
  if (installer || url.pathname === '/script.sh') {
    response.headers.set('Content-Type', 'application/x-shellscript');
  }
  return response;
}
