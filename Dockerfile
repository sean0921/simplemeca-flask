FROM debian:trixie
# env
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# project and workdir
COPY . /work
WORKDIR /work
# install python3 and poetry-core
RUN apt-get update \
    && apt-get full-upgrade -y \
    && apt-get install -y --no-install-recommends \
       python3 python3-pip python3-importlib-metadata python3-venv \
       ca-certificates ghostscript gmt libgmt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv /work/.venv \
    && . /work/.venv/bin/activate \
    && pip install --upgrade pip poetry_core setuptools \
    && pip install .
CMD . /work/.venv/bin/activate \
    && gunicorn --chdir simplemeca_flask -w ${NUM_WORKER} --bind 0.0.0.0:${PORT} run_simplemeca:app
