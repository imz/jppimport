#!/usr/bin/perl -w

push @SPECHOOKS, \&fix_xsltproc;

sub fix_xsltproc {
    my ($spec,) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: xsltproc'."\n");
}

1;
