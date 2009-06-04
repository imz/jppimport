#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: myfaces'."\n");
    $jpp->get_section('build')->subst(qr'128M', '256M');
    $jpp->get_section('build')->subst(qr'classpath bouncycastle/bcprov', 'classpath bcprov');
}
