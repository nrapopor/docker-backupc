# docker-backuppc

## Synopsis

A simple docker container for running Backuppc.

## Description

* This container installs BackupPC from Ubuntu Xenial sources.
  - On startup it checks if the provided volumes for data and configuration are empty and
    if yes, move the configuration from packaging into it
* Support for sending status mail using msmtp

### Default settings

* No authentication
* SSH host key checking **disabled**
* If the data volume is empty, a new SSH keypair gets generated at startup


### Volumes

* ``/var/lib/backuppc``: Persistent data for backuppc, including ssh key
* ``/etc/backuppc``: Configuration for backuppc

### Ports

* ``80``: Web interface for BackupPC 

## How to use

* change the smtp host in msmtprc
* change backuppc htaccess password in Dockerfile line 19
* cd into the directory then use either the `make` or `docker` instructions
* build at least once ...

### Using `make`

you can override the default name of the container $containername 
 (backuppctest) prior to launching the container
ex. `containername=BOB; make run`

* execute `make`
  - this will list the available targets and variables that can be overwritten
* execute `make stop`
  - this will stop a running container and clean up the default folders
* execute `make clean`
  - this will call stop running container and clean up the default folders
* execute `make build`
  - this will call clean and (re)build the container 
    (with default, empty backup and config folders)
* execute  `make run`
  - this will call build and launch the container 
    (with default, empty backup and config folders)
* execute `make preserve`
  - this make a backup of the default config folders as 
    `backuppc-$containername.<date time>.tar.gz` archive under your id
    (expects at least`make run` as a prerequisite ) 
* execute  `make enter`
  - this will call run
  - list out the logs
  - open a bash shell in the running container
* execute `make logs`
  - this will show the logs of the running container 
    (expects at least`make run` as a prerequisite ) 

### using docker

set some variables ...

1. DATA=`<BackupPC data folder>`
2. CONF=`<BackupPC configuration folder>`
3. PORT=`<the local port, ex 8080>`
4. CNAME=`<container name>`

`sudo docker run -d -v $DATA:/var/lib/backuppc:z 
 -v $CONF:/etc/backuppc:z  -p $PORT:80 
 --name $CNAME nrapopor/backuppc:latest`

## Author and Legal information

### Author

Nick Rapoport

### Copyright

Copyright&copy;  2016 Nick Rapoport -- All rights reserved (free 
for duplication under the AGPLv3)

### License

AGPLv3

## Based On 

#### Date
2016-03-28

#### Projects
- [alvaroaleman/docker-backuppc](https://github.com/alvaroaleman/docker-backuppc/ "https://github.com/alvaroaleman/docker-backuppc")
- [ktwe/docker-backuppc](https://github.com/ktwe/docker-backuppc/ "https://github.com/ktwe/docker-backuppc/")
