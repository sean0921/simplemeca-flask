#!/usr/bin/env python3

from typing import Dict, Any
from flask import Flask, request, redirect, url_for
from flask_cors import CORS
from pathlib import Path
import pygmt
import os
import hashlib
import json

# ref: https://www.doc.ic.ac.uk/~nuric/coding/how-to-hash-a-dictionary-in-python.html
def dict_hash(dictionary: Dict[str, Any]) -> str:
    """SHA256 hash of a dictionary."""
    dhash = hashlib.sha256()
    # We need to sort arguments so {'a': 1, 'b': 2} is
    # the same as {'b': 2, 'a': 1}
    encoded = json.dumps(dictionary, sort_keys=True).encode()
    dhash.update(encoded)
    return dhash.hexdigest()

def show_hello_world() -> str:
    return('Hello World! Welcome to SimpleMeca Service!\n')

def pygmt_simplemeca(
        fig_input: pygmt.figure.Figure,
        strike=270,
        dip=90,
        rake=0,
        color_r=0,
        color_g=0,
        color_b=0,
        title=''
    ) -> pygmt.figure.Figure:
    pygmt.config(MAP_TITLE_OFFSET='0p')
    fig_input.basemap(
        region=[-1, 1, -1, 0.73],
        projection="M6c",
        frame=[f'+n+t"{title}"']
    )
    focal_mechanism = dict(strike=strike, dip=dip, rake=rake, magnitude=3.5)
    fig_input.meca(focal_mechanism, scale="6c", longitude=0, latitude=0, depth=0, G=f'{color_r}/{color_g}/{color_b}')
    fig_input.text(x=0, y=0, text=f'{strike}/{dip}/{rake}', offset='0/-2.5',font='8p')
    return(fig_input)

def test_pygmt(expected_result_uri: str, this_payload: dict):
    current_dir = os.getcwd()
    fig = pygmt.Figure()
    fig = pygmt_simplemeca(
        fig,
        strike  = int(this_payload['strike']),
        dip     = int(this_payload['dip']),
        rake    = int(this_payload['rake']),
        color_r = this_payload['color_r'],
        color_g = this_payload['color_g'],
        color_b = this_payload['color_b'],
        title   = this_payload['title'],
    )
    fig.savefig(current_dir + '/' + expected_result_uri, dpi=150)

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return redirect("https://github.com/sean0921/simplemeca-flask", code=302)

@app.route('/simplemeca', methods=['GET', 'POST'])
def simplemeca():
    return redirect(url_for('simplemeca_v1'), code=307)

@app.route('/v1/simplemeca', methods=['GET', 'POST'])
def simplemeca_v1():
    if request.method == 'POST':
        this_payload = request.json
        print(this_payload)
        fig_filename = dict_hash(this_payload)
        result_uri = f'static/{fig_filename}.png'
        result_url = request.url_root + result_uri
        if not Path(result_uri).is_file():
            print(f'Creating: {result_uri}....',end=' ')
            test_pygmt(result_uri, this_payload)
            print(f'OK!')
        else:
            print('image exists, skip!')
        if os.getenv('ALWAYS_TLS') == 'True':
            result_data={ 'image_url': result_url.replace('http://', 'https://', 1) }
        else:
            result_data={ 'image_url': result_url }
        print(result_data)
        return result_data
    else:
        return show_hello_world()
