from contextlib import suppress
import docker
import os
from os.path import (dirname,
                     join,
                     abspath)
import re
from shovel import task
import shutil
import subprocess
import sys


def create(dockerpath, label):
    print('* Dockerfile => {}'.format(dockerpath))
    cmd = 'docker build --force-rm --tag {label} {dockerpath}'.format(dockerpath=dockerpath,
                                                                      label=label)
    cmd = re.sub('\s+', ' ', cmd)
    print('* docker => ' + cmd)
    subprocess.run(cmd.split(' '),
                   stdin=sys.stdin,
                   stdout=sys.stdout,
                   stderr=sys.stderr)


def copy(src, target):
    cleanpath = lambda x: abspath(join(dirname(__file__), x))
    src = cleanpath(src)
    target = cleanpath(target)
    with suppress(Exception):
        shutil.rmtree(target)
    shutil.copytree(src, target, symlinks=True)

@task
def all():
    base()
    airflow27()


@task
def airflow27():
    # copy('../../incubator-airflow/', '../docker/airflow27/incubator-airflow')
    create(dockerpath='docker/airflow27/', label='idahodata/airflow27')

@task
def base():
    copy('../bin/', '../docker/base/bin/')
    create(dockerpath='docker/base/', label='idahodata/base')

@task
def monica():
    """
    IDE Monica build
    """
    create(dockerpath='monica', label='idahodata/monica')
    
