package Package::twig;

use strict;
use warnings;

use base qw(Package::peclbase);

#our $VERSION = '';
our $VERSION = '1.16.2';

sub init {
        my $self = shift;
        $self->SUPER::init(@_);
        $self->{PACKAGE_NAME} = 'twig';
        $self->{VERSION} = $VERSION;
}


sub base_url {
	return "http://php-osx.liip.ch/vendorpkgs";
}

sub packagesrcdir {
        my $self = shift @_;
        return $self->config()->srcdir() . "/" .  $self->packagename() . "/ext/twig/" ;
}

sub extension_ini{
    my ($self, $dst) = @_;
    $self->shell({silent => 0}, "echo ';extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
}

1;
