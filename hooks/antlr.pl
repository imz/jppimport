#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: gcc-c++\n");
    $jpp->get_section('package','')->subst(
    qr'\%define native  \%{\?_with_native:1}\%{!\?_without_native:0}', 	'%define native 0');
    $jpp->set_changelog('- imported with jppimport script; note: w/o native')

}
