.PHONY: all build init run clean purge _all _run

SHELL := /usr/bin/env bash
PYTHON_VERSION := $(shell python3 -c 'import sys;print(f"{sys.version_info[0]}.{sys.version_info[1]}")')

all: init _run

init:
	@sed 's|@PYTHON_VERSION@|$(PYTHON_VERSION)|' Pipfile.tmpl > Pipfile
	@pipenv install

run: init _run

## skip pipenv install procedure
_run:
	@pipenv run gunicorn -w 4 --bind 0.0.0.0:5000 run_simplemeca:app

purge: clean
	@pipenv --rm
