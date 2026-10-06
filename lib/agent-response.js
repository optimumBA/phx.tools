// Negotiate generated page representations; ordinary HTML and asset responses remain authoritative.
export function wantsMarkdown(accept = '') {
  const entries = (accept || '').toLowerCase().split(',').map(value => {
    const [type, ...parameters] = value.trim().split(';');
    const qValue = parameters.find(part => part.trim().startsWith('q='));
    const q = qValue ? Number(qValue.trim().slice(2)) : 1;
    return { type, q: Number.isFinite(q) && q >= 0 && q <= 1 ? q : 0 };
  });
  const markdown = Math.max(0, ...entries.filter(e => e.type === 'text/markdown').map(e => e.q));
  const html = Math.max(0, ...entries.filter(e => ['text/html', 'text/*', '*/*'].includes(e.type)).map(e => e.q));
  return markdown > 0 && markdown >= html;
}

export async function agentContent(context) {
  const request = context.request;
  const downstreamHeaders = new Headers(request.headers);
  if (wantsMarkdown(request.headers.get('Accept'))) {
    for (const name of ['If-None-Match', 'If-Modified-Since', 'Range', 'If-Range']) downstreamHeaders.delete(name);
  }
  const original = await context.next(new Request(request, {headers: downstreamHeaders}));
  const isPage = (original.headers.get('Content-Type') || '').includes('text/html');
  if (!['GET', 'HEAD'].includes(request.method) || !isPage) return original;
  const headers = new Headers(original.headers);
  const vary = new Set((headers.get('Vary') || '').split(',').map(s => s.trim()).filter(Boolean));
  if (![...vary].some(s => s.toLowerCase() === 'accept')) vary.add('Accept');
  headers.set('Vary', [...vary].join(', '));
  const requestedUrl = new URL(request.url);
  const markdownPath = requestedUrl.pathname === '/' ? '/index.md' : requestedUrl.pathname.replace(/\/+$/, '').replace(/\.html$/, '') + '.md';
  const links = `<${requestedUrl.origin}${markdownPath}>; rel="alternate"; type="text/markdown", <${requestedUrl.origin}/llms.txt>; rel="describedby"; type="text/plain", <${requestedUrl.origin}/sitemap.xml>; rel="sitemap"; type="application/xml"`;
  if (original.status === 200) headers.set('Link', links);
  if (!wantsMarkdown(request.headers.get('Accept'))) return new Response(original.body, {status: original.status, statusText: original.statusText, headers});
  if (original.status === 404) {
    if (original.body) await original.body.cancel();
    const url = new URL(request.url);
    const body = `# Page not found\n\nThis address does not have a public page.\n\n[Home](${url.origin}/) · [Sitemap](${url.origin}/sitemap.xml) · [Agent guide](${url.origin}/llms.txt)\n`;
    for (const name of ['Content-Length', 'Content-Encoding', 'ETag', 'Last-Modified']) headers.delete(name);
    headers.set('Content-Type', 'text/markdown; charset=utf-8');
    return new Response(request.method === 'HEAD' ? null : body, {status:404, headers});
  }
  if (original.status !== 200) return new Response(original.body, {status:original.status, statusText:original.statusText, headers});
  if (original.body) await original.body.cancel();
  const target = new URL(request.url);
  const path = target.pathname.replace(/\/+$/, '') || '/';
  target.pathname = path === '/' ? '/agent-content/index.md' : `/agent-content${path.replace(/\.html$/, '')}.md`;
  target.search = '';
  const markdown = await context.env.ASSETS.fetch(new Request(target, {method:'GET'}));
  if (markdown.status !== 200 || !(markdown.headers.get('Content-Type') || '').includes('text/markdown')) {
    // A build/source mismatch must remain visible as a failed representation, never a false Markdown 200.
    if (markdown.body) await markdown.body.cancel();
    headers.set('Content-Type', 'text/markdown; charset=utf-8');
    for (const name of ['Content-Length', 'Content-Encoding', 'ETag', 'Last-Modified']) headers.delete(name);
    return new Response(request.method === 'HEAD' ? null : '# Representation unavailable\n\nUse the HTML page or the sitemap while this page is rebuilt.\n', {status:503, headers});
  }
  for (const name of ['Content-Length', 'Content-Encoding', 'ETag', 'Last-Modified']) headers.delete(name);
  headers.set('Content-Type', 'text/markdown; charset=utf-8');
  return new Response(request.method === 'HEAD' ? null : markdown.body, {status:200, headers});
}
