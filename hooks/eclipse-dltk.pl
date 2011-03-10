#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('prep')->subst_if(qr'_javadir}/h2.jar','_javadir}/h2database.jar',qr'ln -s');
};

