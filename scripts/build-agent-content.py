"""Generate page Markdown from the built public HTML; authored pages remain the content owner."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urljoin
import json,re

class Node:
    def __init__(self,tag='',attrs=None):self.tag,self.attrs,self.children=tag,dict(attrs or []),[]
class Parser(HTMLParser):
    def __init__(self):super().__init__(convert_charrefs=True);self.root=Node();self.stack=[self.root]
    def handle_starttag(self,tag,attrs):
        node=Node(tag,attrs);self.stack[-1].children.append(node)
        if tag not in {'area','base','br','col','embed','hr','img','input','link','meta','param','source','track','wbr'}:self.stack.append(node)
    def handle_startendtag(self,tag,attrs):self.handle_starttag(tag,attrs);self.handle_endtag(tag)
    def handle_endtag(self,tag):
        for i in range(len(self.stack)-1,0,-1):
            if self.stack[i].tag==tag:self.stack=self.stack[:i];break
    def handle_data(self,data):self.stack[-1].children.append(data)

def find(node,tag):
    if not isinstance(node,Node):return None
    if node.tag==tag:return node
    return next((result for child in node.children if (result:=find(child,tag)) is not None),None)

def text(node):return node if isinstance(node,str) else ''.join(text(c) for c in node.children)
def render(node,origin):
    if isinstance(node,str):return re.sub(r'\s+',' ',node)
    t=node.tag;a=node.attrs
    if t in {'script','style','svg','head','nav','footer','button'} or 'hidden' in a or 'hidden' in a.get('class','').split() or a.get('aria-hidden')=='true':return ''
    if t=='pre':return '\n\n```\n'+text(node).strip('\n')+'\n```\n\n'
    body=''.join(render(c,origin) for c in node.children)
    if t=='a' and a.get('href') and body.strip():
        lines=body.strip().splitlines();first=lines[0];heading=re.match(r'^(#{1,6} )',first);prefix=heading.group(0) if heading else ''
        label=first[len(prefix):].replace('[','\\[').replace(']','\\]');link=prefix+'['+label+']('+urljoin(origin,a['href'])+')'
        return '\n\n'+link+'\n'+'\n'.join(lines[1:])+'\n\n' if len(lines)>1 or heading else link
    if t=='img' and a.get('alt'):return '!['+a['alt'].replace(']','\\]')+']('+urljoin(origin,a.get('src',''))+')'
    if re.fullmatch('h[1-6]',t):return '\n\n'+'#'*int(t[1])+' '+body.strip()+'\n\n'
    if t in {'p','div','section','article','main','header','dl','blockquote','table','tr'}:return '\n\n'+body.strip()+'\n\n'
    if t in {'ul','ol'}:return '\n'+body+'\n'
    if t=='li':return '\n- '+body.strip()+'\n'
    if t in {'td','th'}:return body.strip()+' | '
    if t=='br':return '\n'
    if t=='hr':return '\n\n---\n\n'
    if t in {'strong','b'}:return '**'+body.strip()+'**'
    if t in {'em','i'}:return '*'+body.strip()+'*'
    if t=='code':return '`'+body.strip()+'`'
    return body

config=json.loads(Path('agent-site.json').read_text());dist=Path(config.get('outputDirectory','dist'));origin=config['origin']
for page in dist.rglob('*.html'):
    if page.name=='404.html':continue
    parser=Parser();parser.feed(page.read_text());main=find(parser.root,'main') or find(parser.root,'body')
    if not main:raise ValueError(f'No body in {page}')
    relative=page.relative_to(dist).as_posix();route='/' if relative=='index.html' else '/'+relative.removesuffix('/index.html').removesuffix('.html')
    md=render(main,urljoin(origin,route+'/') if route != '/' else origin+'/');md=re.sub(r'\n[ \t]+','\n',md);md=re.sub(r'\n{3,}','\n\n',md).strip()
    if not md.startswith('# '):
        title=find(parser.root,'title');md='# '+(text(title).strip() if title else config['name'])+'\n\n'+md
    md+='\n\n---\n\nCanonical page: '+urljoin(origin,route)+'\n'
    target=dist/'agent-content'/('index.md' if route=='/' else route.lstrip('/')+'.md');target.parent.mkdir(parents=True,exist_ok=True);target.write_text(md)
    twin=dist/('index.md' if route=='/' else route.lstrip('/')+'.md')
    if not twin.exists():twin.parent.mkdir(parents=True,exist_ok=True);twin.write_text(md)
# Existing themed exports and instructions remain authored; append a dedicated, discoverable guide.
llms=dist/'llms.txt';existing=llms.read_text() if llms.exists() else '# '+config['name']+'\n\n'+config['description']+'\n'
if '## When to use' not in existing:existing+='\n## When to use\n\n'+config['whenToUse']+'\n\n'
existing+='\n## Public site resources\n\n- [Homepage Markdown]('+origin+'/agent-content/index.md)\n- [About]('+origin+'/about/)\n- [Contact]('+origin+'/contact/)\n- [Privacy]('+origin+'/privacy/)\n- [Sitemap]('+origin+'/sitemap.xml)\n'
llms.write_text(existing)
headers=dist/'_headers';body=headers.read_text() if headers.exists() else ''
if '/*.md\n  Content-Type: text/markdown;' not in body:body+='\n/*.md\n  Content-Type: text/markdown; charset=utf-8\n'
body+='\n/llms.txt\n  Content-Type: text/plain; charset=utf-8\n'
headers.write_text(body)
print('Generated page Markdown and agent guide from built HTML')

# Include the new first-party information pages in canonical discovery.
import xml.etree.ElementTree as ET
sitemap=dist/'sitemap.xml'
if sitemap.exists():
    tree=ET.parse(sitemap);node=tree.getroot()
    if node.tag.endswith('urlset'):
        namespace=node.tag.removesuffix('urlset');ET.register_namespace('',namespace.strip('{}')) if namespace else None
        known={e.text for e in node.iter() if e.tag.endswith('loc')}
        for path in ['/about/','/contact/','/privacy/']:
            url=origin+path
            if url not in known:
                entry=ET.SubElement(node,namespace+'url');ET.SubElement(entry,namespace+'loc').text=url
        tree.write(sitemap,encoding='utf-8',xml_declaration=True)
# Keep non-page assets on the static delivery route. phx.tools owns its existing all-route middleware.
if config['origin'] != 'https://phx.tools':
    (dist/'_routes.json').write_text(json.dumps({'version':1,'include':['/*'],'exclude':['/_astro/*','/agent-content/*','/brand/*','/images/*','/fonts/*','/*.md','/*.txt','/*.xml','/*.js','/*.css','/*.png','/*.svg','/*.ico','/*.pdf','/*.woff2','/*.json']})+'\n')
