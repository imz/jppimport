#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'< 0:1\.6\.2', '>= 1.6.1',qr'Requires:');
    $jpp->get_section('package','')->subst_if(qr'wadi2', 'wadi-core',qr'Requires:');

}
