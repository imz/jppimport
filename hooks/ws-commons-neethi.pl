#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # no need to keep 2 wstx'es
    $jpp->get_section('package','')->subst_if('wstx32','wstx',qr'Requires:');
    #s,wstx32,wstx, jpp-depmap
    $jpp->get_section('package')->unshift_body('BuildRequires: velocity15'."\n");
}
