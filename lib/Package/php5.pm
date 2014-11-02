package Package::php5;

use strict;
use warnings;

use IO::File;
use IO::Dir;

use base qw(Package);

# todo:
# rework this so it runs normally and a third time for the cli version.
# add the new cli/cgi (?) as php-cli or php-cgi
# enable --enable-pcntl and fastcgi for the cgi version

sub base_url {
	my $self = shift @_;
	my $v = $self->config()->version();
	if ($v ~~ /latest/) {
		return "http://snaps.php.net";
	} else {
		#return "http://downloads.php.net/stas";
		return "http://ch1.php.net/distributions";
	}
}


sub packagename {
	my $self = shift @_;
	my $v = $self->config()->version();
	if ($v ~~ /latest/) {
		return "php" . $self->config()->version();
	} else {
		return "php-" . $self->config()->version();
	}
}

sub packagesrcdir {
	my $self = shift @_;
	my $dlpath = $self->download_path();
	my $exists = -e $dlpath;
	$self->download() unless ($exists);

	my $srcdir = `tar -tzf  $dlpath  | head -1`;
	$srcdir =~ s/^\s+//;
	$srcdir =~ s/\s+$//;
	return $self->config()->srcdir() . "/" .$srcdir;
}

sub dependency_names {
	 return qw(      icu mssql libxml2 libxslt imapcclient gettext curl libpng libjpeg libtiff libgif libfreetype postgresql mcrypt tidy gmp readline);
	#before 10.8
	#return qw(iconv icu mssql libxml2 libxslt imapcclient gettext curl libpng libjpeg libtiff libgif libfreetype postgresql mcrypt tidy);
}

sub subpath_for_check {
	return "libphp5.so";
}


# broken ming build setup can not handle distclean target
sub cleanup_srcdir {
	my $self = shift @_;
	$self->cd_srcdir();
	$self->shell("rm -rf php-*");
	$self->unpack();
}


sub configure_flags {
	my $self = shift @_;
	my %args = @_;
	my $prefix = $self->config()->prefix();

	my @extension_flags = (
		"--with-config-file-scan-dir=$prefix/php.d",
		'--with-openssl=/usr',
		'--with-zlib=/usr',
		'--with-zlib-dir=/usr',
		'--with-gd',
		'--with-ldap',
		'--enable-exif',
		'--with-xmlrpc',
		'--enable-exif',
		'--enable-soap',
		'--enable-sqlite-utf8',
		'--enable-wddx',
		'--enable-ftp',
		'--enable-sockets',
		'--with-bz2=/usr',
		'--enable-zip',
		'--enable-pcntl',
		'--enable-shmop',
		'--enable-sysvsem',
		'--enable-sysvshm',
		'--enable-sysvmsg',
		'--enable-mbstring',
		'--enable-bcmath',
		'--enable-calendar',
		'--with-iodbc',
		'--with-mhash',
		'--enable-fpm',
		'--with-mysql=mysqlnd',
		'--with-mysqli=mysqlnd',
		'--with-pdo-mysql=mysqlnd',
		'--enable-pcntl',
		'--enable-dtrace'
	);

	push @extension_flags, $self->dependency_extension_flags(%args);

	my $apxs_option = $self->config()->variants()->{$self->{variant}}->{apxs_option};
	return $self->SUPER::configure_flags() . " $apxs_option @extension_flags";

}

sub build_postconfigure {
	my $self = shift @_;
	#$self->shell("sed -i '' -e 's#\$echo#\$ECHO#g' libtool");
}

sub build_preconfigure {
	my $self = shift @_;
	my (%args) = @_;

	# give extension modules a chance to tweak the contents of the ext directory
	foreach my $dependency ($self->dependencies()) {
		$self->cd_packagesrcdir();
		$self->cd('ext');
		$dependency->php_build_pre(%args, php_package => $self);
	}

	$self->cd_packagesrcdir();
    #$self->shell("aclocal");
    #$self->shell("./buildconf --force");
	$self->shell({fatal => 0}, "ranlib " . $self->install_prefix() . "/lib/*.a");
	$self->shell({fatal => 0}, "ranlib " . $self->install_tmp_prefix() . "/lib/*.a");

}

sub dependency_extension_flags {
	my $self = shift @_;
	my (%args) = @_;

	# fixme: figure out something for extensions with fewer archs
	#return map {$_->php_extension_configure_flags()} grep {$_->supports_arch($args{arch})} $self->dependencies();
	return map {$_->php_extension_configure_flags()} $self->dependencies();
}

