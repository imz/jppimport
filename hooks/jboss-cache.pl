#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%def_with jdk6'."\n");
    $jpp->add_patch('jboss-cache-1.4.1-alt-berkeleydb-3.0.12.patch', STRIP => 1);
}
