#!/usr/bin/perl -w

$spechook = \&set_bootstrap_nohook;

sub set_bootstrap_nohook {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_hook 1'."\n");
    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version');
}
