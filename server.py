from flask import Flask, request, jsonify
from html2reactive import translate_text

app = Flask(__name__, static_url_path="/static")
app.config.from_pyfile('config.py')


@app.route('/')
def _index():
  return app.send_static_file('index.html')


@app.route('/translate', methods=['POST'])
def _translate():
  html = request.get_json().get('html', "")
  namespace = request.get_json().get("namespace", "R")
  spaces = request.get_json().get("spaces", 2)

  return jsonify(rc=translate_text(html, namespace, spaces))

app.run()
