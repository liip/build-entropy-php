package Package::opcache;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '7.0.2';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'opcache';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/"; 
}

sub filename {
	return "zendopcache-$VERSION.tgz";
}

sub packagesrcdir {
        my $self = shift @_;
        return $self->config()->srcdir() . "/zendopcache-" . $self->{VERSION} . "/" ;
}

# handled in php5.pm
sub extension_ini {
}

# handled in php5.pm
sub mv_ini_to_php_d {
}


return 1;