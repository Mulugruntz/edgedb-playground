FROM python:3.8.1
MAINTAINER mulugruntz@gmail.com

ARG user=playground
ARG group=playground
ARG uid=1000
ARG gid=1000
ARG PLAYGROUND_HOME=/var/playground_home

RUN echo 1

RUN mkdir -p $PLAYGROUND_HOME \
  && chown ${uid}:${gid} $PLAYGROUND_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$PLAYGROUND_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN apt-get update && apt-get install -y wget

WORKDIR /opt/app
RUN /usr/bin/env python -m pip install --upgrade pipenv
RUN /usr/bin/env python -m pip install pipenv==2018.11.26

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

USER ${uid}

RUN python --version \
    && python -m pip --version \
    && python -m pipenv --version

COPY . /app

WORKDIR /app

RUN pipenv install

CMD dockerize -wait tcp://edgedb:5656 -wait-retry-interval 10s -timeout 90s && pipenv run python /app/connection.py


