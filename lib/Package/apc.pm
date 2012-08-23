package Package::APC;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '3.1.12';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'APC';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename();
}

sub extension_ini{
    my ($self, $dst) = @_;
    $self->shell({silent => 0}, "echo ';extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
    # some default value
    $self->shell({silent => 0}, "echo ';[APC]' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo ';apc.enabled = off' >> /tmp/50-extension-" . $self->shortname() . ".ini");
}

return 1;
