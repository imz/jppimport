#!/usr/bin/perl -w

require 'set_excalibur_pom.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jetty5 mojo-maven2-plugin-dependency geronimo-jta-1.0.1B-api geronimo-specs-poms derby'."\n");
}
