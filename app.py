"""Doc"""
from flask import Flask
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from waitress import serve

app = Flask(__name__)


@app.route("/")
def hello():
    """Doc"""

    return {"aze": 1}


if __name__ == "__main__":
    serve(app, host="0.0.0.0", port=5000)
