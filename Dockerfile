FROM debian:bookworm
# env
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# project and workdir
COPY . /work
WORKDIR /work
# install python3 and pipenv
RUN apt-get update \
    &&  apt-get install -y --no-install-recommends \
        python3 python3-pip python3-importlib-metadata \
        ca-certificates gmt-gshhg ghostscript gmt libgmt-dev gmt-dcw \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip micropipenv \
    && micropipenv install
CMD gunicorn -w 4 --bind 0.0.0.0:$PORT run_simplemeca:app
