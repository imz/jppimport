#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Requires: jakarta-commons-logging'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: jakarta-commons-logging'."\n");
}
