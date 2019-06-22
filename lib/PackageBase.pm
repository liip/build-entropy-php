package PackageBase;

use strict;
use warnings;
use base qw(Obj);
use File::Glob ':glob';

our $VERSION = '1.0';

sub init {
	my $self = shift @_;
	my (%args) = @_;

	$self->{dependencies} ||= [];

	foreach my $name ($self->dependency_names()) {
		my $class = 'Package::' . $name;
		eval "use $class";
		die if ($@);
		push @{$self->{dependencies}}, $class->new(config => $self->config());
	}
}

sub base_url {
	my ($self) = shift;
	Carp::croak(sprintf("class %s must override method %s", ref($self) || $self, (caller(0))[3]));
}

sub packagename {
	my ($self) = shift;
	Carp::croak(sprintf("class %s must override method %s", ref($self) || $self, (caller(0))[3]));
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.gz";
}

sub packagesrcdir {
	my $self = shift @_;
	return $self->config()->srcdir() . "/" . $self->packagename();
}

sub url {
	my $self = shift @_;
	return $self->base_url() . "/" . $self->filename();
}

sub download_path {
	my $self = shift @_;
	return $self->config()->downloaddir() . "/" . $self->filename();
}

# subclasses should override and call this and do
# nothing if this does not return true
#
sub build {
	my $self = shift @_;
	return undef if ($self->is_built());
	$self->unpack();
	$_->install() foreach $self->dependencies();
	$self->log("building");
	return 1;
}


sub is_built {
	my $self = shift @_;
	return undef;
}

# subclasses should override and call this and do
# nothing if this does not return true
#
sub install {
	my $self = shift @_;
	return undef if ($self->is_installed());
	$self->build();
	$self->log("installing");

	return 1;
}

sub is_installed {
	my $self = shift @_;
	return undef unless ($self->are_dependencies_installed());
	my $subpath = $self->subpath_for_check();
	my $exists = -e $self->install_prefix() . "/$subpath";
	$self->log("not installing because '$subpath' exists") if ($exists);
	return $exists;
}

sub are_dependencies_installed {
    my $self = shift @_;
    foreach ($self->dependencies()) {
        return undef unless ($_->is_installed());
    }
    return 1;
}

sub subpath_for_check {
	Carp::confess "subclasses must implement this method or provide a different is_installed() implementation"
}

sub dependency_names {
	return ();
}

sub dependencies {
	my $self = shift;
	return @{$self->{dependencies}};
}

sub is_downloaded {
	my $self = shift @_;
	return -f $self->download_path()
}

sub download {
	my $self = shift @_;
	$_->download() foreach $self->dependencies();
	return if ($self->is_downloaded());
	$self->log("downloading $self from " . $self->url());
   #     $self->shell('wget', '-O', $self->download_path(), $self->url());

       $self->shell('/usr/local/Cellar/curl/7.38.0/bin/curl', '-L -o', $self->download_path(), $self->url());

}

sub unpack {
	my $self = shift @_;

	return if ($self->is_unpacked());
	$self->download();
	$self->log('unpacking');
	$self->cd_srcdir();
	$self->extract();
	$self->patch();
}

sub is_unpacked {
	my $self = shift @_;
#	$self->log("is unpacked: " . $self->packagesrcdir() . ": " . -d $self->packagesrcdir());
	return -d $self->packagesrcdir();
}

sub extract {
	my $self = shift @_;
	$self->shell('tar -xzf', $self->download_path());
}

sub patch {
	my $self = shift @_;

	my @patchfiles = $self->patchfiles();
	return unless @patchfiles;

	$self->cd_packagesrcdir();
	foreach my $patchfile (@patchfiles) {
		my $path = $self->extras_path($patchfile);
		die "patch file '$patchfile' not found in package extras dir" unless (-f $path);
		$self->shell("patch -p1 < $path");
	}
}

sub patchfiles {
	return ();
}

sub cd_srcdir {
	my $self = shift @_;
	$self->cd($self->config()->srcdir());
}

