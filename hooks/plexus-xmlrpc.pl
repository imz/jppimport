#!/usr/bin/perl -w

require 'set_clean_surefire23.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xmlrpc2'."\n");
    $jpp->get_section('package','')->subst_body_if(qr'plexus-maven-plugin','plexus-containers-component-metadata',qr'Requires:');
}
