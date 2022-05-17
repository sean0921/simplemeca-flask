.PHONY: all build init run clean purge _all _run

SHELL := /usr/bin/env bash
PORT := 5000
ALWAYS_TLS := False

all: init _run

init:
	@poetry install

run: init _run

test: init _test

## skip poetry install procedure
_run:
	@env ALWAYS_TLS=$(ALWAYS_TLS) \
                poetry run gunicorn \
                --chdir simplemeca_flask \
                -w 4 --bind 0.0.0.0:$(PORT) \
                run_simplemeca:app

_test:
	@cd test && bash local_gui_test.bash

purge: clean
	@poetry env remove python3
