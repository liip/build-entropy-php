package Package::mssql;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.82';


sub base_url {
	return "http://ibiblio.org/pub/Linux/ALPHA/freetds/old/".$VERSION;
}


sub packagename {
	return "freetds-" . $VERSION;
}


sub subpath_for_check {
	return "lib/libsybdb.dylib";
}

sub configure_flags {
	my $self = shift @_;
	# check if we do a debug build:
	my $debugflag = $self->config()->debug() ? ' --enable-debug' : '';
	return $self->SUPER::configure_flags(@_) . " --disable-rpath --enable-msdblib --with-tdsver=8.0 $debugflag";
}

sub build_postconfigure {
	my $self = shift @_;
	$self->shell('cp /usr/bin/glibtool libtool');
	$self->shell('sed -i "" "#../replacements/libreplacements.la#d" src/server/Makefile.in src/ctlib/Makefile.in src/odbc/Makefile.in src/dblib/Makefile.in src/apps/Makefile.in');
	$self->shell('sed -i "" "#../../replacements/libreplacements.la#d" src/apps/fisql/Makefile.in src/dblib/unittests/Makefile.in src/tds/unittests/Makefile.in');
}

sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	my $prefix = $self->config()->prefix();
	return "--with-mssql=shared,$prefix --with-pdo-dblib=shared,$prefix";
}




sub php_dso_extension_names {
	my $self = shift @_;
	return qw(mssql pdo_dblib);
}


sub build_configure {
	my $self = shift @_;

	my $cflags = $self->cflags();
	my $ldflags = $self->ldflags();
	my $cxxflags = $self->compiler_archflags();
	my $archflags = $self->compiler_archflags();
	my $cc = $self->cc();

	my $prefix = $self->config()->prefix();
	$self->shell(qq(MACOSX_DEPLOYMENT_TARGET=10.8 CFLAGS="$cflags" LDFLAGS='$ldflags' CXXFLAGS='$cxxflags' CC='$cc $archflags' CPP='cpp' ./configure ) . $self->configure_flags());
}


sub package_filelist {
	my $self = shift @_;

	# the .so files as built by the FreeTDS build might be broken. might need to investigate.
	return $self->php_dso_extension_paths(), qw(
		etc/freetds.conf etc/locales.conf etc/pool.conf
		lib/libtds*.dylib lib/libct*.dylib lib/libsybdb*.dylib lib/libtdsodbc*.so lib/libtdssrv*.dylib
		php.d/50-extension-mssql.ini
	);
}





1;
