package Package::oauth;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.2.3';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'oauth';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

return 1;