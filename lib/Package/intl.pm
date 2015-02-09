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

sub cc {
        my $self = shift @_;
        my $prefix = $self->config()->prefix();

        # - the -L forces our custom iconv before the apple-supplied one
        # - the -I makes sure the libxml2 version number for phpinfo() is picked up correctly,
        #   i.e. ours and not the system-supplied libxml
        return $self->SUPER::cc(@_) . " -I".$self->config()->phpsrcdir();
}


return 1;
