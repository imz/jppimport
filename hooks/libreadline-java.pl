#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'readline-devel', 'libreadline-devel');
    $jpp->get_section('package','')->subst(qr'%{_libdir}/libtermcap.so', 'libtinfo-devel');
    $jpp->get_section('prep','')->push_body('%__subst s,termcap,tinfo, src/native/Makefile'."\n");
    $jpp->get_section('package','')->subst(qr'^AutoReqProv:', '##AutoReqProv:');
    $jpp->get_section('package','')->subst(qr'^Requires: readline', '##Requires: readline');
    #$jpp->get_section('package','')->set_tag('Release',"alt2_11jpp1.7");
}
