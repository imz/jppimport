#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: mojo-maven2-plugin-cobertura maven2-plugin-project-info-reports maven-scm maven2-default-skin cobertura maven2-plugin-source maven2-plugin-release maven2-plugin-dependency'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: excalibur excalibur-avalon-framework avalon-framework'."\n");
    # i am bored to mention them all :(
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugins'."\n");

}
