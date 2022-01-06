#!/bin/sh

curl \
    -X POST \
    -H 'Content-Type: application/json' \
    -d '{"login":"my_login","password":"my_password"}' \
    -L "http://127.0.0.1:5000/hello"
