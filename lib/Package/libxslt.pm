package Package::libxslt;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.1.28';



sub dependency_names {
	return qw(libxml2);
}


sub base_url {
	return "http://xmlsoft.org/sources";
}


sub packagename {
	return "libxslt-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libxslt.dylib";
}



sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags() . " --without-crypto --disable-dependency-tracking --without-python --with-libxml-prefix=" . $self->install_prefix();

}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-xsl=shared," . $self->config()->prefix();

}



sub php_dso_extension_names {
	my $self = shift @_;
	return qw(xsl);
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(php.d/50-extension-xsl.ini lib/libexslt*.dylib lib/libxslt*.dylib);
}



1;
