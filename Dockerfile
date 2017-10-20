FROM continuumio/miniconda3
LABEL description="Idaho Data Engineers toolbox" \
      vendor="Idaho Data Engineers" \
      maintainer="Josh Watts, josh.watts@gmail.com"

ENV TERM=vt100 DEBIAN_FRONTEND=noninteractive

RUN apt-get update >/dev/null 2>&1 && \
    apt-get install -y \
    build-essential \
    sudo \
    nano

# install 'gosu' for local user id mapping
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# prep Docker install
RUN  apt-get install -y \
             apt-transport-https \
             ca-certificates \
             software-properties-common && \
     curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
     apt-key fingerprint 0EBFCD88

# add Docker repository
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable edge"

# install Docker
RUN apt-get update >/dev/null 2>&1 && \
    apt-get install -y docker-ce wget && \
    pip install docker-compose

RUN mkdir /opt/toolbox/
WORKDIR /opt/toolbox/

# install Python packages
COPY requirements.txt .
RUN pip install -r requirements.txt

# clean-up 
RUN apt-get clean

# COPY assets/LS_COLORS /home/docker/.dircolors

# ENV USER docker
# ENV SHELL /bin/bash
# ENV EDITOR /usr/bin/nano
ENV TERM=vt100 DEBIAN_FRONTEND=teletype USER=docker SHELL=/bin/bash
ENTRYPOINT ["/opt/toolbox/bin/entrypoint.sh"]
