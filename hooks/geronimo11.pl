#!/usr/bin/perl -w

push @SPECHOOKS, \&set_bootstrap;

sub set_bootstrap {
    my ($jpp, $alt) = @_;
# buggy spec
    $jpp->get_section('package','')->unshift_body('%define _bootstrap1 1'."\n");
    $jpp->get_section('package','')->unshift_body('%define _with_bootstrap1 1'."\n");
# bug to report
# Пакет не существует: %post server-base
    $jpp->disable_package('server-base');

    $jpp->set_changelog('- imported with jppimport script; note: bootstrapped version');
}
