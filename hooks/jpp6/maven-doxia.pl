#!/usr/bin/perl -w

require 'set_fix_jpp_depmap_for_qdox12.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;

    # maven2-208-29
    $jpp->add_patch('maven-doxia-1.0-alt-remove-tagletartifact.patch', STRIP=>0);
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-plugin'."\n");

    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity14'."\n");
    #$jpp->get_section('package','')->subst_if(qr' < 0:1.0-0.3.a11','',qr'BuildRequires');
}