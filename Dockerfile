FROM ubuntu:xenial
MAINTAINER nrapopor@hotmail.com

ENV TMP_CONFIG /backuppc_initial_config
ENV TMP_DATA /backuppc_initial_data
ENV PERSISTENT_CONFIG /etc/backuppc
ENV PERSISTENT_DATA /var/lib/backuppc
ENV STARTSCRIPT /usr/local/bin/dockerstart.sh

ADD startscript.sh $STARTSCRIPT
ADD msmtprc $TMP_DATA/.msmtprc
# This is used for the package install of supervisor
#ADD supervisor.conf /etc/supervisor/conf.d/supervisord.conf

# This is used for the direct install of supervisor (like with pip)
ADD supervisord.conf /etc/supervisord.conf



RUN apt-get update && \
    # Set the default answers for installations of the BackupPC, postfix, etc
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    echo 'postfix postfix/mailname string nrapoport.com' | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type select 'Local only'" | debconf-set-selections && \
    echo 'backuppc backuppc/configuration-note note' | debconf-set-selections && \
    echo 'backuppc backuppc/restart-webserver boolean true' | debconf-set-selections && \
    echo 'backuppc backuppc/reconfigure-webserver multiselect apache2' | debconf-set-selections && \

    # start the instalations
    apt-get -y install apt-utils debconf-utils && \
    apt-get -y upgrade && \
    apt-get -y install perl cpanminus  python python-setuptools python-pip msmtp && \

    # get the required perl modules for BackupPC
    cpanm -n Archive::Zip Compress::Zlib File::Listing File::RsyncP XML::RSS && \
    
    # this is a better way of installing the supervisor then from the distro
    pip install supervisor && \
    
    apt-get install -y backuppc apache2-utils && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf .cpan/build/*         \
       .cpan/sources/authors/id  \
       .cpan/cpan_sqlite_log.*   \
       /tmp/cpan_install_*.txt && \
    rm -rf /var/lib/apt/lists/* && \
 
    # Configure package config to a temporary folder to be able to restore it when no config is present
    mkdir -p $TMP_CONFIG $TMP_DATA/.ssh && \
    mv $PERSISTENT_CONFIG/* $TMP_CONFIG && \
    mv $PERSISTENT_DATA/* $TMP_DATA && \

    # Disable ssh host key checking per default
    echo "host *"                       >> $TMP_DATA/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> $TMP_DATA/.ssh/config && \
    htpasswd -b $TMP_CONFIG/htpasswd backuppc password && \

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

    # Make startscript executable
    chmod ugo+x $STARTSCRIPT


EXPOSE 80
VOLUME [ "$PERSISTENT_DATA", "$PERSISTENT_CONFIG" ]

cmd $STARTSCRIPT
