package Package::libgif;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '4.1.6';

sub base_url {
    my $self = shift @_;
    return "http://downloads.sourceforge.net/project/giflib/giflib%204.x/" . $self->packagename() . "/";
}

sub packagename {
	return "giflib-$VERSION";
}

sub filename {
	return "giflib-$VERSION.tar.gz";
}

#http://switch.dl.sourceforge.net/sourceforge/giflib/files/giflib-4.1.6.tar.gz

sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libgif.a";
}

sub subpath_for_check {
	my $self = shift @_;
	return "lib/libgif.a";
}

sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();

	return $self->SUPER::configure_flags(@_) . " --disable-dependency-tracking";
}

sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

1;