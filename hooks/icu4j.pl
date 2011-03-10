#!/usr/bin/perl -w

require 'set_osgi.pl';
require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    #$jpp->get_section('prep')->push_body(q!subst 's,compiler="javac1.3",,' build.xml!."\n");
    $jpp->get_section('package','')->subst(qr'java-javadoc >= 1:1.6.0','java-javadoc');
    $jpp->get_section('package','javadoc')->subst(qr'java-javadoc >= 1:1.6.0','java-javadoc');
}
