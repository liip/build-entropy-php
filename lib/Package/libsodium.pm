package Package::libsodium;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.0.18-stable';


sub dependency_names {
	return qw();
}



sub base_url {
	return "https://download.libsodium.org/libsodium/releases";
}


sub packagename {
	return "libsodium-" . $VERSION;
}


sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return $self->SUPER::configure_flags();
}


sub subpath_for_check {
	return "lib/libsodium.dylib";
}


sub make_flags {
	my $self = shift @_;
	return "";
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/libsodium-stable";
}



1;
