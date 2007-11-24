#!/usr/bin/perl -w

push @SPECHOOKS, 

sub {
    my ($jpp, $alt) = @_;
    # hack ! geronimo poms !
    $jpp->get_section('package','')->unshift_body('BuildRequires: geronimo-specs-poms'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: junitperf'."\n");
}
