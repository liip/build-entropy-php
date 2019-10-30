# Main driver script for the PHP build process
#
# Invoke with
#     sudo perl -Ilib build-php.pl
#

use strict;
use warnings;

use Imports;
use Package::php5;
use Package::xdebug;
use Package::uploadprogress;
use Package::libmemcached;
use Package::libevent;
use Package::intl;
use Package::mcrypt;
use Package::memcached;
#use Package::memcache;
use Package::xhprof;
use Package::twig;
use Package::APC;
use Package::solr;
use Package::oauth;
use Package::xslcache;
#use Package::yaml;
use Package::mongodb;
use Package::redis;
use Package::propro;
use Package::raphf;
use Package::pecl_http;
use Package::apcu;
use Package::igbinary;
#use Package::phpunit;
use Package::libssh2;
use Package::ssh2;

my $basedir = qx(pwd);
chomp $basedir;
die "you must run this script in the build-entropy-php directory" unless ($basedir =~ m#/build-entropy-php$#);

check_dotpear();
check_arch();
check_ltdl();

# putting cpus to 1 to disable parallel builds because it breaks libxml2 build
my $config = Config->new(
	cpus                 => 2,
	basedir              => $basedir,
	prefix               => '/usr/local/php5',
	phpsrcdir            => undef,
	orahome              => "$basedir/install",
	mysql_install_prefix => undef,
	variants             => {
		apache1          => {
			apxs_option  => '--with-apxs',
			suffix       => '',
		},
		apache2          => {
			apxs_option  => '--with-apxs2=/usr/sbin/apxs',
			suffix       => '-apache2',
		},
	},
	version              => '7.3.8',
	release              => 1,
	debug                => 0,
);
my $php = Package::php5->new(config => $config, variant => 'apache2');
$config->{phpsrcdir} = $php->packagesrcdir();
$php->install();

# TODO: readd for 7.3
my $xdebug = Package::xdebug->new(config => $config, variant => 'apache2');
$xdebug->install();

# TODO: adjust for 7.0
#my $upload = Package::uploadprogress->new(config => $config, variant => 'apache2');
#$upload->install();

my $intl = Package::intl->new(config => $config, variant => 'apache2');
$intl->install();

# TODO: adjust for 7.3
#my $memcached = Package::memcached->new(config => $config, variant => 'apache2');
#$memcached->install();

# TODO: adjust for 7.0
#my $xhprof = Package::xhprof->new(config => $config, variant => 'apache2');
#$xhprof->install();

# TODO: adjust for 7.0
#my $twig = Package::twig->new(config => $config, variant => 'apache2');
#$twig->install();

#my $APC = Package::APC->new(config => $config, variant => 'apache2');
#$APC->install();

# TODO: adjust for 7.2
#my $solr = Package::solr->new(config => $config, variant => 'apache2');
#$solr->install();

# TODO: adjust for 7.0
#my $oauth = Package::oauth->new(config => $config, variant => 'apache2');
#$oauth->install();

#my $xslcache = Package::xslcache->new(config => $config, variant => 'apache2');
#$xslcache->install();

# Needs libYAML to be integrated as well, left for later
#my $yaml = Package::yaml->new(config => $config, variant => 'apache2');
#$yaml->install();


# TODO: adjust for 7.0
my $mongodb = Package::mongodb->new(config => $config, variant => 'apache2');
$mongodb->install();

my $redis = Package::redis->new(config => $config, variant => 'apache2');
$redis->install();
my $mcrypt = Package::mcrypt->new(config => $config, variant => 'apache2');
$mcrypt->install();

my $propro = Package::propro->new(config => $config, variant => 'apache2');
$propro->install();

my $raphf = Package::raphf->new(config => $config, variant => 'apache2');
$raphf->install();

# TODO: adjust for 7.3
#my $pecl_http = Package::pecl_http->new(config => $config, variant => 'apache2');
#$pecl_http->install();

my $apcu = Package::apcu->new(config => $config, variant => 'apache2');
$apcu->install();

# TODO: adjust for 7.0
my $igbinary = Package::igbinary->new(config => $config, variant => 'apache2');
$igbinary->install();

# TODO: adjust for 7.3
#my $libssh2 = Package::libssh2->new(config => $config, variant => 'apache2');
#$libssh2->install();

# TODO: adjust for 7.3
#my $ssh2 = Package::ssh2->new(config => $config, variant => 'apache2');
#$ssh2->install();

#my $phpunit = Package::phpunit->new(config => $config, variant => 'apache2');
#$phpunit->install();

# If there is a ~/.pear directory, "make install-pear" will not work properly
sub check_dotpear {
	if (-e "$ENV{HOME}/.pear" || -e "$ENV{HOME}/.pearrc") {
		die "There is a ~/.pear directory and/or ~/.pearrc file, please move it aside temporarily for the build\n";
	}
}

# If Xcode is installed then the mcrypt extension build picks up libltdl,
# which will be missing on target systems without Xcode.
sub check_ltdl {
	if (glob('/usr/lib/libltdl.*')) {
		die "/usr/lib/libltdl.* files are present on this system but will be missing on target systems, please move them aside temporarily for the build:\nsudo mkdir -p /usr/lib/off && sudo mv /usr/lib/libltdl.* /usr/lib/off/\n";
	}
	if (glob('/usr/local/lib/libltdl.*')) {
		die "/usr/local/lib/libltdl.* files are present on this system but will be missing on target systems, please move them aside temporarily for the build\n";
	}
}

# if we don't build on x86_64, the resulting mcrypt extension will
# work on i386 but crash on x86_64
sub check_arch {
	my $x86_64 = `sysctl -n hw.optional.x86_64`; chomp $x86_64;
	unless ($x86_64) {
		die "This build process must be run on an x86_64 architecture system\n";
	}
}

