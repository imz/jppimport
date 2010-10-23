#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    # tmp hack till ant18 migration
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-log4j'."\n");
}
