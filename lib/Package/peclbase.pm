package Package::peclbase;

=pod

Base class for PECL packages. Packages that extend this class are intended to be built
independently of the main PHP build ( i.e. as separate steps in build-php.pl )

=cut

use strict;
use warnings;

use base qw(Package);

sub init {
	my $self = shift;
	$self->SUPER::init(@_);
	$self->{PACKAGE_NAME} = undef;
	$self->{VERSION} = undef;
}

sub base_url {
	my $self = shift;
	return "http://pecl.php.net/get";
}

sub packagename {
	my ($self) = shift;
	return $self->{PACKAGE_NAME} . "-" . $self->{VERSION};
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
		'--enable-' . lc($self->{PACKAGE_NAME}),
		'--with-php-config=' . $self->install_prefix() . '/bin/php-config'
	);
}

sub install {
	my $self = shift @_;
	return undef if ($self->is_installed());

	$self->build();

	my $dst = $self->install_prefix() . '/lib/php/extensions/no-debug-non-zts-20100525/';

	$self->shell(sprintf("sudo cp modules/%s.so $dst", lc($self->{PACKAGE_NAME})));
	$self->extension_ini($dst);
	$self->shell("sudo mv /tmp/50-extension-" . lc($self->shortname()) . ".ini " .$self->install_prefix() . "/php.d/")
}

sub extension_ini{
	my ($self, $dst) = @_;
	$self->shell({silent => 0}, "echo 'extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
}

sub subpath_for_check {
	my $self = shift;
	return sprintf("lib/php/extensions/no-debug-non-zts-20100525/%s.so", lc($self->{PACKAGE_NAME}));
}

1;