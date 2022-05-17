#!/usr/bin/env bash

read -r ANSI_RED < <(printf "\033[1;31m")
read -r ANSI_GREEN < <(printf "\033[1;32m")
read -r ANSI_YELLOW < <(printf "\033[1;33m")
read -r ANSI_END < <(printf "\033[0m")
trap ctrl_c INT

##################### functions

check_exit() {
    exit_status=$1
    if [ "${exit_status}" = "0" ]; then
        printf "%s[INFO] Program normally terminated!%s\n" "${ANSI_GREEN}" "${ANSI_END}"
    else
        printf "%s[WARN] Program unnormally terminated! (exit code: %d)%s\n" "${ANSI_YELLOW}" "${exit_status}" "${ANSI_END}"
    fi
    exit "${exit_status}"
}

function ctrl_c()
{
    printf "%s[WARN] CTRL+C received, exit!%s\n" "${ANSI_YELLOW}" "${ANSI_END}"
    check_exit 0
}

check_program() {
    my_program=$1
    if [ -z "$(command -v "${my_program}")" ]; then
        printf "%s[ERR] Please Install ${my_program}!%s\n" "${ANSI_RED}" "${ANSI_END}"
        check_exit 1
    fi
}

check_value() {
    my_value=$1
    if [[ $my_value == "" ]]; then
        printf "%s[ERR] Check your payload!%s\n" "${ANSI_RED}" "${ANSI_END}"
        check_exit 1
    fi
}


##################### main program
#set -eux

check_program bash
check_program python3
check_program curl
check_program zenity
check_program jq

my_shell=$(ps -p $$|awk 'NR>1{print $4}')
if [ "${my_shell}" != bash ]; then
    printf "%s[ERR] Shell is not correct! %s(Should be bash)%s\n" "${ANSI_RED}" "${ANSI_YELLOW}" "${ANSI_END}"
    check_exit 1
fi

declare -a form_output

IFS=" " read -r -a form_output <<< "$(zenity --forms --title='Type your Beachball Info' \
        --text='Enter information about your beachball.' \
        --separator=" " \
        --add-entry='Strike' \
        --add-entry='dip' \
        --add-entry='rake' \
        --add-entry='Title')"

case $? in
    0)
        printf "%s[INFO] Payload added.%s\n" "${ANSI_GREEN}" "${ANSI_END}"
        ;;
    1)
        printf "%s[ERR] Program interupted.%s\n" "${ANSI_RED}" "${ANSI_END}"
        check_exit 1
	;;
    -1)
        printf "%s[ERR] An unexpected error has occurred.%s\n" "${ANSI_RED}" "${ANSI_END}"
        check_exit 1
	;;
esac

color_code_rgb=$(zenity --color-selection --show-palette --title='Choose Your Beachball Color')
case $? in
         0)
		printf "%s[INFO] You selected %s%s%s.%s\n" "${ANSI_GREEN}" "${ANSI_YELLOW}" "${color_code_rgb}" "${ANSI_GREEN}" "${ANSI_END}"
                ;;
         1)
                printf "%s[WARN] No color selected.%s\n" "${ANSI_YELLOW}" "${ANSI_END}"
                color_code_rgb="rgb(0,0,0)"
                ;;
        -1)
                printf "%s[ERR] An unexpected error has occurred.%s\n" "${ANSI_RED}" "${ANSI_END}"
                color_code_rgb="rgb(0,0,0)"
                check_exit 1
                ;;
esac

strike=${form_output[0]}
dip=${form_output[1]}
rake=${form_output[2]}
title=${form_output[3]}

IFS=" " read -r -a color_code <<< "$(echo ${color_code_rgb} | sed -e 's/rgb(//' -e 's/)//' -e 's/,/ /g')"
color_r=${color_code[0]}
color_g=${color_code[1]}
color_b=${color_code[2]}

check_value "${strike}"
check_value "${dip}"
check_value "${rake}"
check_value "${color_r}"
check_value "${color_g}"
check_value "${color_b}"
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

( jq -C . payload.json ) || ( "%s[ERR] Check your payload!%s\n" "${ANSI_RED}" "${ANSI_END}" ; check_exit 1)

if [ "$(curl -s -L http://127.0.0.1:5000/simplemeca)" == "Hello World! Welcome to SimpleMeca Service!" ]; then
    printf "%s[INFO] Service is available!%s\n" "${ANSI_GREEN}" "${ANSI_END}"
else
    printf "%s[ERR] Please Check Local Service is UP!%s\n" "${ANSI_RED}" "${ANSI_END}"
    check_exit 1
fi

image_url_value=$(curl -s \
    -X POST \
    -H 'Content-Type: application/json' \
    -d @'payload.json' \
    -L "http://127.0.0.1:5000/simplemeca" \
    | jq '.image_url') || ( printf "%s[ERR] Check your payload!%s\n" "${ANSI_RED}" "${ANSI_END}"; check_exit 1)

image_url=$(echo "${image_url_value}" | tr -d  '"')
printf "%s[INFO] image URL is: %s%s$%s\n" "${ANSI_GREEN}" "${ANSI_YELLOW}" "${image_url}" "${ANSI_END}"

if [ "$(command -v eog)" ]; then
    eog -n "${image_url}"
    check_exit 0
else
    if [ "$(command -v eom)" ]; then
        eom "${image_url}"
        check_exit 0
    fi
fi

xdg-open "${image_url}"

# shutdown test server
check_exit 0
