#!/usr/bin/perl -w

#require 'set_excalibur_pom.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst_if(qr'1\.6\.2', '1.6.4',qr'Requires:');
    $jpp->get_section('package','')->subst_if(qr'wadi2', 'wadi-core',qr'Requires:');

}
