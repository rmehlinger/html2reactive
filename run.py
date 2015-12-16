import os

from server.server import app
if __name__ == "__main__":
    app.run(debug=False, port=os.environ.get('PORT', 33507))
