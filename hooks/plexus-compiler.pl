#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\', qr'mvn-jpp');

}
