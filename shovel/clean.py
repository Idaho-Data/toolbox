from contextlib import suppress
import docker
import os
import re
import pprint
from shovel import task
import subprocess
import sys


@task
def all():
    run()
    images()


@task
def run():
    client = docker.from_env()
    all_containers = client.containers.list(all=True)
    for container in all_containers:
        if container.name == 'toolbox':
            continue
        print('~~~ removing ' + container.name)
        container.remove(force=True)


@task
def images(name=None):
    client = docker.from_env()
    all_images = client.images.list(all=True)
    for image in all_images:
        if image.tags and \
           image.tags[0].split(':')[0] in ('continuumio/miniconda3',
                                           'postgres',
                                           'ruudud/devdns',
                                           'idahodata/toolbox'):
                continue

        print('* removing image {}:{}'.format(image.short_id,
                                              str(image.tags)))
        with suppress(Exception):
            client.images.remove(image=image.short_id, force=True)
