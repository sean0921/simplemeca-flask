#!/usr/bin/env python3

from flask import Flask, request
import pygmt
import os
import uuid
from flask_cors import CORS

def show_hello_world() -> str:
    return('Hello World! Welcome to SimpleMeca Service!\n')

def pygmt_simplemeca(fig_input, strike=270, dip=90, rake=0, color_r=0, color_g=0, color_b=0, title='Simple Focal Mechanism'):
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

def test_pygmt(expected_result_uri, this_payload):
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

@app.route('/simplemeca', methods=['GET', 'POST'])

def simplemeca():
    if request.method == 'POST':
        this_payload = request.json
        print(this_payload)
        fig_filename = str(uuid.uuid4())
        result_uri = f'static/{fig_filename}.png'
        result_url = request.url_root + result_uri
        test_pygmt(result_uri, this_payload)
        if os.getenv('ALWAYS_TLS') == 'True':
            result_data={ 'image_url': result_url.replace('http://', 'https://', 1) }
        result_data={ 'image_url': result_url }
        print(result_data)
        return result_data
    else:
        return show_hello_world()
