#!/usr/bin/perl -w

require 'set_target_14.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->unshift_body('
# for PermGen error, running out of memory
export MAVEN_OPTS=-XX:MaxPermSize=512m
    ');
};
