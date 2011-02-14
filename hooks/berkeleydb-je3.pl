#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # missing def of reltag
    $jpp->get_section('package')->unshift_body('%define reltag GA'."\n");

    # removed conflict :( TODO: pom is missing!! in je3! TODO: merge 2 packages 
    $jpp->get_section('install')->subst(qr'je-\%{version}.jar','je3-%{version}.jar');
    $jpp->get_section('install')->subst(qr'\%{_javadir}/je.jar','%{_javadir}/je3.jar');
    $jpp->get_section('files')->subst(qr'je-\%{version}.jar','je3-%{version}.jar');
    $jpp->get_section('files')->subst(qr'\%{_javadir}/je.jar','%{_javadir}/je3.jar');

};
