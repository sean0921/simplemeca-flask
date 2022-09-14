.PHONY: all build init run clean purge _all _run

SHELL := /usr/bin/env bash
PORT := 5000
NUM_WORKER := 4
ALWAYS_TLS := False

all: init _run

init:
	@poetry install

run: init _run

## skip poetry install procedure
_run:
	@env ALWAYS_TLS=$(ALWAYS_TLS) \
                poetry run gunicorn \
                --chdir simplemeca_flask \
                -w ${NUM_WORKER} --bind 0.0.0.0:$(PORT) \
                run_simplemeca:app

purge: clean
	@poetry env remove python3
