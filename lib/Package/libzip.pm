package Package::libzip;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.5.2';


sub dependency_names {
	return qw();
}



sub base_url {
	#return "ftp://fr.rpmfind.net/pub/libxml";
	return "https://libzip.org/download/";
}


sub packagename {
	return "lipzip-" . $VERSION;
}


sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return $self->SUPER::configure_flags();
}


sub subpath_for_check {
	return "lib/libzip.dylib";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return  $self->config()->prefix();
}

sub make_flags {
	my $self = shift @_;
	return "";
}




1;
