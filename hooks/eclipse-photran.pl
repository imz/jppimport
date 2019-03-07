#!/usr/bin/perl -w

require 'set_add_java_bin.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # alt specific
    $spec->get_section('package','')->subst_body_if(qr'gcc-gfortran','gcc-fortran',qr'Requires:');
};

