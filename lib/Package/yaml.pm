package Package::yaml;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '2.0.0';

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'yaml';
	$self->{VERSION} = $VERSION;
}

sub extension_ini{
	my ($self, $dst) = @_;
	$self->shell({silent => 0}, "echo ';extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
}

return 1;
