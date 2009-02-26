#!/usr/bin/perl -w

#require 'set_velocity14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#   $jpp->get_section('package','')->unshift_body('BuildRequires: maven-scm mojo-maven2-plugin-jdepend maven2-plugin-jxr'."\n");
}
