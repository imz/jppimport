#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: itext'."\n");
    $jpp->get_section('install')->subst_if(qr' -doc-renderer',' doc-renderer',qr'add_to_maven_depmap');
    $jpp->get_section('package','')->subst_if(qr' < 0:1.0-0.3.a11','',qr'BuildRequires');
}
