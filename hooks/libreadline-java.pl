#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'readline-devel', 'libreadline-devel');
    $jpp->get_section('package','')->subst(qr'%{_libdir}/libtermcap.so', 'libtinfo-devel');
    $jpp->get_section('prep','')->push_body('%__subst s,termcap,tinfo, src/native/Makefile'."\n");
    termcap
}
