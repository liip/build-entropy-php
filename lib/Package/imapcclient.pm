package Package::imapcclient;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2007f';
#our $VERSION = '2004g';
#our $VERSION = '2006a';




sub base_url {
	return "ftp://ftp.cac.washington.edu/imap";
}


sub packagename {
	return "imap-$VERSION";
}


sub filename {
	return "c-client.tar.Z";
}

sub php_dso_extension_names {
        my $self = shift @_;
        return qw(imap);
}


sub package_filelist {
        my $self = shift @_;
        return
                $self->php_dso_extension_paths(),
                qw(
                        php.d/50-extension-imap.ini
                );
}

sub make_command {
	my $self = shift @_;
	my $cflags = $self->cflags();
	return qq(MACOSX_DEPLOYMENT_TARGET=10.10 EXTRACFLAGS="$cflags" make -e osx);
}


sub make_install_sourcedirs {
	return ();
}


sub build_configure {
}


sub is_installed {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/c-client/c-client.a";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	my $packagename = $self->packagename();
	return "--with-imap=shared,../$packagename --with-kerberos=/usr --with-imap-ssl=/usr/local/php5";
}





1;
