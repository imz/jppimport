#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_online_tests 1'."\n");
    $jpp->get_section('build')->unshift_body2_after('-Dmaven.test.skip=true \\', qr'mvn-jpp');

}
