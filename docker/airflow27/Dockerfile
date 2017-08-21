FROM idahodata/base
LABEL description="Airflow Python 2.7" \
      vendor="Idaho Data Engineers" \
      maintainer="Josh Watts, josh.watts@gmail.com"

RUN apt-get install -y \
    krb5-kdc \
    krb5-admin-server \
    libkrb5-dev \
    libmysqlclient-dev \
    libsasl2-dev \
    libssl-dev \
    python-dev

RUN conda install python=2.7 -y

WORKDIR /opt/toolbox

# COPY incubator-airflow/ /opt/incubator-airflow/
WORKDIR /opt/toolbox/
# RUN pip install -e .[devel] && \
#     pip install tox \
#         psycopg2
COPY docker_cmd.sh bin/

CMD ["/opt/toolbox/bin/docker_cmd.sh"]
