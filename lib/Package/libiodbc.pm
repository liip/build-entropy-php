package Package::libiodbc;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '3.52.12';


sub dependency_names {
	return qw();
}



sub base_url {
	#return "ftp://fr.rpmfind.net/pub/libxml";
	return "https://github.com/openlink/iODBC/releases/download/v$VERSION";
}


sub packagename {
	return "libiodbc-" . $VERSION;
}


sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return $self->SUPER::configure_flags() . "";
}


sub subpath_for_check {
	return "lib/libxml2.dylib";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-libxml-dir=" . $self->config()->prefix();
}

sub make_flags {
	my $self = shift @_;
	return "";
}




1;

