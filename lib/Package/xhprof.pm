package Package::xhprof;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '0.9.4';

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'xhprof';
	$self->{VERSION} = $VERSION;
}

sub packagesrcdir {
	my $self = shift @_;
	return $self->config()->srcdir() . "/" . $self->packagename() . "/extension";
}

## The following code is needed, if you download from our own repo instead of pecl
## currently the pecl repo is current enough

#sub base_url {
#	my $self = shift;
#	return "http://php-osx.liip.ch/vendorpkgs";
#}

return 1;
