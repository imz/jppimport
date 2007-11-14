#!/usr/bin/perl -w

require 'set_without_maven.pl';

$spechook = sub {
    my ($jpp, $alt) = @_;
    # fix when with maven1
    $jpp->get_section('build')->subst(qr'maven-modello-plugin','maven-plugins/maven-modello-plugin');
};

1;
