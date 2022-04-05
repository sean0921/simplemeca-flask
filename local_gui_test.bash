#!/usr/bin/env bash

ANSI_RED="\x1b[1;31m"
ANSI_GREEN="\x1b[1;32m"
ANSI_END="\x1b[0m"

##################### functions

check_value() {
    my_value=$1
    if [[ $my_value == "" ]]; then
        printf "${ANSI_RED}Check your payload!${ANSI_END}\n"
        exit 1
    fi
}

check_program() {
    my_program=$1
    if [ -z $(command -v ${my_program}) ]; then
        printf "${ANSI_RED}Please Install ${my_program}!${ANSI_END}\n"
    fi
}

##################### main program
#set -eux

check_program curl
check_program zenity

if [ "$(curl -s -L http://127.0.0.1:5000/simplemeca)" != "Hello World! Welcome to SimpleMeca Service!" ]; then
    printf "${ANSI_RED}Please Check Local Service is UP!${ANSI_END}\n"
    exit 1
else
    printf "${ANSI_GREEN}Service is up!${ANSI_END}\n"
fi

strike="$(  zenity --entry --text="strike"              --title="Create your Payload")"
dip="$(     zenity --entry --text="dip"                 --title="Create your Payload")"
rake="$(    zenity --entry --text="rake"                --title="Create your Payload")"
color_r="$( zenity --entry --text="RGB color: Red"      --title="Create your Payload")"
color_g="$( zenity --entry --text="RGB color: Green"    --title="Create your Payload")"
color_b="$( zenity --entry --text="RGB color: Blue"     --title="Create your Payload")"
title="$(   zenity --entry --text="title"               --title="Create your Payload")"

check_value $strike
check_value $dip
check_value $rake
check_value $color_r
check_value $color_g
check_value $color_b
#check_value $title

cat > payload.json << END
{
    "strike": ${strike},
    "dip": ${dip},
    "rake": ${rake},
    "color_r": ${color_r},
    "color_g": ${color_g},
    "color_b": ${color_b},
    "title": "${title}"
}
END

( cat payload.json | jq -C . ) || ( printf "${ANSI_RED}Check your payload!${ANSI_END}\n" ; exit 1)

image_url_value=$(curl -s \
    -X POST \
    -H 'Content-Type: application/json' \
    -d @'payload.json' \
    -L "http://127.0.0.1:5000/simplemeca" \
    | jq '.image_url') || ( printf "${ANSI_RED}Check your payload!${ANSI_END}\n"; exit 1)

image_url=$(echo ${image_url_value} | tr -d  '"')
echo ${image_url}

if [ $(command -v eog) ]; then
    eog ${image_url}
    exit 0
else
    if [ $(command -v eom) ]; then
        eom ${image_url}
        exit 0
    fi
fi

xdg-open ${image_url}
