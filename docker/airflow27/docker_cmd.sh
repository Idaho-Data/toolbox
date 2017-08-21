#!/bin/bash

pushd /opt/incubator-airflow/
pip install -e .[devel] && \
    pip install tox \
        psycopg2 \
        unicodecsv \
        hive

pip wheel -w /home/docker/.wheelhouse -f /home/docker/.wheelhouse -r scripts/ci/requirements.txt
pip install --find-links=/home/docker/.wheelhouse --no-index -r scripts/ci/requirements.txt
popd

