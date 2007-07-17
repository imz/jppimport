#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt4'."\n");
    $jpp->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt3'."\n");
    $jpp->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt2'."\n");
    $jpp->get_section('package','')->unshift_body('Obsoletes: jakarta-regexp = 1.4-alt1'."\n");
    $jpp->get_section('package','')->push_body('Provides: jakarta-regexp = %{version}-%{release}'."\n");
}
