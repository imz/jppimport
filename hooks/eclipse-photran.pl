#!/usr/bin/perl -w

require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # alt specific
    $jpp->get_section('package','')->subst_if(qr'gcc-gfortran','gcc-fortran',qr'Requires:');
};

