package Package::mysql;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '5.6.20';


sub init {
	my $self = shift @_;
	$self->SUPER::init(@_);
	$self->config()->mysql_install_prefix($self->install_prefix());
}


sub base_url {
	my ($major, $minor, $patch) = $VERSION =~ /^(\d+)\.(\d+)\.(\d+)/;
	return "http://mirror.switch.ch/ftp/mirror/mysql/Downloads/MySQL-$major.$minor/";
}


sub packagename {
	return "mysql-" . $VERSION;
}


sub subpath_for_check {
	return "lib/mysql/libmysqlclient.dylib";
}


sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --without-server --enable-thread-safe-client";
}


sub make_install_sourcedirs {
	my $self = shift @_;
	return map {$self->packagesrcdir() . "/$_"} qw(include libmysql scripts);
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	my $mysql_prefix = $self->config()->mysql_install_prefix();
	die "mysql install prefix '$mysql_prefix' does not exist" unless (-d $mysql_prefix);
	return "--with-mysql=shared,$mysql_prefix --with-mysqli=shared,$mysql_prefix/bin/mysql_config --with-pdo-mysql=shared,$mysql_prefix --with-mysql-sock=/tmp/mysql.sock";
}


sub install {
	my $self = shift @_;
	$self->SUPER::install(@_);
	$self->cd_packagesrcdir();
	my $prefix = $self->config()->prefix();
	$self->shell("cp include/mysqld_error.h $prefix/include/mysql");
}


sub php_dso_extension_names {
	my $self = shift @_;
	return qw(mysql mysqli pdo_mysql);
}


sub package_filelist {
	my $self = shift @_;
	return
		$self->php_dso_extension_paths(),
		qw(
			lib/mysql/lib*.dylib
			php.d/50-extension-*mysql*.ini
		);
}


1;
