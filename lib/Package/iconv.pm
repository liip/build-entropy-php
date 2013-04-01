package Package::iconv;

use strict;
use warnings;

use base qw(Package);

# our $VERSION = '1.13';
our $VERSION = '1.11';





sub base_url {
	return "ftp://sunsite.cnlab-switch.ch/mirror/gnu/libiconv";
}


sub packagename {
	return "libiconv-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libiconv.dylib";
}



sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-iconv=" . $self->config()->prefix();
}


#
# sub configure_flags {
# 	my $self = shift @_;
# 	return join " ", (
# 		$self->SUPER::configure_flags(@_),
# 		'--with-libiconv-prefix=' . $self->config()->prefix(),
# 		'--disable-java --disable-csharp --disable-native-java --without-emacs'
# 	);
# }


# sub php_dso_extension_names {
# 	my $self = shift @_;
# 	return $self->shortname() . '.so';
# }
#



# to ensure our custom iconv is found before the apple-supplied one
sub cc {
	my $self = shift @_;
	return $self->SUPER::cc(@_) . ' -L' . $self->config()->prefix() . '/lib';
}




sub package_filelist {
	my $self = shift @_;
	return qw(
		lib/libiconv*.dylib
	);
}





1;
