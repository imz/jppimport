#!/usr/bin/perl -w

push @SPECHOOKS, 
sub  {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('BuildRequires: rpm-build-java-osgi'."\n");
    $spec->get_section('package','')->unshift_body('AutoReq: yes,noosgi'."\n");
};
