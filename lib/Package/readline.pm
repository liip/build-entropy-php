package Package::readline;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '6.3';

sub init {
        my $self = shift;
        $self->SUPER::init(@_);
        $self->{PACKAGE_NAME} = 'readline';
        $self->{VERSION} = $VERSION;
}


sub base_url {
	return "http://mirror.switch.ch/ftp/mirror/gnu/readline"
}

sub packagename {
	my ($self) = shift;
	return $self->{PACKAGE_NAME} . "-" . $self->{VERSION};
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.gz";
}


sub subpath_for_check {
	my $self = shift @_;
	return "lib/libreadline.a";
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



sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-readline=shared," . $self->config()->prefix();
}



sub php_dso_extension_names {
	my $self = shift @_;
	return qw(readline);
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(php.d/50-extension-readline.ini lib/libreadline.a);
}

1;
