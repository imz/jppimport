#!/usr/bin/perl -w

push @SPECHOOKS, \&fix_svn;

sub fix_svn {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: subversion'."\n");
}

1;
