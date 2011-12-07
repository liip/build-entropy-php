package Package::twig;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.0.1';

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'twig';
	$self->{VERSION} = $VERSION;
}



sub base_url {
    return "https://github.com/fabpot/Twig/tarball/master";
}


sub url {
	my $self = shift @_;
	return $self->base_url();// . "/" . $self->filename();
}

return 1;