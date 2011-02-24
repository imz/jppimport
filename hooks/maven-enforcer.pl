#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven-plugin-tools-javadoc'."\n");
    $jpp->get_section('package','')->subst_if(qr'maven2-plugin-plugin','maven-plugin-tools',qr'Requires:');
}
