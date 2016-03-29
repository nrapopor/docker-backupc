package Bundle::BackupPC;

$VERSION = '0.01';

1;

__END__

=head1 NAME

Bundle::BackupPC - Dependency bundle for BackupPC

=head1 SYNOPSIS

perl -MCPAN -e 'install Bundle::BackupPC'

=head1 CONTENTS

Archive::Zip 1.56

Compress::Zlib 2.069

File::Listing 6.04

File::RsyncP 0.74

XML::RSS 1.59

=head1 CONFIGURATION

Summary of my perl5 (revision 5 version 20 subversion 2) configuration:
   
  Platform:
    osname=linux, osvers=3.13.0-79-generic, archname=x86_64-linux-gnu-thread-multi
    uname='linux lgw01-20 3.13.0-79-generic #123-ubuntu smp fri feb 19 14:27:58 utc 2016 x86_64 x86_64 x86_64 gnulinux '
    config_args='-Dusethreads -Duselargefiles -Dccflags=-DDEBIAN -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Dldflags= -Wl,-Bsymbolic-functions -Wl,-z,relro -Dlddlflags=-shared -Wl,-Bsymbolic-functions -Wl,-z,relro -Dcccdlflags=-fPIC -Darchname=x86_64-linux-gnu -Dprefix=/usr -Dprivlib=/usr/share/perl/5.20 -Darchlib=/usr/lib/x86_64-linux-gnu/perl/5.20 -Dvendorprefix=/usr -Dvendorlib=/usr/share/perl5 -Dvendorarch=/usr/lib/x86_64-linux-gnu/perl5/5.20 -Dsiteprefix=/usr/local -Dsitelib=/usr/local/share/perl/5.20.2 -Dsitearch=/usr/local/lib/x86_64-linux-gnu/perl/5.20.2 -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dsiteman1dir=/usr/local/man/man1 -Dsiteman3dir=/usr/local/man/man3 -Duse64bitint -Dman1ext=1 -Dman3ext=3perl -Dpager=/usr/bin/sensible-pager -Uafs -Ud_csh -Ud_ualarm -Uusesfio -Uusenm -Ui_libutil -Uversiononly -DDEBUGGING=-g -Doptimize=-O2 -Duseshrplib -Dlibperl=libperl.so.5.20.2 -des'
    hint=recommended, useposix=true, d_sigaction=define
    useithreads=define, usemultiplicity=define
    use64bitint=define, use64bitall=define, uselongdouble=undef
    usemymalloc=n, bincompat5005=undef
  Compiler:
    cc='cc', ccflags ='-D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fwrapv -fno-strict-aliasing -pipe -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64',
    optimize='-O2 -g',
    cppflags='-D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fwrapv -fno-strict-aliasing -pipe -I/usr/local/include'
    ccversion='', gccversion='5.2.1 20151010', gccosandvers=''
    intsize=4, longsize=8, ptrsize=8, doublesize=8, byteorder=12345678
    d_longlong=define, longlongsize=8, d_longdbl=define, longdblsize=16
    ivtype='long', ivsize=8, nvtype='double', nvsize=8, Off_t='off_t', lseeksize=8
    alignbytes=8, prototype=define
  Linker and Libraries:
    ld='cc', ldflags =' -fstack-protector -L/usr/local/lib'
    libpth=/usr/local/lib /usr/lib/gcc/x86_64-linux-gnu/5/include-fixed /usr/include/x86_64-linux-gnu /usr/lib /lib/x86_64-linux-gnu /lib/../lib /usr/lib/x86_64-linux-gnu /usr/lib/../lib /lib
    libs=-lgdbm -lgdbm_compat -ldb -ldl -lm -lpthread -lc -lcrypt
    perllibs=-ldl -lm -lpthread -lc -lcrypt
    libc=libc-2.21.so, so=so, useshrplib=true, libperl=libperl.so.5.20
    gnulibc_version='2.21'
  Dynamic Linking:
    dlsrc=dl_dlopen.xs, dlext=so, d_dlsymun=undef, ccdlflags='-Wl,-E'
    cccdlflags='-fPIC', lddlflags='-shared -L/usr/local/lib -fstack-protector'



=head1 AUTHOR

This Bundle has been from the CPAN.pm autobundle by removing the 3200 or so exrtreneous modules.
