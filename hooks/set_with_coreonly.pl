#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_sf_plugins;

sub set_without_sf_plugins {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _with_coreonly 1'."\n");
}
