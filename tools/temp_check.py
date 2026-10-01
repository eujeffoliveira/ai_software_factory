import urllib.request, re, json
req = urllib.request.Request('https://github.com/eujeffoliveira/ai_software_factory', headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req) as resp:
    html = resp.read().decode('utf-8', errors='ignore')
for m in re.finditer(r'contributors', html, re.I):
    start = max(0, m.start() - 100)
    end = min(len(html), m.end() + 100)
    print('--- MATCH ---')
    print(html[start:end])
