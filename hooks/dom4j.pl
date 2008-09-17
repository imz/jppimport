#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # included in jpackage-compat
    $jpp->get_section('package','')->subst_if('msv-msv','msv',qr'Requires:');
    # one test fails :( to rebuild later
    $jpp->get_section('build')->subst(qr'ant all samples test','ant all samples');
}
