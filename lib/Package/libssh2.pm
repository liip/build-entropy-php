package Package::libssh2;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.8.0';

sub base_url {
	return "http://libssh2.org/download";
}

sub packagename {
	return "libssh2-$VERSION";
}

sub filename {
	return "libssh2-$VERSION.tar.gz";
}

sub subpath_for_check {
	return "lib/libssh2.1.dylib";
}

sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --disable-dependency-tracking";
}

sub install {
	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

1;
