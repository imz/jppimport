#!/usr/bin/perl -w

require 'set_bin_755.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;

    $jpp->disable_package('jedit');


#    $jpp->get_section('package','')->subst(qr'\%define native  \%{\?_with_native:1}\%{!\?_without_native:0}', 	'%define native 0');
#    $jpp->disable_package('native');
#    $jpp->set_changelog('- imported with jppimport script; note: w/o native');

# ---------------------- or ----------------
# bug to report
# if w/native w/o gcc should be arch!
    #$jpp->get_section('package','')->subst(qr'\%configure', 	'%configure --build=');
    $jpp->get_section('package','')->subst(qr'BuildArch:\s*noarch', '##BuildArch: noarch');
    $jpp->get_section('package','')->unshift_body("BuildRequires: gcc-c++\n");
}
