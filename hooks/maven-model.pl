#!/usr/bin/perl -w

#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # fix when without maven1 (included in 2jpp)
    #$jpp->get_section('build')->subst(qr'maven-modello-plugin','maven-plugins/maven-modello-plugin');
};

1;
