FROM continuumio/miniconda3
LABEL description="Idaho Data Engineers base image" \
      vendor="Idaho Data Engineers" \
      maintainer="Josh Watts, josh.watts@gmail.com"

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    sudo

# install 'gosu' for local user id mapping
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu
    

RUN apt-get clean

RUN mkdir /opt/toolbox/
WORKDIR /opt/toolbox/
COPY bin/ bin/

ENV TERM=vt100 DEBIAN_FRONTEND=teletype
ENTRYPOINT ["/opt/toolbox/bin/entrypoint.sh"]
