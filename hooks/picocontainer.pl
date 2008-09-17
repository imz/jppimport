#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-project-info-reports maven-scm maven2-default-skin'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: excalibur excalibur-avalon-framework'."\n");
}
