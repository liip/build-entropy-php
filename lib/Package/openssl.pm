package Package::openssl;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.0.2k';

sub base_url {
	return "https://www.openssl.org/source/";
}

sub packagename {
	return "openssl-" . $VERSION;
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.gz";
}


sub subpath_for_check {
	return "lib/libssl.a";
}

sub build_configure {
	my ($self) = shift;
    $self->shell('./Configure darwin64-x86_64-cc --prefix=/usr/local/php5/');
    $self->shell('make depend');
}

sub make_command {
	my $self = shift @_;
	return "make";
}


1;
