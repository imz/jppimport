#!/usr/bin/perl -w

$spechook = \&set_without_maven;

sub set_without_maven {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven maven-plugins'."\n");
}
