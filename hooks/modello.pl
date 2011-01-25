#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jaxb_2_1_api'."\n"); #saxpath
#    $jpp->get_section('package','')->subst_if(qr'\<\s*0:1.0-0.a9','<= 1.0-alt3_0.a8.3jpp1.7',qr'Requires:');
}
