package Package::apcu;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '4.0.1';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'apcu';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

sub extension_ini{
    my ($self, $dst) = @_;
    $self->shell({silent => 0}, "echo 'extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
    # some default value
    $self->shell({silent => 0}, "echo '[APCu]' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'apc.enabled = on' >> /tmp/50-extension-" . $self->shortname() . ".ini");
}

return 1;
