#!/usr/bin/perl -w
require 'set_fix_eclipse_dep.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'%define cs_ver 4.1','%define cs_ver 4.3');
# done
#    $jpp->get_section('package','')->subst(qr'%define eclipse_ver 3.2','%define eclipse_ver 3.3');
};

