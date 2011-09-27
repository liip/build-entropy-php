package Config;

use base qw(Obj);

use strict;
use warnings;

our $VERSION = '1.0';


sub init {

	my $self = shift @_;
	
	$self->{$_} ||= undef foreach qw(basedir downloaddir);
	$self->makedirs();
	
}


sub downloaddir {
	my $self = shift @_;
	return $self->basedir() . '/download';
}

sub srcdir {
	my $self = shift @_;
	return $self->basedir() . '/src';
}





sub makedirs {

	my $self = shift @_;

	my @dirs = (
		$self->downloaddir(),
		$self->prefix(),
		$self->srcdir(),
	);

	foreach my $dir (@dirs) {
		die "Unable to mkdir() '$dir'" unless (-d $dir or mkdir($dir));
	}
		
	return undef;

}



sub zend_module_api_no {
	my $self = shift @_;
	my $srcdir = $self->phpsrcdir();
	#my $value = qx(grep 'define ZEND_MODULE_API_NO' $srcdir/php*/Zend/zend_modules.h | cut -f 3 -d ' ');
	my $value = qx(grep 'define ZEND_MODULE_API_NO' $srcdir/Zend/zend_modules.h | cut -f 3 -d ' ');
	chomp($value);
	die "Unable to find zend module api no, PHP source dir not yet unpacked?" unless ($value);
	return $value;
}

sub extdir {
	my $self = shift @_;
	return 'lib/php/extensions/no-debug-non-zts-' . $self->zend_module_api_no();
}

sub extdir_path {
	my $self = shift @_;
	my ($filename) = @_;
	return $self->extdir() . "/$filename";
}

#sub extension_dir {
#	my $self = shift @_;
#	my $srcdir = $self->srcdir();
#	my $value = qx(grep 'EXTENSION_DIR =' $srcdir/php-*/Makefile | cut -f 3 -d ' ');
#	chomp($value);
#	die "Unable to find EXTENSION_DIR, PHP source dir not yet unpacked?" unless ($value);
#	return $value;
#}









1;

