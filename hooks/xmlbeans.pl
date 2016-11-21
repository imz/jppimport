#!/usr/bin/perl -w

push @SPECHOOKS, \&fix_svn;

sub fix_svn {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: subversion'."\n");
}

1;
