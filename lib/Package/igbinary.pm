package Package::igbinary;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '2.0.7';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'igbinary';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/"; 
}

return 1;
