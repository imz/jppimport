#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('Obsoletes: wagon = 1.0-alt0.3.alpha5'."\n");
};


#require 'set_without_maven2.pl'
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: avalon-framework'."\n");
    # fixes in case set_without_maven2
    # disables ant tests
    $jpp->get_section('prep')->unshift_body(q[find . -name build.xml -exec subst 's!depends="compile,test"!depends="compile"!' {} \;]."\n");
};

