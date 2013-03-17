package Package::libevent;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.0.19-stable';

sub base_url {
	return "https://github.com/downloads/libevent/libevent";
}

sub packagename {
	return "libevent-$VERSION";
}

sub filename {
	return "libevent-$VERSION.tar.gz";
}

#http://download.tangent.org/libmemcached-0.34.tar.gz

sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libevent.dylib";
}

sub subpath_for_check {
	my $self = shift @_;
	return "lib/libevent.dylib";
}

sub configure_flags {
	my $self = shift @_;
	# check if we do a debug build:
	my $debugflag = $self->config()->debug() ? ' --with-debug' : '';
	return $self->SUPER::configure_flags(@_);
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
