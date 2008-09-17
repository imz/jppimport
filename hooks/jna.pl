#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # bug to report!
    $jpp->get_section('package','')->subst('BuildArch:','#BuildArch:');
    $jpp->get_section('install')->subst(qr'install\s-m\s644\sjnalib/build/','install -m 644 jnalib/build*/');
}
