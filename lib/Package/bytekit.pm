package Package::bytekit;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.1.1';

sub base_url {
	my $self = shift;
	return "http://www.bytekit.org/download";
}

sub packagename {
	return "bytekit-" . $VERSION;
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tgz";
}

sub build_preconfigure {
	my $self = shift @_;
	$self->cd_packagesrcdir();
	$self->shell($self->install_prefix() . '/bin/phpize  3>&1 2>&3 1>>/tmp/build-entropy-php.log');
}

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--enable-bytekit',
		'--with-php-config=' . $self->install_prefix() . '/bin/php-config'
	);
}

sub install {
	my $self = shift @_;

	$self->build();

        my $dst = $self->full_install_extension_dir();
	$self->shell("sudo cp modules/bytekit.so $dst");
	$self->shell({silent => 0}, "echo 'extension=" . $dst . $self->shortname() . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
	$self->shell("sudo mv /tmp/50-extension-" . $self->shortname() . ".ini " .$self->install_prefix() . "/php.d/")
}

sub subpath_for_check {
	return $self->install_extension_dir() . "bytekit.so";
}

1;
