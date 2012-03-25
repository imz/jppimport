#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%define _without_online_tests 1'."\n");
    $jpp->get_section('build')->unshift_body_after(qr'mvn-jpp','-Dmaven.test.skip=true \\'."\n");
    $jpp->add_patch('ws-woden-1.0M8_20080423-alt-drop-maven-one-plugin.patch',STRIP=>0);
}
