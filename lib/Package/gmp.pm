package Package::gmp;

use strict;
use warnings;

use base qw(Package);

#our $VERSION = '';
our $VERSION = '6.1.2';

sub init {
        my $self = shift;
        $self->SUPER::init(@_);
        $self->{PACKAGE_NAME} = 'gmp';
        $self->{VERSION} = $VERSION;
}


sub base_url {
	return "http://mirror.switch.ch/ftp/mirror/gnu/gmp"
}

sub packagename {
	my ($self) = shift;
	return $self->{PACKAGE_NAME} . "-" . $self->{VERSION};
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.bz2";
}


sub subpath_for_check {
	my $self = shift @_;
	return "lib/libgmp.dylib";
}

sub configure_flags {
	my $self = shift @_;
	# check if we do a debug build:
	my $debugflag = $self->config()->debug() ? ' --with-debug' : '';
	return $self->SUPER::configure_flags(@_);
}

sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

sub extract {
	my $self = shift @_;
	$self->shell('tar -xjf', $self->download_path());
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-gmp=shared," . $self->config()->prefix();
}



sub php_dso_extension_names {
	my $self = shift @_;
	return qw(gmp);
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(php.d/50-extension-gmp.ini lib/libgmp*.dylib);
}

1;
