FROM debian:bullseye
# env
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# project and workdir
COPY . /work
WORKDIR /work
# install python3 and pipenv
RUN apt-get update \
    &&  apt-get install -y --no-install-recommends \
        python3 python3-pip make gnupg curl ca-certificates gmt-gshhg ghostscript \
    &&  ( curl -fsSL https://www.clam.ml/gpg-pubkey/sean.gpg | gpg --dearmor -o  /usr/share/keyrings/sean-test-keyring.gpg ) \
    &&  ( echo 'deb [signed-by=/usr/share/keyrings/sean-test-keyring.gpg] https://raw.githubusercontent.com/sean0921/seanrepo/master/bullseye ./' | tee /etc/apt/sources.list.d/seanrepo.list ) \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       gmt libgmt-dev gmt-dcw pipenv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# project setting
RUN make init
EXPOSE 5000
CMD make _run