sub cd_packagesrcdir {
	my $self = shift @_;
	$self->cd($self->packagesrcdir());
}

sub make_flags {
	my $self = shift @_;
	my $cpus = $self->config()->cpus();
	return $cpus > 1 ? " -j $cpus " : "";
}

sub make_command {
	my $self = shift @_;
	return "MACOSX_DEPLOYMENT_TARGET=10.10 make " . $self->make_flags();
}

sub make_install_override_list {
	my $self = shift @_;
	my (%args) = @_;
	my $extdir = $self->config()->extdir();
	return "prefix=$args{prefix} exec_prefix=$args{prefix} bindir=$args{prefix}/bin sbindir=$args{prefix}/sbin sysconfdir=$args{prefix}/etc datadir=$args{prefix}/share includedir=$args{prefix}/include libdir=$args{prefix}/lib libexecdir=$args{prefix}/libexec localstatedir=$args{prefix}/var sharedstatedir=$args{prefix}/com mandir=$args{prefix}/man infodir=$args{prefix}/info EXTENSION_DIR=$args{prefix}/$extdir";
}

sub configure_flags {
	my $self = shift @_;
	return "--prefix=" . $self->install_prefix();
}

sub shortname {
	my $self = shift @_;
	my $class = ref($self) || $self;
	my ($shortname) = $class =~ /::([^:]+)$/;

	return $shortname;

}

sub to_string {
	my $self = shift @_;
	my $shortname = $self->shortname();
	return "[package $shortname]";
}

sub extras_dir {
	my $self = shift @_;
	return $self->config()->basedir() . '/extras/' . $self->shortname();
}

sub extras_path {
	my $self = shift @_;
	my ($filename) = @_;
	return $self->extras_dir() . "/$filename";
}

sub cflags {
	my $self = shift @_;
	my $debugflag = $self->config()->debug() ? '-g -O' : '-Os';
	my $prefix = $self->config()->prefix();
	return "$debugflag -mmacosx-version-min=10.10 -I$prefix/include " . $self->compiler_archflags();
}

sub ldflags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return "-L$prefix/lib " . $self->compiler_archflags();
}

sub cc {
	my $self = shift @_;
	# this is a hack to override the shipping iconv.h header file with the one
	# from the darwin source. Fix taken from:
	# http://gorn.ch/archive/2007/11/01/leopard-native-apache-with-custom-64bit-php.html
	#my $iconv_include_override_dir = $self->config()->basedir() . "/extras/iconv/leopard-iconv-include-override";
	#return "cc -I$iconv_include_override_dir";
	return "cc";
}

sub compiler_archflags {
	my $self = shift @_;
	return join " ", map {"-arch $_"} $self->all_archs();
}

sub compiler_extraflags {
	# used to add EXTRA_CFLAGS to configure
	my $self = shift @_;
	return "";
}

sub install_prefix {
	my $self = shift @_;
	return $self->config()->prefix();
}

sub install_extension_dir {
        my $self = shift @_;
        return 'lib/php/extensions/no-debug-non-zts-20180731/';
}

sub full_install_extension_dir {
        my $self = shift @_;
        return $self->install_prefix() . '/' . $self->install_extension_dir();
}

# prefix for packages we don't want to bundle
sub install_tmp_prefix {
	my $self = shift @_;
	return $self->config()->basedir() . "/install-tmp";

}

sub php_build_pre {
}

sub supported_archs {
	return qw(i386 x86_64);
}

sub supports_arch {
	my $self = shift @_;
	my ($arch) = @_;
	return grep {$_ eq $arch} $self->supported_archs();
}

sub php_extension_configure_flags {
	return "";
}

sub php_dso_extension_names {
	return undef;
}

sub php_dso_extension_paths {
	my $self = shift;
	return map {$self->config()->extdir_path("$_.so")} $self->php_dso_extension_names();
}

sub php_build_arch_pre {
}

sub all_archs {
	return qw(x86_64);
}

1;
