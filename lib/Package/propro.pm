package Package::propro;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.0.0';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'propro';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

sub install {

        my $self = shift @_;
        return undef if ($self->is_installed());
        $self->SUPER::install(@_);
        $self->cd_packagesrcdir();
        $self->shell("make install-headers");
}

return 1;
