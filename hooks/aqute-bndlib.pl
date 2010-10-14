#!/usr/bin/perl -w

#require 'set_eclipse_core_plugins.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst(qr'Requires: ecj','Requires: eclipse-ecj');
#    $jpp->get_section('package','')->unshift_body('BuildRequires: eclipse-jdt'."\n");
}
