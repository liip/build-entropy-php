package Package;

use strict;
use warnings;
use base qw(PackageBase);

our $VERSION = '1.0';

# superclass for simple packages which don't require splice build


sub install {
	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));
	my $dst = $self->install_prefix();
	system("mkdir -p $dst");
	die "Unable to find or create installation dir '$dst'" unless (-d $dst);
	my $install_override = $self->make_install_override_list(prefix => $dst);
	my @dirs = $self->make_install_sourcedirs();
	foreach my $dir (@dirs) {
		$self->cd($dir);
		$self->shell($self->make_command() . " $install_override install");
	}
	return 1;
}

sub make_install_sourcedirs {
	my $self = shift @_;
	return $self->build_sourcedirs();
}

sub build_sourcedirs {
	my $self = shift @_;
	return ($self->packagesrcdir());
}

sub build {
	my $self = shift @_;
	return unless ($self->SUPER::build(@_));
	my (%args) = @_;

	$self->build_preconfigure();

	$self->cd_packagesrcdir();

	$self->build_configure();

	$self->build_postconfigure(%args);

	foreach my $dir ($self->build_sourcedirs()) {
		$self->cd($dir);
		my $make_command = $self->make_command();
		my $prefix = $self->config()->prefix();
		
		$self->shell(' ' . $make_command);
	}
}

sub build_configure {
	my $self = shift @_;

	my $cflags = $self->cflags();
	my $ldflags = $self->ldflags();
	my $cxxflags = $self->compiler_archflags();
	my $archflags = $self->compiler_archflags();
	my $cc = $self->cc();

	my $prefix = $self->config()->prefix();
	$self->shell(qq(MACOSX_DEPLOYMENT_TARGET=10.7 CFLAGS="$cflags" LDFLAGS='$ldflags' CXXFLAGS='$cxxflags' CC='$cc' ./configure ) . $self->configure_flags());
}

sub build_preconfigure {
	my $self = shift @_;
	my (%args) = @_;
}

sub build_postconfigure {
	my $self = shift @_;
	my (%args) = @_;
}

1;
