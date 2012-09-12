#!/usr/bin/perl -w

use strict;
use warnings;

use File::Find;

my $buildroot=$ARGV[0];

my %liblink;

find({wanted=>\&wanted,
dangling_symlinks => 1,
no_chdir => 1,
}, $buildroot.'/usr/share');

foreach my $sharepath (keys %liblink) {
    my $libpath=$liblink{$sharepath};
    system ('mv', '-f', $buildroot.$libpath, $buildroot.$sharepath)==0 or die "$!: mv $buildroot$libpath, $buildroot$sharepath failed.";
    system ('ln', '-s', $sharepath, $buildroot.$libpath)==0 or die "$!: ln -s $sharepath $buildroot$libpath failed.";
    print "symFIX: corrected: $libpath -> $sharepath\n";
}

sub wanted {
    my $chrootname=$File::Find::name;
    return unless -l $chrootname;
    my $val=readlink($chrootname);
    if ($val=~s!^(?:\.\.|/usr)/lib!/usr/lib!) {
	$chrootname=~s/^$buildroot//;
	$liblink{$chrootname}=$val;
	die "Oops: libdir destination $val is also a link :(" if -l $buildroot.'$val';
    }
}
