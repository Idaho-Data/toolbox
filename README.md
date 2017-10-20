# toolbox
Toolbox is a development container you can customize to publish solid,
stable development environments for software and systems
engineers. Based on the `continuumio/miniconda3` image, it's the
Docker equivalent to `virtualenv`.

## Umm... why?
We always deploy and consider the data scientist or engineer's
workstation the single most important deployment in a project.  This
lets us publish consistent, stable development environments for data
scientists and engineers that we can throw away and rebuild due to
personal preferences or requirement changes.


## Nuts and Bolts
### `Dockerfile` - container definition file
Installs container system packages, Docker, and Python libraries. This
is where you would install a database, web server, or build tools.

### `bin/entrypoint.sh` - container's executable
Runtime configuration. This is where you would install project
dependencies and shell configuration i.e. Python libraries, bash
settings, shell scripts

### `bin/build.sh` - builds and runs the container
#### I don't want to run the container on my workstation
All you need is `docker build -t idahodata/toolbox .`

#### I would love to run the container on my workstation
The following files are mapped inside your Toolbox container:

workstation | container
--- | ---
`$HOME/.gitconfig` | `/home/docker/.gitconfig`
`$HOME/.ssh` | `/home/docker/.ssh`
`/var/run/docker.sock` | `/var/run/docker.sock`

The first are required so git works properly inside Toolbox.

Mapping `/var/run/docker.sock` lets us control the workstation's
Docker host inside the container so we can build and use other
containers. A future feature will have a local DNS server so we can
use fully-qualified domain names in development which, at the least,
makes managing development HTTPS certificates much easier.

## Howto

We use Toolbox for [vcardz](https://github.com/IdahoDataEngineers/vcardz "Python3 vCard parser and deduplication") development.

1. clone Toolbox and create branch for your project
```bash
git clone git@github.com:IdahoDataEngineers/toolbox.git
cd toolbox
git checkout -b vcardz
```

1. clone your project
```bash
git checkout git@github.com:IdahoDataEngineers/vcardz.git
```

1. customize Toolbox 
We modified `bin/entrypoint.sh` to install `vcardz` as an editable Python library
```
43: # install vcardz Python module
44: pip install -e vcardz/
```

1. Run the container
```bash
bin/build.sh
```

and you'll see
```
✔  [docker@toolbox]  [vcardz|✔]
18:46 $
```