sub install {

	my $self = shift @_;
	return undef if ($self->is_installed());

	$self->build();

	my $dst = $self->install_prefix();
	system("mkdir -p $dst");
	die "Unable to find or create installation dir '$dst'" unless (-d $dst);

	my $install_override = $self->make_install_override_list(prefix => $dst);
 	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli build headers programs modules fpm cgi);

 	$self->shell("cp libs/libphp5.so $dst");
 	$self->shell("rm $dst/lib/php/extensions/*/*.a");


#	$self->SUPER::install(@_);

	my $extrasdir = $self->extras_dir();
	my $prefix = $self->config()->prefix();


	$self->cd_packagesrcdir();
	$self->shell({silent => 0}, "cat $extrasdir/dist/entropy-php.conf | sed -e 's!{prefix}!$prefix!g' > $prefix/entropy-php.conf");
	$self->shell({silent => 0}, "cat $extrasdir/dist/activate-entropy-php.py | sed -e 's!{prefix}!$prefix!g' > $prefix/bin/activate-entropy-php.py");
	$self->shell({silent => 0}, "cp php.ini-production php.ini-recommended");
	$self->shell({silent => 0}, "cp php.ini-recommended $prefix/lib/");
	$self->shell({silent => 0}, "cp php.ini-development $prefix/lib/");
	$self->shell({silent => 0}, "cp php.ini-development $prefix/lib/php.ini");
	#unless (-e "$prefix/etc/pear.conf.default") {
		$self->shell($self->make_command(), "install-pear");
#		$self->shell({silent => 0}, qq!sed -e 's#"[^"]*$prefix\\([^"]*\\)#"$prefix\\1"#g' < $prefix/etc/pear.conf > $prefix/etc/pear.conf.default!);
#		$self->shell({silent => 0}, "rm $prefix/etc/pear.conf");
		$self->shell({silent => 0}, "mv $prefix/etc/pear.conf $prefix/etc/pear.conf.default");
	#}
	$self->shell({silent => 0}, "test -d $prefix/php.d || mkdir $prefix/php.d");
	$self->shell({silent => 0}, "perl -p -i -e 's# -L\\S+c-client##' $prefix/bin/php-config");

	$self->create_dso_ini_files();

	$self->shell({silent => 0}, "sudo chown -R root:wheel '$prefix'");
	$self->shell({silent => 0}, "test -e '$prefix/lib/php/build' || sudo ln -s '$prefix/lib/build' '$prefix/lib/php/'");

}

sub create_dso_ini_files {
	my $self = shift @_;

	my @dso_names = grep {$_} map {$_->php_dso_extension_names()} $self->dependencies();
	my $prefix = $self->config()->prefix();
	my $extdir = $self->config()->extdir();
	$self->shell({silent => 0}, "echo 'extension=$_.so' > $prefix/php.d/50-extension-$_.ini") foreach (@dso_names);
	$self->shell({silent => 0}, qq!echo 'extension_dir=$prefix/$extdir' > $prefix/php.d/10-extension_dir.ini!);

	# adding some default values
	# TODO: fixme
	$self->shell({silent => 0}, "echo 'mssql.charset = UTF-8' >> $prefix/php.d/50-extension-mssql.ini");
        my $dst = $self->full_install_extension_dir();
	$self->shell({silent => 0}, "echo ';zend_extension=" . $dst . "opcache.so' > $prefix/php.d/20-extension-opcache.ini");
    	# some default value
    	$self->shell({silent => 0}, "echo '[opcache]' >>  $prefix/php.d/20-extension-opcache.ini");
    	$self->shell({silent => 0}, "echo ';opcache.enable=0' >>  $prefix/php.d/20-extension-opcache.ini");
}

sub patchfiles {
	my $self = shift @_;
	return qw(php-entropy.patch);
	#return qw(php-entropy.patch php-entropy-imap.patch);
}

sub cflags {
	my $self = shift @_;
	my $supported_archs = join '/', $self->supported_archs();
	my $prefix = $self->config()->prefix();
	return $self->SUPER::cflags(@_) . qq( -no-cpp-precomp -DENTROPY_CH_ARCHS='\\"$supported_archs\\"' -DENTROPY_CH_RELEASE=) . $self->config()->release();
#-I$prefix/include
}

sub ldflags {
  my $self = shift @_;
  my $prefix = $self->config()->prefix();

  #-bind_at_load
  return "-L$prefix/lib " . $self->compiler_archflags();
}

sub cc {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();

	# - the -L forces our custom iconv before the apple-supplied one
	# - the -I makes sure the libxml2 version number for phpinfo() is picked up correctly,
	#   i.e. ours and not the system-supplied libxml
	return $self->SUPER::cc(@_) . " -L$prefix/lib -I$prefix/include -I$prefix/include/libxml2 -I$prefix/include/tidy -DENTROPY_CH_RELEASE=" . $self->config()->release();
}


1;
