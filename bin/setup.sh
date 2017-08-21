#!/usr/bin/env bash

# create 'toolbox' virtual env
CMD="conda create --name toolbox python=3.6 -y"
echo "* creating 'toolbox' virtual env"
$CMD

# instantiate 'toolbox' virtual env
CMD="source activate toolbox"
echo "* activating 'toolbox' env"
$CMD

CMD="pip install -r requirements.txt"
echo "* installing Python packages"
$CMD
