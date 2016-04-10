# docker-backuppc

## Synopsis

A simple docker container for running Backuppc.

## Description

* This container installs BackupPC from Ubuntu Xenial sources.
  - On startup it checks if the provided volumes for data and configuration are     
    empty and if yes, move the default configuration from packaging into it
* Several configuration values like the expected container timezone    
  have been placed into the **overrides.sh** look at the __Customization__ section below
* Support for sending status mail using msmtp
  - the image ip address of eth0 will be used for host line in the msmtprc    
    if a different behavior is desired replace the value for the LOCAL_ADDR in    
    the **overrides.sh**

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

### Customization 

* change backuppc htaccess **password** in the **overrides.sh**    
  the line reads `export BACKUPPC_PASSWORD=password`    
  replace the `password` with an actual password you want to use
* change local timezone (if needed) in the **overrides.sh**    
  the line reads `export LOCAL_ZONE=America/New_York`    
* Please modify the default domain in the **overrides.sh** file    
  replace the ***default.com*** with a real domain name    
  the line reads `export DOMAIN_NAME=default.com`    
* Use either the `make` or `docker` instructions below    
  **Note:** build at least once using one of the options below ...

### Using `make`

You can override the default name of the container, **$containername**    
(**backuppctest**) prior to launching the container    
for example: `containername=BOB; make run`

* execute `make`
  - this will list the available targets and variables that can be overwritten
* execute `make stop`
  - this will stop a running container and clean up the default folders
* execute `make clean`
  - this will call kill and clean up the default folders
     + **WARNING**: do not run this (or any targets that will trigger this) if you     
       overwrote the `tmp_configpath` and/or `tmp_datapath` with folders    
       that point to the 'real' configuration and/or data folders.    
* execute `make build`
  - this will call clean and (re)build the container    
    (with default, initially empty, empty backup and config folders)
* execute  `make run`
  - this will call build and launch the container 
    (with default, empty backup and config folders)
* execute `make preserve`
  - this make a backup of the default config folders as    
    `backuppc-$containername.<date time>.tar.gz` archive under your id
      + **WARNING**: expects that `make run` was executed and not followed with a `clean`    
      or `build`, `kill` is OK, it does not delete the default folders    
      I would __NOT__ recommend doing this with a multi-terabyte 'real' data folder ...
* execute  `make enter`
  - this will call `run`    
  list out the logs    
  open a bash shell in the running container
* execute `make logs`
  - this will show the logs of the running container    
    (expects at least`make run` as a prerequisite ) 

### Using `docker`

set some variables, for example
>
	DATA=<BackupPC data folder>
	CONF=<BackupPC configuration folder>    
	PORT=<the local port, ex 8080>   
	CNAME=<container name>


then run the command as follows   
>
	sudo docker run -d -v $DATA:/var/lib/backuppc:z \
		-v $CONF:/etc/backuppc:z -p $PORT:80 \  
		--name $CNAME backuppc:latest
            
## Author and Legal information

### Author

Nick Rapoport

### Copyright

Copyright&copy;  2016 Nick Rapoport -- All rights reserved (free 
for duplication under the AGPLv3)

### License

AGPLv3

## Based On 

#### Projects
- [alvaroaleman/docker-backuppc](https://github.com/alvaroaleman/docker-backuppc/ "https://github.com/alvaroaleman/docker-backuppc")
- [ktwe/docker-backuppc](https://github.com/ktwe/docker-backuppc/ "https://github.com/ktwe/docker-backuppc/")

#### Date
2016-03-28

