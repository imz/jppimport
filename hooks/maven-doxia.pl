#!/usr/bin/perl -w

#require 'set_without_maven.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body('BuildRequires: rhino modello-maven-plugin'."\n");
}
