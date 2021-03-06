package Package::mongodb;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.2.9';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'mongodb';
    $self->{VERSION} = $VERSION;
}

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--with-openssl-dir=' .	$self->config()->prefix()
	);
	
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

return 1;
