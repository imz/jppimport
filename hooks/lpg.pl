#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: gcc-c++'."\n");
};
