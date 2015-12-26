package Package::icu;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '56.1';

sub base_url {
	return "http://download.icu-project.org/files/icu4c/" . $VERSION;
}

sub packagename {
	my $vers = $VERSION;
	$vers =~ s/\./_/g;
	# icu4c-4_6-src.tgz
	return "icu4c-" . $vers . "-src";
}

sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tgz";
}

sub extract {
	my $self = shift @_;
	$self->shell('tar -xzf', $self->download_path());
	## patch config/mh-darwin to contain
	## LD_SONAME ... $(libdir)/$(notdir $(MIDDLE_SO_TARGET))
	$self->cd_packagesrcdir();
	$self->shell('mv config/mh-darwin config/mh-darwin.org');
	my $src = $self->packagesrcdir();
    $self->shell({silent => 0}, "sed 's|\$(notdir \$(MIDDLE_SO_TARGET))|\$(libdir)\/\$(notdir \$(MIDDLE_SO_TARGET))|' " . $src . "/config/mh-darwin.org >" . $src . "/config/mh-darwin");
}

sub packagesrcdir {
	my $self = shift @_;
	return $self->config()->srcdir() . "/icu/source"; 
}

sub subpath_for_check {
	return "lib/libicui18n.dylib";
}

sub build_configure {
	my $self = shift @_;
	my $cflags = $self->cflags();
	my $ldflags = $self->ldflags();
	my $cxxflags = $self->compiler_archflags();
	my $archflags = $self->compiler_archflags();
	my $cc = $self->cc();
	
	$self->shell(qq(MACOSX_DEPLOYMENT_TARGET=10.6 CFLAGS="-mmacosx-version-min=10.6 -arch x86_64" LDFLAGS="-arch x86_64" CXXFLAGS="-arch x86_64" ./runConfigureICU MacOSX --with-library-bits=64 --disable-samples --enable-static ) . $self->configure_flags());
}

sub make_command {
	my $self = shift @_;
	return "make";
}

sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-icu-dir=" .	$self->config()->prefix(); #. " --enable-intl"
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(lib/libicudata*.dylib lib/libicui18n*.dylib lib/libicuio*.dylib lib/libicule*.dylib lib/libiculx*.dylib lib/libicutu*.dylib lib/libicuuc*.dylib lib/icu);
}

1;
