package Package::uploadprogress;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.0.3.1';

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'uploadprogress';
	$self->{VERSION} = $VERSION;
}

return 1;