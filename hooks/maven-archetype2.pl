#!/usr/bin/perl -w

require 'set_jetty6_servlet_25_api.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: modello-maven-plugin'."\n");
}
