#!/usr/bin/perl -w

#require 'set_.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires: xalan-j2'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: xalan-j2'."\n");
    #$jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
}
