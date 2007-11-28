#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # hack ! geronimo poms !
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: junitperf'."\n");
    # tests fails :(
    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\', qr'mvn-jpp');

}
