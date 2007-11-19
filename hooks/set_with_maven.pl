#!/usr/bin/perl -w

push @SPECHOOKS, \&set_with_maven;

sub set_with_maven {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _with_maven 1'."\n");
}
