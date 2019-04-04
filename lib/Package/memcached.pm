package Package::memcached;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '3.1.3';

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'memcached';
	$self->{VERSION} = $VERSION;
}

sub dependency_names {
	return qw(libmemcached);
}

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
        '--with-libmemcached-dir=' . $self->config()->prefix()
	);
}

return 1;
