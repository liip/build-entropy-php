package Package::pecl_http;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '3.2.0RC1';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'pecl_http';
    $self->{VERSION} = $VERSION;
}

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename() . "/";
}

sub configure_flags {
        my $self = shift @_;
        my (%args) = @_;
        return join " ", (
                $self->SUPER::configure_flags(@_),
                '--with-http-libcurl-dir=' . $self->config()->prefix(),
                '--with-http-libevent-dir=' . $self->config()->prefix(),
                '--with-http-zlib-dir=' . $self->config()->prefix()
        );
}

sub cc {
        my $self = shift @_;
        my $prefix = $self->config()->prefix();

        # - the -L forces our custom iconv before the apple-supplied one
        # - the -I makes sure the libxml2 version number for phpinfo() is picked up correctly,
        #   i.e. ours and not the system-supplied libxml
        return $self->SUPER::cc(@_) . " -I$prefix/include/php/ext/raphf  -I$prefix/include/php/ext/propro";
}

sub install {
        my $self = shift @_;
        return undef if ($self->is_installed());

        $self->build();

        my $dst = $self->full_install_extension_dir();

        $self->shell(sprintf("sudo cp modules/%s.so $dst", "http"));
        $self->shell({silent => 0}, "echo 'extension=" . $dst . "http.so' > /tmp/60-extension-" . $self->shortname() . ".ini");
    $self->shell("sudo mv /tmp/60-extension-" . $self->shortname() . ".ini " .$self->install_prefix() . "/php.d/")
}

return 1;
