from io import BytesIO
from lxml import etree
import re


parser = etree.HTMLParser()

empty = re.compile(',\s+\[\s+\]', re.MULTILINE)


def translate_text(html, namespace, spaces):
  context = etree.iterparse(BytesIO(html.strip().encode('utf-8')), events=("start", "end"), html=True)
  indents = 0
  lines = ""

  if namespace and not namespace.endswith('.'):
    namespace += '.'

  for action, elem in context:
    if action == 'start':
      lines += indent('%s%s %s, [\n' % (namespace, elem.tag, elem.attrib), indents)
      indents += spaces
      if elem.text:
        for piece in elem.text.split('\n'):
          lines += put_text(piece, indents)
    elif action == 'end':
      indents -= spaces
      lines += indent(']\n', indents)
      lines += put_text(elem.tail, indents)

  return empty.sub('', lines)


def indent(text, count):
  return ' ' * count + text


def put_text(text, indents):
  lines = ''
  if text and text.strip():
    text = text.replace('\\', '\\\\').replace('"', '\\"')
    lines += indent('"', indents)
    first = True
    for line in text.split('\n'):
      if line.strip():
        if not first:
          lines += '\n'
        else:
          first = False
        lines += line
    lines += '\"\n'
  return lines
