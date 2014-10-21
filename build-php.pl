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
use Package::memcached;
use Package::memcache;
use Package::xhprof;
use Package::twig;
use Package::APC;
use Package::solr;
use Package::oauth;
use Package::xslcache;
#use Package::yaml;
use Package::mongo;
use Package::redis;
use Package::apcu;
use Package::igbinary;
use Package::phpunit;
use Package::libssh2;
use Package::ssh2;
use Package::opcache;

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
	version              => '5.4.34',
	release              => 1,
	debug                => 1,
);
my $php = Package::php5->new(config => $config, variant => 'apache2');
$config->{phpsrcdir} = $php->packagesrcdir();
$php->install();

	my $xdebug = Package::xdebug->new(config => $config, variant => 'apache2');
$xdebug->install();

my $upload = Package::uploadprogress->new(config => $config, variant => 'apache2');
$upload->install();

my $intl = Package::intl->new(config => $config, variant => 'apache2');
$intl->install();

#libmemcached doesn't yet compile on 10.10
my $memcached = Package::memcached->new(config => $config, variant => 'apache2');
$memcached->install();

my $memcache = Package::memcache->new(config => $config, variant => 'apache2');
$memcache->install();

my $xhprof = Package::xhprof->new(config => $config, variant => 'apache2');
$xhprof->install();

my $twig = Package::twig->new(config => $config, variant => 'apache2');
$twig->install();

my $APC = Package::APC->new(config => $config, variant => 'apache2');
$APC->install();

my $solr = Package::solr->new(config => $config, variant => 'apache2');
$solr->install();

my $oauth = Package::oauth->new(config => $config, variant => 'apache2');
$oauth->install();

#my $xslcache = Package::xslcache->new(config => $config, variant => 'apache2');
#$xslcache->install();

# Needs libYAML to be integrated as well, left for later
# my $yaml = Package::yaml->new(config => $config, variant => 'apache2');
# $yaml->install();

my $mongo = Package::mongo->new(config => $config, variant => 'apache2');
$mongo->install();

my $redis = Package::redis->new(config => $config, variant => 'apache2');
$redis->install();

my $apcu = Package::apcu->new(config => $config, variant => 'apache2');
$apcu->install();

my $igbinary = Package::igbinary->new(config => $config, variant => 'apache2');
$igbinary->install();

my $libssh2 = Package::libssh2->new(config => $config, variant => 'apache2');
$libssh2->install();

my $ssh2 = Package::ssh2->new(config => $config, variant => 'apache2');
$ssh2->install();

my $opcache = Package::opcache->new(config => $config, variant => 'apache2');
$opcache->install();

my $phpunit = Package::phpunit->new(config => $config, variant => 'apache2');
$phpunit->install();

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

