#!/usr/bin/perl -w

push @SPECHOOKS, \&set_bootstrap;

sub set_bootstrap {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _bootstrap 1'."\n");
    $jpp->get_section('package','')->unshift_body('%define _with_bootstrap 1'."\n");
    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version');
}