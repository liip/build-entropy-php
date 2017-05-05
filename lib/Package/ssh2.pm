package Package::ssh2;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '1.0';

sub init {
        my $self = shift;
        $self->SUPER::init(@_);
        $self->{PACKAGE_NAME} = 'ssh2';
        $self->{VERSION} = $VERSION;
}


sub base_url {
    return "http://pecl.php.net/get";
}

sub packagesrcdir {
        my $self = shift @_;
        return $self->config()->srcdir() . "/" .  $self->packagename() . "/" ;
}

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--enable-' . lc($self->{PACKAGE_NAME}),
		'--with-php-config=' . $self->install_prefix() . '/bin/php-config',
        '--with-ssh2=/usr/local/php5'
	);
}

sub extension_ini{
    my ($self, $dst) = @_;
    $self->shell({silent => 0}, "echo 'extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
}

1;
