#!/usr/bin/perl -w

#require 'set_split_gcj_support.pl';
#require 'set_without_maven.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->unshift_body('BuildRequires: rhino'."\n");
}
