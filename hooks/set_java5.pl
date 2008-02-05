#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'BuildRequires:\s*jpackage-1.4-compat','BuildRequires: jpackage-1.5-compat');
    $jpp->get_section('package','')->unshift_body("%define _with_java5 1\n");
}
