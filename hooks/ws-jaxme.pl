#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: xmldb-api-sdk'."\n");
    $jpp->get_section('package','')->unshift_body('Requires: xmldb-api-sdk'."\n");
}
