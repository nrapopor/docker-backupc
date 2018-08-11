FROM ubuntu:latest
MAINTAINER nrapopor@hotmail.com

ENV TMP_CONFIG /backuppc_initial_config
ENV TMP_DATA /backuppc_initial_data
ENV PERSISTENT_CONFIG /etc/backuppc
ENV PERSISTENT_DATA /var/lib/backuppc
ENV STARTSCRIPT /usr/local/bin/dockerstart.sh
ENV DEFAULTS /root/preseed.conf
ENV OVERRIDES /root/overrides.sh

ADD startscript.sh $STARTSCRIPT
ADD msmtprc $TMP_DATA/.msmtprc
# This is used for the package install of supervisor
#ADD supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# This is used for the direct install of supervisor (like with pip)
ADD supervisord.conf /etc/supervisord.conf
ADD preseed.conf $DEFAULTS
ADD overrides.sh $OVERRIDES

RUN apt-get update && \
    # load the overrides
    . $OVERRIDES && \

    # Populate the domain name in the debconf selections
    sed -i "s/default\.com/${DOMAIN_NAME}/g" $DEFAULTS && \
    cat $DEFAULTS && \

    # Set the default answers for installations of the BackupPC, postfix, etc
    debconf-set-selections $DEFAULTS && \

    # start the instalations
    apt-get -y install apt-utils debconf-utils systemd-services vim par2 && \
    apt-get -y upgrade && \
    apt-get -y install perl cpanminus python python-setuptools python-pip msmtp && \

    # get the required perl modules for BackupPC
    cpanm -n Archive::Zip Compress::Zlib File::Listing File::RsyncP XML::RSS CGI && \
    
    # this is a better way of installing the supervisor then from the distro
    pip install supervisor && \
    
    apt-get install -y backuppc rsync apache2-utils && \

    # Clean Up
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /root/.cpan/build/*         \
       /root/.cpan/sources/authors/id  \
       /root/.cpan/cpan_sqlite_log.*   \
       /tmp/cpan_install_*.txt && \
    rm -rf /var/lib/apt/lists/* && \
 

    # set the timezone
    echo LOCAL_ZONE=$LOCAL_ZONE  && \
    echo $LOCAL_ZONE > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/$LOCAL_ZONE /etc/localtime && \

    # Configure package config to a temporary folder to be able to restore it when no config is present
    mkdir -p $TMP_CONFIG $TMP_DATA/.ssh && \
    mv $PERSISTENT_CONFIG/* $TMP_CONFIG && \
    mv $PERSISTENT_DATA/* $TMP_DATA && \

    # Disable ssh host key checking per default
    echo "host *"                       >> $TMP_DATA/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> $TMP_DATA/.ssh/config && \

    # Set the password for backuppc user
    echo BACKUPPC_PASSWORD=$BACKUPPC_PASSWORD && \
    htpasswd -b $TMP_CONFIG/htpasswd backuppc $BACKUPPC_PASSWORD && \

    # Disable basic auth for package generated config
    sed -i 's/Auth.*//g' $TMP_CONFIG/apache.conf && \
    sed -i 's/require valid-user//g'  $TMP_CONFIG/apache.conf && \

    # Display Backuppc on / rather than /backuppc
    sed -i 's/Alias \/backuppc/Alias \//' $TMP_CONFIG/apache.conf && \
    
    # This is required to load images on /
    sed -i "s/^\$Conf{CgiImageDirURL} =.*/\$Conf{CgiImageDirURL} = '\/image';/g" $TMP_CONFIG/config.pl && \
    
    # This is required for use of msmtp instead of sendmail
    sed -i 's/\/usr\/sbin\/sendmail/\/usr\/bin\/msmtp/g' $TMP_CONFIG/config.pl && \

    # Remove host 'localhost' from package generated config
    sed -i 's/^localhost.*//g' $TMP_CONFIG/hosts && \

    # Fix the invalid iownership and permissions on index.cgi
    chown backuppc.www-data /usr/lib/backuppc/cgi-bin/index.cgi && \
    chmod u+s /usr/share/backuppc/cgi-bin/index.cgi && \

    # Fix the mutex apache bug -- this caused intetmittent issues that took me forever to diagnose
    APACHE_MUTEX_FNCNTL=$(apache2ctl -t -D DUMP_RUN_CFG 2>/dev/null | grep "Mutex default" | grep mechanism=fcntl | wc
 95 -l) && \
    [[ "${APACHE_MUTEX_FNCNTL} == "1" ]] && sed -i 's/^Mutex file/#Mutex file/g /etc/apache2/apache2.conf


    # Make startscript executable
    chmod ugo+x $STARTSCRIPT


EXPOSE 80
VOLUME [ "$PERSISTENT_DATA", "$PERSISTENT_CONFIG" ]

cmd $STARTSCRIPT
