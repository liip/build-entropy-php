package Package::xdebug;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.1-dev';

sub base_url {
    return "http://svn.xdebug.org/cgi-bin/viewvc.cgi/xdebug/trunk/?root=xdebug";
}

#svn co svn://svn.xdebug.org/svn/xdebug/xdebug/trunk xdebug
sub svn_url {
    return "svn://svn.xdebug.org/svn/xdebug/xdebug/trunk";
}

sub packagename {
    return "xdebug-" . $VERSION;
}

sub filename {
    my $self = shift @_;
    return $self->packagename();
}

sub subpath_for_check {
    return "lib/php/extensions/no-debug-non-zts-20090626/xdebug.so";
}

sub download {
    my $self = shift @_;
    $_->download() foreach $self->dependencies();
    return if ($self->is_downloaded());
    $self->cd_srcdir();
    my $url = $self->svn_url();
    $self->shell("/usr/bin/svn co $url " . $self->packagename());
}

sub extract {
}

sub patch {
}

sub package_filelist {
    my $self = shift @_;
    return qw(
        lib/php/extensions/no-debug-non-zts-20090626/xdebug.so
    );  
}

sub build_preconfigure {
    my $self = shift @_;
    $self->cd_packagesrcdir();
    $self->log("xdebug cd_packagesrcd: " . $self->packagesrcdir());
    $self->shell($self->install_prefix() . '/bin/phpize  3>&1 2>&3 1>>/tmp/build-entropy-php.log');
}

sub configure_flags {
    my $self = shift @_;
    return join " ", (
        $self->SUPER::configure_flags(@_),
        '--enable-xdebug',
        '--with-php-config=' . $self->install_prefix() . '/bin/php-config'
    );
}

sub install {
    my $self = shift @_;
    return undef if ($self->is_installed());

    $self->build();

    my $dst = $self->install_prefix() . '/lib/php/extensions/no-debug-non-zts-20090626/';

    $self->shell("sudo cp modules/xdebug.so $dst");
    $self->shell({silent => 0}, "echo 'zend_extension=" . $dst . $self->shortname() . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
    # some default value
    $self->shell({silent => 0}, "echo '[xdebug]' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.remote_enable=on' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.default_enable=on' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.remote_autostart=off' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.remote_port=9000' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.remote_host=localhost' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.profiler_enable_trigger=1' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.profiler_output_name=xdebug-profile-cachegrind.out-%H-%R' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.var_display_max_children = 128' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.var_display_max_data = 2048' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo 'xdebug.var_display_max_depth = 128' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    
    $self->shell("sudo mv /tmp/50-extension-" . $self->shortname() . ".ini " .$self->install_prefix() . "/php.d/")
}

1;