#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_maven;
#$spechook = \&set_without_maven;

sub set_without_maven {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_maven 1'."\n");
}
