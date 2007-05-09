#!/usr/bin/perl -w

$spechook = \&set_bootstrap;

sub set_bootstrap {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");
    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version');
}
