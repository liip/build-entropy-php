package Package::libxml2;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.7.8';


sub dependency_names {
	return qw(iconv);
}



sub base_url {
	#return "ftp://fr.rpmfind.net/pub/libxml";
	return "http://xmlsoft.org/sources";
}


sub packagename {
	return "libxml2-" . $VERSION;
}


sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return $self->SUPER::configure_flags() . " --disable-dependency-tracking --without-python";
}


sub subpath_for_check {
	return "lib/libxml2.dylib";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-libxml-dir=shared," . $self->config()->prefix();
}

sub make_flags {
	my $self = shift @_;
	return "";
}




1;
