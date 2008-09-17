#!/usr/bin/perl -w

require 'set_bcond_convert.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if(qr'java_cup','java-cup',qr'Requires:');
}
