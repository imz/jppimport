#!/usr/bin/perl -w

push @SPECHOOKS, 
sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: rpm-build-java-osgi'."\n");
    $jpp->get_section('package','')->unshift_body('AutoReq: yes,noosgi'."\n");
};
