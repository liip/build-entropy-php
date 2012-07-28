package Package::libmemcached;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.38';

sub base_url {
	return "http://download.tangent.org/older-releases";
}

sub packagename {
	return "libmemcached-$VERSION";
}

sub filename {
	return "libmemcached-$VERSION.tar.gz";
}

#http://download.tangent.org/libmemcached-0.34.tar.gz

sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libmemcached.4.dylib";
}

sub subpath_for_check {
	my $self = shift @_;
	return "lib/libmemcached.4.dylib";
}

sub configure_flags {
	my $self = shift @_;
	# check if we do a debug build:
	my $debugflag = $self->config()->debug() ? ' --with-debug' : '';
	return $self->SUPER::configure_flags(@_) . " --disable-dependency-tracking $debugflag";
}

sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

# sub php_extension_configure_flags {
#
#   my $self = shift @_;
#   my (%args) = @_;
#
#   return "--with-jpeg-dir=" . $self->config()->prefix();
#
# }


1;