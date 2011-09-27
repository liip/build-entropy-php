package Package::libtiff;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '3.9.1';

sub base_url {
	return "http://download.osgeo.org/libtiff/";
}

sub packagename {
	return "tiff-$VERSION";
}

sub filename {
	return "tiff-$VERSION.tar.gz";
}

#ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.9.1.tar.gz

sub dependency_names {
	return qw(libjpeg);
}

sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libtiff.a";
}

sub subpath_for_check {
	my $self = shift @_;
	return "lib/libtiff.a";
}

sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	
	return $self->SUPER::configure_flags(@_) . " --disable-dependency-tracking";
}

sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

# sub php_extension_configure_flags {
# 
# 	my $self = shift @_;
# 	my (%args) = @_;
# 
# 	return "--with-jpeg-dir=" . $self->config()->prefix();
# 
# }

1;