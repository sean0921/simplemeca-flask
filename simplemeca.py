#!/usr/bin/env python3

from flask import Flask, request
import pygmt
import os

def show_hello_world() -> str:
    return('Hello World! Welcome to SimpleMeca Service!\n')

#def print_request_concent(request_json) -> dict:
#    return(request_json)

def pygmt_simplemeca(fig_input,strike=270,dip=90,rake=0,color_r=0,color_g=0,color_b=0,title='Simple Focal Mechanism'):
    fig_input.basemap(
        region=[-1, 1, -1, 1], 
        projection="M6c",
        frame=[f'+n+t"{title}"']
    )
    focal_mechanism = dict(strike=strike, dip=dip, rake=rake, magnitude=3)
    fig_input.meca(focal_mechanism, scale="6c", longitude=0, latitude=0, depth=0, G=f'{color_r}/{color_g}/{color_b}')
    fig_input.text(x=0, y=0, text=f'{strike}/{dip}/{rake}', offset='0/-2.5',font='8p')
    return(fig_input)

def test_pygmt(expected_result_uri):
    current_dir = os.getcwd()
    fig = pygmt.Figure()
    fig = pygmt_simplemeca(fig)
    fig.savefig(current_dir + expected_result_uri)

app = Flask(__name__)

@app.route('/hello', methods=['GET', 'POST'])

def hello():
    if request.method == 'POST':
        this_payload = request.json
        result_uri = '/static/fig.png'
        result_url = request.url_root + result_uri
        test_pygmt(result_uri)
        return result_url
    else:
        return show_hello_world()
