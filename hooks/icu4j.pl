#!/usr/bin/perl -w

require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->push_body(q!subst 's,compiler="javac1.3",,' build.xml!."\n");
}