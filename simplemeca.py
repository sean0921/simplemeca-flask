#!/usr/bin/env python3

from flask import Flask, request

def show_hello_world() -> str:
    return('Hello World!')

def print_request_concent(request_json) -> dict:
    return(request_json)

app = Flask(__name__)

@app.route('/hello', methods=['GET', 'POST'])
def hello():
    if request.method == 'POST':
        return print_request_concent(request.json)
    else:
        return show_hello_world()
