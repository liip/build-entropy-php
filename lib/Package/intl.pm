package Package::intl;

use strict;
use warnings;

use base qw(Package::peclbase);

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = 'intl';
	
}

sub unpack { 
}

sub packagesrcdir {
	my $self = shift @_;
	return $self->config()->phpsrcdir . "/ext/intl"; 
}


sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--with-icu-dir=' .	$self->config()->prefix()
	);
	
}


return 1;
