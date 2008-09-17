#!/usr/bin/perl -w

require 'set_bcond_convert.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst_if(qr'Obsoletes:','#Obsoletes:',qr'java_cup');
#    $jpp->get_section('package','')->subst_if(qr'Provides:','#Provides:',qr'java_cup');
}
