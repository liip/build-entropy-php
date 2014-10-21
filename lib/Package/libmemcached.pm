package Package::libmemcached;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '1.0.18';

sub dependency_names {
        return qw(libevent);
}
sub base_url {
#	return "http://download.tangent.org/";
return "https://launchpad.net/libmemcached/1.0/$VERSION/+download/";

}

sub packagename {
	return "libmemcached-$VERSION";
}

sub filename {
	return "libmemcached-$VERSION.tar.gz";
}


#http://download.tangent.org/libmemcached-0.34.tar.gz
#https://launchpad.net/libmemcached/1.0/0.38/+download/libmemcached-0.38.tar.gz

sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libmemcached.dylib";
}

sub subpath_for_check {
	my $self = shift @_;
	return "lib/libmemcached.dylib";
}

sub configure_flags {
	my $self = shift @_;
	# check if we do a debug build:
	return $self->SUPER::configure_flags(@_) . " --without-mysql --disable-dependency-tracking";
}

sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));

	$self->cd_packagesrcdir();
	$self->shell("make install");
}

# sub php_extension_configure_flags {
#
#   my $self = shift @_;
#   my (%args) = @_;
#
#   return "--with-jpeg-dir=" . $self->config()->prefix();
#
# }


sub patchfiles {
        my $self = shift @_;
        return qw(libmemcached.patch);
        #return qw(php-entropy.patch php-entropy-imap.patch);
}

1;

