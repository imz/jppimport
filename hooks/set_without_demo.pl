#!/usr/bin/perl -w

push @SPECHOOKS, \&set_without_demo;
#$spechook = \&set_without_demo;

sub set_without_demo {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_demo 1'."\n");
}
