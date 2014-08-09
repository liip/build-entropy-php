package Package::postgresql;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '9.3.5';


sub base_url {
    return "http://ftp.postgresql.org/pub/source/v$VERSION/"
    # return "ftp://ftp2.ch.postgresql.org/pub/mirrors/postgresql/source/v$VERSION/";
}


sub packagename {
	return "postgresql-" . $VERSION;
}


sub subpath_for_check {
	return "lib/libpq.dylib";
}


sub make_flags {
	return '';
}

sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	my $prefix = $self->config()->prefix();
	return "--with-pgsql=shared,$prefix --with-pdo-pgsql=shared,$prefix";
}



sub php_dso_extension_names {
	my $self = shift @_;
	return qw(pgsql pdo_pgsql);
}



sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(
		lib/libpgtypes*.dylib
		lib/libpq*.dylib
		php.d/50-extension-*pgsql*.ini
	);
}



# sub configure_flags {
# 	my $self = shift @_;
# 	return $self->SUPER::configure_flags() . ' --disable-depend';
# }

sub configure_flags {
	my $self = shift @_;
	return "--with-openssl --disable-depend --without-docdir --prefix=" . $self->install_prefix();
}




1;
