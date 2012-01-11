package Package::gettext;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.18.1.1';




sub dependency_names {
	return qw(iconv);
}


sub base_url {
	return "ftp://sunsite.cnlab-switch.ch/mirror/gnu/gettext";
}


sub packagename {
	return "gettext-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libgettextlib.dylib";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

#	return "--with-gettext=shared," . $self->config()->prefix();
	return "--with-gettext=" . $self->config()->prefix();

}


#CFLAGS='-arch i386 -arch x86_64' LDFLAGS='-arch i386 -arch x86_64' CC='cc -DENTROPY_CH_RELEASE=2' ./configure --with-libiconv-prefix=/usr/local/php5 --without-emacs --disable-java --disable-native-java --disable-dependency-tracking --prefix=/usr/local/php5

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
#		'--with-libiconv-prefix=' . $self->config()->prefix(),
		'--disable-java --disable-csharp --disable-native-java --without-emacs'
	);
}


#sub php_dso_extension_names {
#	my $self = shift @_;
#	return $self->shortname();
#}



# sub make_install_arch {
# 	my $self = shift @_;
# 	my (%args) = @_;
# 
# 	$self->shell("mkdir -p $args{prefix}/bin");
# 	$self->SUPER::make_install_arch(%args);
# }




sub package_filelist {

	my $self = shift @_;

#	return $self->config()->extdir_path('gettext.so'), qw(
#		lib/libgettext*.dylib lib/libasprintf*.dylib lib/libintl*.dylib
#		php.d/50-extension-gettext.ini share/gettext
#	);
	
	return qw(
		lib/libgettext*.dylib lib/libasprintf*.dylib lib/libintl*.dylib
		share/gettext
	);
}

sub patchfiles {
	my $self = shift @_;

	return qw(gettext.patch);
}




1;
