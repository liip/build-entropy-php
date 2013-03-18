package Package::APC;

use strict;
use warnings;

use base qw(Package::peclbase);

our $VERSION = '3.1.13';

sub init {
    my $self = shift;
    $self->SUPER::init(@_);
    $self->{PACKAGE_NAME} = 'APC';
    $self->{VERSION} = $VERSION;
}

## just for SVN, remove if you want to download official releases */

#sub svn_url {
#    return "https://svn.php.net/repository/pecl/apc/trunk";
#}

#sub download {
#    my $self = shift @_;
#    $_->download() foreach $self->dependencies();
#    return if ($self->is_downloaded());
#    $self->cd_srcdir();
#    my $url = $self->svn_url();
#    $self->shell("/usr/bin/svn co $url " . $self->packagename());
#}


#sub extract {
#}

#sub patch {
#}

## end SVN*/

sub packagesrcdir {
    my $self = shift @_;
    return $self->config()->srcdir() . "/" . $self->packagename();
}

sub extension_ini{
    my ($self, $dst) = @_;
    $self->shell({silent => 0}, "echo ';extension=" . $dst . lc($self->shortname()) . ".so' > /tmp/50-extension-" . $self->shortname() . ".ini");
    # some default values
    $self->shell({silent => 0}, "echo ';[APC]' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo ';apc.enabled = 1' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo ';apc.shm_segments = 1' >> /tmp/50-extension-" . $self->shortname() . ".ini");
    $self->shell({silent => 0}, "echo ';apc.shm_size = 128M' >> /tmp/50-extension-" . $self->shortname() . ".ini");
}

return 1;
