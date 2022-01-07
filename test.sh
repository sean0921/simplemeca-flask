#!/bin/sh

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -d @'payload.json' \
    -L "http://127.0.0.1:5000/simplemeca"
