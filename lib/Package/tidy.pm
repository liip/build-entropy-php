package Package::tidy;

use strict;
use warnings;

use base qw(Package);

#our $VERSION = '';
our $VERSION = '20110310';

sub base_url {
	return "http://php-osx.liip.ch/install/tidy";
}

sub packagename {
	return "tidy";
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . "-" . $VERSION . ".tar.bz2";
}


sub subpath_for_check {
	return "lib/libtidy.dylib";
}



sub package_filelist {
	my $self = shift @_;
	return qw(
		lib/libtidy*.a
	);	
}

sub build_preconfigure {
	my $self = shift @_;
	$self->shell({silent => 0}, "/bin/sh build/gnuauto/setup.sh");
}

sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --enable-shared --enable-static --disable-dependency-tracking";
}

sub build_sourcedirs {
	my $self = shift @_;
	return ($self->packagesrcdir());
}

sub build_make {
	my $self = shift @_;
	$self->shell($self->make_command());
}

sub build {
	my $self = shift @_;
	return undef if ($self->is_built());
	# prepare
	$self->unpack();
	$_->install() foreach $self->dependencies();
	$self->log("building");
	$self->cd_packagesrcdir();
	# autoconf
	$self->build_preconfigure();
	# configure
	$self->build_configure();
	# build
	$self->build_make();
	return 1;
}

sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	my $prefix = $self->install_prefix();
	return "--with-tidy=$prefix";
}

1;
