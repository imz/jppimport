#!/usr/bin/perl -w

#require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package')->subst(qr'^Requires: maven2-bootstrap','#Requires: maven2');
    $jpp->get_section('package')->push_body('Provides: maven2-plugin-release = 2.0.7'."\n");
    $jpp->get_section('package','',)->push_body('BuildRequires: modello-maven-plugin saxpath'."\n");

    # bug? to report in jpp5 when _without_maven
    # check after rebuild world
    $jpp->get_section('build')->subst(qr'plexus/classworlds', 'plexus/classworlds classworlds');
}
