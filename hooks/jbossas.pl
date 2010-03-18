#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(qr'antlr-repolib = 0:2.7.6','antlr-repolib >= 0:2.7.6');
    $jpp->get_section('package','')->subst(qr'bcel-repolib = 0:5.1','bcel-repolib >= 0:5.1');
    $jpp->get_section('package','')->subst(qr'bsf-repolib = 0:2.3.0','bsf-repolib >= 0:2.3.0');
    $jpp->get_section('package','')->subst(qr'junit-repolib = 0:3.8.2','junit-repolib = 1:3.8.2');
    $jpp->get_section('package','')->subst(qr'qdox-repolib = 0:1.6.1','qdox-repolib = 1:1.6.1');
    $jpp->get_section('package','')->subst(qr'xerces-j2-repolib = 0:2.7.1','xerces-j2-repolib = 0:2.9.0');
    $jpp->get_section('package','')->subst(qr'jakarta-commons-collections-repolib = 0:3.1','jakarta-commons-collections-repolib >= 0:3.1');
}

