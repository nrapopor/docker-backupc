# docker-backuppc

## Synopsis

A simple docker container for running Backuppc at the latest version (3.3.1).   

## Description

Backuppc is an unattended backup solution for individulas who need to manage multiple machine    
backups for the 2 "F" (Friends and Family), and for organizations that do not want to spend    
large amounts of money and a lot of effort on backup management tasks.    
I've leveraged a couple of exiting container projetcs (see attributions below).    
The __Migration__ section below will address the migration of the existing backuppc instalation    
to run in this container 

* [backuppc-home](http://backuppc.sourceforge.net/ "http://backuppc.sourceforge.net/")

If you have a current instalation of backuppc with tons of configuration and backed up    
data you would want to be able to migrate to the docker deployement of the backuppc    
without an interuption of your backup schedule. I build this container with specificaly   
this in mind. Once you create your container you would want to merge
 
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
* If the data volume is empty, a new SSH key pair gets generated at startup
* The time zone is set to Americas/New_York
* the msmtp host is set to the eth0 ip address
* the mail domain name is set to 'default.com'
* the backuppc user password is set to 'password'
 

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
* execute `make kill`
  - this will stop a running container 
* execute `make start`
  - this will start a stopped container 
* execute `make clean`
  - this will call `kill` and clean up the default folders
     + **WARNING**: do not run this (or any targets that will trigger this) if you 
       overwrote the `tmp_configpath` and/or `tmp_datapath` with folders 
       that point to the 'real' configuration and/or data folders.
* execute `make build`
  - this will call `clean` and (re)build the container    
    (with default, initially empty, backup and config folders)
* execute  `make run`
  - this will call `build` and `launch` targets    
    (Not safe for 'real' `tmp_configpath` and/or `tmp_datapath`)
* execute  `make launch`
  - This will run a container (without rebuilding it)    
    The purpose of this is when you want to rebuild a container that's pointing to 'real' folders .    
    (this safe for 'real' locations for `tmp_configpath` and/or `tmp_datapath`)     
    Run `make build` pointing to the default `tmp_configpath` and `tmp_datapath`, then overriding the `tmp_configpath` and/or `tmp_datapath` run `make launch`.    
    This will recreate the container but will not wipe out your 'real' directories. 

* execute `make preserve`
  - this make a backup of the default config folders as    
    `backuppc-$containername.<date time>.tar.gz` archive under your id
      + **WARNING**: expects that `make run` was executed and not followed with a `clean`    
      or `build`, `kill` is OK, it does not delete the default folders    
      I would __NOT__ recommend doing this with a multi-terabyte 'real' data folder ...
* execute  `make enter`
  - this will call `start`, then `logs` then open a bash shell in the running container
* execute `make logs`
  - this will show the logs of the running container    
    (expects at least`make run`, `make launch` or `make start` as a prerequisite) 

### Using `docker`

set some variables, for example
>
	DATA=<BackupPC data folder>    
	CONF=<BackupPC configuration folder>    
	PORT=<the local port, ex 8080>    
	CNAME=<container name>    


then run the commands as follows    
>
	sudo docker build -t backuppc:latest .
>
	sudo docker run -d -v $DATA:/var/lib/backuppc:z \
		-v $CONF:/etc/backuppc:z -p $PORT:80 \  
		--name $CNAME backuppc:latest

## Migration

Migration is fairly straight forward. 
* build and launch the image as described above.
* use the `make preserve` target above to backup the default installation folders    
  This task will save the default config and the default data folders to the home    
  folder of the user in a tar.gz format ex `backuppc-backuppctest.20160410-113538.tar.gz`    
  this backup was done for the default container name on April 10th 2016    
* Shutdown backuppc and make a backup of your configuration and data folders    
  (I know it's a pain, since you will need a literal ton of space for the data portion    
  However if anything goes sideways like it tends to do. you'll be happy you did)   
* un-tar (using tar -xvf `name` ) and compare your /etc/backuppc and your /var/lib/backuppc    
  folders with the defaults. You will need to adjust your config to leverage this installation    
  elements like .ssh and .msmtprc in the data folder. 
* stop and start this container pointing to your newly merged configuration and data folders    
  instead of the default temp ones (see instructions for the __Using `docker`__ above


## Notes on this container
This project was created in early 2016 and at this time to get the latest version   
would require either, building from source or leveraging ubuntu:xenial   
I've built this project from source before and would prefer leveraging exiting    
distribution so I've pointed the build to ubuntu:xenial, to be fair if xenial (16.04)    
will turn out to be not as stable as I would like and I may change my mind again and    
just build from source. I hope that since xenial will be the next LTS release I will    
be vindicated in my decision 
            
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

