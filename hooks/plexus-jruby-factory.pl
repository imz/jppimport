#!/usr/bin/perl -w

#require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: asm2'."\n");
#    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugins'."\n");
}