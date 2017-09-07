package Package::mcrypt;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.0.1';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'mcrypt';
    $self->{VERSION} = $VERSION;
}

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--with-mcrypt=' .	$self->config()->prefix() 
	);
	
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

sub package_filelist {
        my $self = shift @_;
        return $self->php_dso_extension_paths(), qw(
                lib/libmcrypt*.dylib
                php.d/50-extension-mcrypt.ini
        );
}

sub php_dso_extension_names {
        my $self = shift @_;
        return $self->shortname();
}

return 1;
