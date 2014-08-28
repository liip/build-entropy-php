package Package::mhash;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.9.9.9';



sub base_url {
	return "http://switch.dl.sourceforge.net/sourceforge/mhash";
}


sub packagename {
	return "mhash-" . $VERSION;
}


sub subpath_for_check {
	return "lib/libmhash.dylib";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-mhash=shared," . $self->config()->prefix();
}


sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(
		lib/libmhash*.dylib
		php.d/50-extension-mhash.ini
	);
}




1;
