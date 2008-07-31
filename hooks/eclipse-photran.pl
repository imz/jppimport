#!/usr/bin/perl -w

require 'set_fix_eclipse_dep.pl';
require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # alt specific
    $jpp->get_section('package','')->subst(qr'Requires:\s*gcc-gfortran','Requires: gcc-fortran');
};

