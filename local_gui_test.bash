#!/usr/bin/env bash

ANSI_RED="\033[1;31m"
ANSI_GREEN="\033[1;32m"
ANSI_YELLOW="\033[1;33m"
ANSI_END="\033[0m"

##################### functions

check_value() {
    my_value=$1
    if [[ $my_value == "" ]]; then
        printf "${ANSI_RED}[ERR] Check your payload!${ANSI_END}\n"
        exit 1
    fi
}

check_program() {
    my_program=$1
    if [ -z $(command -v ${my_program}) ]; then
        printf "${ANSI_RED}[ERR] Please Install ${my_program}!${ANSI_END}\n"
    fi
}

##################### main program
#set -eux

check_program bash
check_program curl
check_program zenity
check_program jq

my_shell=$(ps -p $$|awk 'NR>1{print $4}')
if [ $my_shell != bash ]; then
    printf "${ANSI_RED}[ERR] Shell is not correct! ${ANSI_YELLOW}(Should be bash)${ANSI_END}\n"
    exit 1
fi

if [ "$(curl -s -L http://127.0.0.1:5000/simplemeca)" == "Hello World! Welcome to SimpleMeca Service!" ]; then
    printf "${ANSI_GREEN}[INFO] Service is up!${ANSI_END}\n"
else
    printf "${ANSI_RED}[ERR] Please Check Local Service is UP!${ANSI_END}\n"
    exit 1
fi

declare -a form_output
declare -a color_code_rgb

form_output=( $(zenity --forms --title="Create your Payload" \
        --text="Enter information about your payload." \
        --separator=" " \
        --add-entry="Strike" \
        --add-entry="dip" \
        --add-entry="rake" \
        --add-entry="Title") )
case $? in
    0)
        printf "${ANSI_GREEN}[INFO] Payload added.${ANSI_END}\n"
        ;;
    1)
        printf "${ANSI_RED}[ERR] Program interupted.${ANSI_END}\n"
        exit 1
	;;
    -1)
        printf "${ANSI_RED}[ERR] An unexpected error has occurred.${ANSI_END}\n"
        exit 1
	;;
esac

color_code_rgb=$(zenity --color-selection --show-palette)
case $? in
         0)
		printf "${ANSI_GREEN}[INFO] You selected ${ANSI_YELLOW}${color_code_rgb}${ANSI_GREEN}.${ANSI_END}\n"
                ;;
         1)
                printf "${ANSI_YELLOW}[WARN] No color selected.${ANSI_END}\n"
                color_code_rgb="rgb(0,0,0)"
                ;;
        -1)
                printf "${ANSI_RED}[ERR] An unexpected error has occurred.${ANSI_END}\n"
                exit 1
                ;;
esac

strike=${form_output[0]}
dip=${form_output[1]}
rake=${form_output[2]}
title=${form_output[3]}

color_code=( $(echo ${color_code_rgb} | sed -e 's/rgb(//' -e 's/)//' -e 's/,/ /g') )
color_r=${color_code[0]}
color_g=${color_code[1]}
color_b=${color_code[2]}

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
printf "${ANSI_GREEN}[INFO] image URL is: ${ANSI_YELLOW}${image_url}${ANSI_END}\n"

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
