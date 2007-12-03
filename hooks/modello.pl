#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'\<\s*0:1.0-0.a9','<= alt3_0.a8.3jpp1.7',qr'Requires:');
}
