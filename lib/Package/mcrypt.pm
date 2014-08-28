package Package::mcrypt;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.5.8';


sub base_url {
	return "http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/$VERSION";
}


sub packagename {
	return "libmcrypt-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libmcrypt.dylib";
}



sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-mcrypt=shared," . $self->config()->prefix();
}

sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --disable-dependency-tracking";
}

sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(
		lib/libmcrypt*.dylib
		php.d/50-extension-mcrypt.ini
	);
}





1;
