.PHONY: all build init run clean purge _all _run

SHELL := /usr/bin/env bash
PYTHON_VERSION := $(shell python3 -c 'import sys;print(f"{sys.version_info[0]}.{sys.version_info[1]}")')
PORT := 5000
ALWAYS_TLS := False

all: init _run

init:
	@sed 's|@PYTHON_VERSION@|$(PYTHON_VERSION)|' Pipfile.tmpl > Pipfile
	@pipenv install

run: init _run

test: init _test

## skip pipenv install procedure
_run:
	@env ALWAYS_TLS=$(ALWAYS_TLS) pipenv run gunicorn -w 4 --bind 0.0.0.0:$(PORT) run_simplemeca:app

_test:
	@bash local_gui_test.bash

purge: clean
	@pipenv --rm
