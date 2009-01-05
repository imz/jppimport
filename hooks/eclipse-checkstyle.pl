#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'%define cs_ver 4.1','%define cs_ver 4.3');
    $jpp->get_section('package','')->subst_if(qr'checkstyle','checkstyle4',qr'Requires:');
    # TODO: fix checkstyle5 issues!
};

