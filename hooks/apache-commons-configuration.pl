#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-poi'."\n");
};