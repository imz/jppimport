#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('maven-plugin-modello','modello-maven-plugin',qr'Requires:');
    #$jpp->get_section('package','')->push_body('BuildRequires: rhino'."\n");
    $jpp->get_section('package','')->push_body('BuildRequires: velocity14'."\n");
    #$jpp->get_section('package','')->subst_if(qr' < 0:1.0-0.3.a11','',qr'BuildRequires');
}
